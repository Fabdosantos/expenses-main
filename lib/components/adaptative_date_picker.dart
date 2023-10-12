import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateChanged;

  const AdaptativeDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  _showDataPicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedData) {
      if (pickedData == null) {
        return;
      }
      onDateChanged(pickedData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? SizedBox(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2020),
              maximumDate: DateTime.now(),
              onDateTimeChanged: onDateChanged,
            ),
          )
        : SizedBox(
            height: 70,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? 'Nenhuma Data Selecionada!'
                        : 'Data Selecionada: ${DateFormat('dd/MM/y').format(selectedDate!)}',
                  ),
                ),
                TextButton(
                  child: Text(
                    'Selecionar Data',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () => _showDataPicker(context),
                ),
              ],
            ),
          );
  }
}
