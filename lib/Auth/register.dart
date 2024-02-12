import 'package:flutter/material.dart';

class _RegisterPageState extends State<RegisterPage>{
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageState = 0;

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _verifyAndProceed( dynamic formData ) async{
    final isValid = await _verifyFormData(formData);
    if(isValid){
      setState(() {
        _currentPageState++;
      });
    }else{
      print('Les données ne sont pas valides. Vérification API échouée.');
    }

  }

  Future<bool> _verifyFormData( dynamic formData ) async{
    return true;
  }
}
