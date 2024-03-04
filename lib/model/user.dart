class User {
  final String? email;
  final String? password;
  final String? firstname;
  final String? lastname;
  final String? role;
  final DateTime? birthday;
  final int? secretPin;
  final String? phone;

  User({
    this.email,
    this.password,
    this.firstname,
    this.lastname,
    this.role,
    this.birthday,
    this.secretPin,
    this.phone,
  });

  // Pour récupérer les données
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      role: json['role'],
      birthday: DateTime.parse(json['birthday']),
      secretPin: json['secretPin'],
      phone: json['phone'],
    );
  }

  // Pour envoyer les données
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'firstname': firstname,
    'lastname': lastname,
    'role': role,
    'birthday': birthday?.toIso8601String(),
    'secretPin': secretPin,
    'phone': phone,
  };
}
