import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class InputFormCustom extends StatefulWidget {
  final String placeholder;
  final String? inputType;
  final TextEditingController controller;
  final String? error;
  final bool? isRequired;

  const InputFormCustom({
    Key? key,
    required this.placeholder,
    this.inputType,
    required this.controller,
    this.error,
    this.isRequired,
  }) : super(key: key);

  @override
  _InputFormCustomState createState() => _InputFormCustomState();
}

class _InputFormCustomState extends State<InputFormCustom> {
  bool obscureText = false;
  TextInputType textInputType = TextInputType.text;
  List<TextInputFormatter>? inputFormatters;

  @override
  void initState() {
    super.initState();
    _initializeInputSettings();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void _initializeInputSettings() {
    switch (widget.inputType) {
      case 'date':
        textInputType = TextInputType.datetime;
        break;
      case 'password':
        obscureText = true;
        break;
      case 'number':
        textInputType = TextInputType.phone;
        inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        break;
      case 'text':
      default:
        textInputType = TextInputType.text;
        break;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        widget.controller.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: widget.placeholder,
                suffixIcon: widget.inputType == 'date'
                    ? IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              keyboardType: textInputType,
              obscureText: obscureText,
              inputFormatters: inputFormatters,
              onTap: widget.inputType == 'date' ? () => _selectDate(context) : null,
            ),
          ),
          if (widget.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.error!,
                style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
