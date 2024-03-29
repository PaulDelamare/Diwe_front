import 'package:diwe_front/home/Profile.dart';
import 'package:flutter/material.dart';
import 'package:diwe_front/service/DoctorService.dart';

class DoctorFormWidget extends StatefulWidget {
  @override
  _DoctorFormWidgetState createState() => _DoctorFormWidgetState();
}

class _DoctorFormWidgetState extends State<DoctorFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _firstname = '';
  String? _lastname;
  String? _phone;
  String? _apiError; // Variable pour stocker les erreurs de l'API

  final DoctorService _doctorService = DoctorService();

  void _submitForm() async {
    setState(() {
      _apiError = null; // Réinitialiser les erreurs de l'API avant de soumettre
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Utilisation du DoctorService pour envoyer les données
        await _doctorService.createDoctor(_email, _firstname, lastname: _lastname, phone: _phone);

        // Affiche une Snackbar ou une autre indication que le docteur a été ajouté
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Doctor added successfully')),
        );
      } catch (e) {
        // Si l'API renvoie une erreur, la stocker dans _apiError pour l'afficher
        setState(() {
          _apiError = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom // Ajoute du padding en bas pour le clavier
      ),
      child: SingleChildScrollView( // Permet de défiler si le contenu est plus grand que l'espace disponible
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (_apiError != null) ...[
                Text(
                  _apiError!,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
              ],
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) {
                  _email = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (value) {
                  _firstname = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (value) {
                  _lastname = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                onSaved: (value) {
                  _phone = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorSearchFormWidget extends StatefulWidget {
  @override
  _DoctorSearchFormWidgetState createState() => _DoctorSearchFormWidgetState();
}

class _DoctorSearchFormWidgetState extends State<DoctorSearchFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  Map<String, dynamic>? _doctorData;
  String? _apiError; // Variable pour stocker les erreurs de l'API

  final DoctorService _findDoctorService = DoctorService();

  void _submitForm() async {
    setState(() {
      _apiError = null; // Réinitialiser les erreurs de l'API avant de soumettre
      _doctorData = null; // Réinitialiser les données du médecin avant de soumettre
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Utilisation du DoctorService pour rechercher le médecin
        Map<String, dynamic> doctorData = await _findDoctorService.findDoctor(_email);
        setState(() {
          _doctorData = doctorData;
        });
        print(_doctorData);
        
      } catch (e) {
        // Si l'API renvoie une erreur, la stocker dans _apiError pour l'afficher
        setState(() {
          _apiError = e.toString();
        });
      }
    }
  }

  // Ajoutez cette méthode pour envoyer une demande de lien vers le médecin
  void _requestLinkToDoctor(String doctorId) async {
    try {
      await _findDoctorService.requestLinkToDoctor(doctorId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link request sent successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send link request: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Ajoute du padding en bas pour le clavier
      ),
      child: SingleChildScrollView(
        // Permet de défiler si le contenu est plus grand que l'espace disponible
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (_apiError != null) ...[
                Text(
                  _apiError!,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
              ],
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) {
                  _email = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Recherchez un docteur'),
                ),
              ),
              if (_doctorData != null && _doctorData?['doctor'] != null) ...[
                // Afficher les données du médecin si elles sont disponibles
                SizedBox(height: 20),
                Text(
                  'Doctor Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('First Name: ${_doctorData!['doctor']['firstname']}'),
                Text('Last Name: ${_doctorData!['doctor']['lastname']}'),
                Text('Email: ${_doctorData!['doctor']['email']}'),
                Text('Phone: ${_doctorData!['doctor']['phone']}'),
                ElevatedButton(
                  onPressed: () {
                    final String doctorId = _doctorData!['doctor']['_id'];
                    _requestLinkToDoctor(doctorId);
                  },
                  child: Text('Liée ce médecin à mon compte'),
                ),

              ] else ...[
                Center(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Ajouter un docteur"),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  DoctorFormWidget(),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Annuler'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    
                    child: Text(
                      "Ajouter un docteur fictif",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class ListDoctorWidget extends StatelessWidget {
  final DoctorService doctorService;
  

  const ListDoctorWidget({
    Key? key,
    required this.doctorService,
  }) : super(key: key);


    void _deleteLink(String doctorId) async {

    try {
      // Delete link route
      await doctorService.deleteLink(doctorId);  

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: doctorService.getLinkedDoctors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          final List<Map<String, dynamic>> doctorData = snapshot.data!;
          return ListView.separated(
  itemCount: doctorData.length,
  separatorBuilder: (context, index) => SizedBox(height: 10), // Espacement entre les éléments
  itemBuilder: (context, index) {
    final doctor = doctorData[index];
    return Row(
      children: [
        Expanded(
          child: ProfileWidget(
            nom: doctor['lastname'],
            prenom: doctor['firstname'],
            email: doctor['email'],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _deleteLink(doctor['_id']);
          },
          child: Text('Delete Link'),
        ),
      ],
    );
  },
);

        } else {
          return Text('No data available');
        }
      },
    );
  }
}

