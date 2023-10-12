import 'package:expenses/components/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';

import './components/transaction_form.dart';
import './components/transaction_list.dart';
import 'models/transaction.dart';

main() => runApp(const ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          errorColor: Colors.red,
          accentColor: Colors.amber,
        ),
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    // Transaction(
    //   id: "t0",
    //   title: "Conta de Luz",
    //   value: 100.00,
    //   date: DateTime(2023, 6, 07),
    // ),
    // Transaction(
    //   id: "t1",
    //   title: "Conta de Água",
    //   value: 150.00,
    //   date: DateTime(2023, 6, 09),
    // ),
    // Transaction(
    //   id: "t2",
    //   title: "Internet",
    //   value: 100.00,
    //   date: DateTime(2023, 6, 10),
    // ),
    // Transaction(
    //   id: "t3",
    //   title: "Cartao de Credito",
    //   value: 178.67,
    //   date: DateTime(2023, 6, 08),
    // ),
    // Transaction(
    //   id: "t4",
    //   title: "Reno",
    //   value: 200.00,
    //   date: DateTime(2023, 6, 07),
    // ),
    // Transaction(
    //   id: "t5",
    //   title: "Compras",
    //   value: 300.00,
    //   date: DateTime(2023, 6, 06),
    // ),
    // Transaction(
    //   id: "t6",
    //   title: "Roupas",
    //   value: 200.00,
    //   date: DateTime(2023, 6, 05),
    // ),
  ];

  bool _showChart = false;

  List<Transaction> get recentTransaction {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  Widget _getIconButton(IconData icon, void Function()? fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final actions = <Widget>[
      if (isLandscape)
        _getIconButton(
          _showChart ? iconList : chartList,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add,
        () => _openTransactionFormModal(context),
      ),
    ];

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Despesas Pessoais'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          )
        : AppBar(
            title: Text(
              'Despesas Pessoais',
              style: TextStyle(
                fontSize: 20 * MediaQuery.of(context).textScaleFactor,
              ),
            ),
            actions: actions,
          ) as PreferredSizeWidget;

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // if (isLandscape)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Text('Exibir Gráfico'),
            //       Switch.adaptive(
            //         activeColor: Theme.of(context).colorScheme.error,
            //         value: _showChart,
            //         onChanged: (value) {
            //           setState(() {
            //             _showChart = value;
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            if (_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * (isLandscape ? 0.8 : 0.3),
                child: Chart(recentTransaction),
              ),
            if (!_showChart || !isLandscape)
              SizedBox(
                height: availableHeight * (isLandscape ? 1 : 0.7),
                child: TransactionsList(_transactions, _removeTransaction),
              )
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: const Text('Despesas pessoais'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions,
                      ),
                    ),
                    child: bodyPage,
                  )
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
