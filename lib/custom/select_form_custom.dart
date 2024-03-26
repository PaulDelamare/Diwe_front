import 'package:flutter/material.dart';

class SelectFormCustom extends StatefulWidget {
  final List<String> options;
  final String? error;
  final Function(String?) onSelected;
  final String defaultValue;

  const SelectFormCustom({
    Key? key,
    required this.options,
    this.error,
    required this.onSelected,
    required this.defaultValue,
  }) : super(key: key);

  @override
  _SelectFormCustomState createState() => _SelectFormCustomState();
}

class _SelectFormCustomState extends State<SelectFormCustom> {
  String? currentValue;

  void initSate(){
    super.initState();
    currentValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(20)
            ),
            child: DropdownButtonFormField<String>(
              value: currentValue,
              decoration: InputDecoration(
                errorText: widget.error,
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  currentValue = newValue;
                });
                widget.onSelected(newValue);
              },
              items: widget.options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value == widget.defaultValue ? null : value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text(widget.defaultValue),
            ),
          ),

          if (widget.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                widget.error!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
