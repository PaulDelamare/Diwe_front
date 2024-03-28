import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final Function(String currentValue) onSelectionChanged;
  final String? error;

  _CheckboxWidgetState createState() => _CheckboxWidgetState();

  const CheckboxWidget({
    Key? key,
    required this.onSelectionChanged,
    this.error
  }) : super(key: key);
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool isPatient = false;
  bool isProfessional = false;
  String? currentValue = null;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
    Row(
      children: [ Expanded(
        child:
          Theme(
          data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.transparent,
          checkboxTheme: CheckboxThemeData(
          shape: CircleBorder(),
          fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.orange;
            }
            return Colors.white;
          }),
          checkColor: MaterialStateProperty.all(Colors.transparent),
        ),
      ),
      child: CheckboxListTile(
        title: Text('Patient', style: TextStyle(color: Colors.white),),
        value: isPatient,
        onChanged: (bool? value) {
          setState(() {
            isPatient = value!;
            if(isPatient == true){
              isProfessional = false;
            }
            currentValue = 'user';
            widget.onSelectionChanged(currentValue!);
          });
        },
      ),
    ), flex: 5,),
    Expanded(child:
      Theme(
        data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.transparent,
        checkboxTheme: CheckboxThemeData(
          shape: CircleBorder(),
          fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.orange;
            }
            return Colors.white;
          }),
          checkColor: MaterialStateProperty.all(Colors.transparent),
        ),
        ),
        child: CheckboxListTile(
          title: Text('Professionel', style: TextStyle(color: Colors.white),),
          value: isProfessional,
          onChanged: (bool? value) {
            setState(() {
              isProfessional = value!;
              if(isProfessional == true){
                isPatient = false;
              }
              widget.onSelectionChanged(currentValue!);
              currentValue = 'health';
            });
          },
        ),
      ),
      flex: 5,
    )
    ],),
      if (widget.error != null)
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            widget.error!,
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
    ],);
  }
}

