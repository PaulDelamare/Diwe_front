import 'package:diwe_front/Custom/input_form_custom.dart';
import 'package:diwe_front/Custom/register_step_custom.dart';
import 'package:diwe_front/Custom/select_form_custom.dart';
import 'package:diwe_front/Custom/submit_form_register.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController checkPasswordController = TextEditingController();

  int _currentPageState = 1;

  String? nameError;
  String? firstNameError;
  String? emailError;
  String? birthDateError;
  String? numberError;
  String? selectedOption;
  String? passwordError;
  String? checkPasswordError;


  String? validateName(String name) {
    if (name.isEmpty) {
      return 'Le nom ne peut pas être vide';
    } else if (RegExp(r'\d').hasMatch(name)) {
      return 'Le nom ne peut pas contenir de chiffres';
    } else if (name.length <= 1) {
      return 'Le nom doit contenir plus d\'un caractère';
    }
    return null;
  }

  String? validateFirstName(String firstName) {
    if (firstName.isEmpty) {
      return 'Le nom ne peut pas être vide';
    } else if (RegExp(r'\d').hasMatch(firstName)) {
      return 'Le nom ne peut pas contenir de chiffres';
    } else if (firstName.length <= 1) {
      return 'Le nom doit contenir plus d\'un caractère';
    }
    return null;
  }

  String? validateEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );

    if (email.isEmpty) {
      return 'L\'adresse e-mail ne peut pas être vide';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Entrez une adresse e-mail valide';
    }
    return null;
  }

  String? validateBirthDate(String birthDate) {
    if (birthDate.isEmpty) {
      return 'La date de naissance ne peut pas être vide';
    }

    final RegExp dateRegExp = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!dateRegExp.hasMatch(birthDate)) {
      return 'Le format doit être JJ/MM/AAAA';
    }

    try {
      final List<String> parts = birthDate.split('-');
      final int day = int.parse(parts[0]);
      final int month = int.parse(parts[1]);
      final int year = int.parse(parts[2]);
      final DateTime birthDateTime = DateTime(year, month, day);

      final DateTime now = DateTime.now();
      if (birthDateTime.isAfter(now) || year < 1900) {
        return 'Date de naissance non plausible';
      }

    } catch (e) {
      return 'Date invalide';
    }

    return null;
  }

  String? isValidPhoneNumber(String phoneNumber) {
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
    final RegExp phoneRegex = RegExp(r'^\d{10}$');
    if(phoneRegex.hasMatch(cleanedNumber) == false){
      return 'Le numéro de téléphone est incorect';
    }
    return null;
  }

  String? validatePassword(String password){
    if(password.isEmpty){
      return 'Le mot de passe ne peut pas être vide';
    }
    int passwordLength = password.length;
    if(passwordLength < 5 ){
      return 'Le mot de passe est trop court';
    }
    return null;
  }

  String? validateCheckPassword(String checkPassword){
    if(checkPassword != passwordController.text){
      return 'Les mots de passes ne sont pas identique';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    _pageController.dispose();
    nameController.dispose();
    firstNameController.dispose();
    emailController.dispose();
    birthDateController.dispose();
    numberController.dispose();
    passwordController.dispose();
    checkPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    bool hasError = false;
    String? newNameError = validateName(nameController.text);
    String? newFirstNameError = validateFirstName(firstNameController.text);
    String? newEmailError = validateEmail(emailController.text);
    String? newPasswordError = validatePassword(passwordController.text);
    String? newCheckPasswordError = validateCheckPassword(checkPasswordController.text);

    if (newNameError != null || newFirstNameError != null || newEmailError != null || newPasswordError != null || newCheckPasswordError != null) {
      hasError = true;
    }

    setState(() {
      nameError = newNameError;
      firstNameError = newFirstNameError;
      emailError = newEmailError;
      passwordError = newPasswordError;
      checkPasswordError = newCheckPasswordError;

      if (!hasError && _currentPageState < 2) {
        _currentPageState++;
      }
    });

    if (hasError) {
      return;
    }
  }

  void _submitForm() {
    bool hasError = false;
    String? newBirthDateError = validateBirthDate(birthDateController.text);
    String? newNumberError = isValidPhoneNumber(numberController.text);

    if (newBirthDateError != null || newNumberError != null) {
      hasError = true;
    }

    setState(() {
      birthDateError = newBirthDateError;
      numberError = newNumberError;
    });

    if (_currentPageState == 2 && !hasError) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Récapitulatif de Soumission'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Nom: ${nameController.text}'),
                  Text('Prénom: ${firstNameController.text}'),
                  Text('Email: ${emailController.text}'),
                  Text('Mot de passe: ${passwordController.text}'),
                  Text('Date de naissance: ${birthDateController.text}'),
                  Text('Numéro de Tel: ${numberController.text}'),
                  Text('Option sélectionnée: $selectedOption'),

                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    List<Widget> stepOneWidgets = [
      RegisterStepCustom(stepNumberLeft: '1', stepNumberRight: ''),
      InputFormCustom(placeholder: 'Nom', inputType: 'text', controller: nameController, error: nameError,),
      InputFormCustom(placeholder: 'Prénom', inputType: 'text', controller: firstNameController, error: firstNameError,),
      InputFormCustom(placeholder: 'Email', inputType: 'text', controller: emailController, error: emailError,),
      InputFormCustom(placeholder: 'Mot de passe', inputType: 'password', controller: passwordController, error: passwordError,),
      InputFormCustom(placeholder: 'Confirmer le Mot de passe', inputType: 'password', controller: checkPasswordController, error: checkPasswordError,),
      SubmitForm(buttonText: 'Suivant', backgroundColor: 0xFF004396, onPressed: _nextStep ,)
    ];

    List<String> selectOptions = [
      'Homme',
      'Femme',
    ];

    List<Widget> stepTwoWidgets = [
      RegisterStepCustom(stepNumberLeft: '', stepNumberRight: '2'),
      InputFormCustom(placeholder: 'JJ/MM/AAAA', inputType: 'date', controller: birthDateController, error: birthDateError,),
      InputFormCustom(placeholder: 'Telephone', inputType: 'number', controller: numberController, error: numberError,),
      SelectFormCustom(options: selectOptions, onSelected: (value){selectedOption = value;}, defaultValue: 'Sexe', error: '',),
      SubmitForm(backgroundColor: 0xFF004396, buttonText: 'Envoyé', onPressed: _submitForm)
    ];

    return Scaffold(
      body:
        Container(
          height: screenHeight,
          decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff004396),
            Color(0xff0C8CE9),
            ],
          ),
        ),
        child:
          SingleChildScrollView(
              child:
                Container(
                  child:
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Text('INSCRIPTION', style: TextStyle( fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('Etapes', style: TextStyle( fontSize: 20, color: Colors.white),),
                        ),
                      ),
                      ...(_currentPageState == 1 ? stepOneWidgets : stepTwoWidgets),
                    ],
                  ),
                ),
              )
          ),
    );
  }
}
