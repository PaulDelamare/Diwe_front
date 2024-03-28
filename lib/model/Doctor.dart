class Doctor {
  final String email;
  final String firstname;
  final String? lastname;
  final String? phone;

  Doctor({
    required this.email,
    required this.firstname,
    this.lastname,
    this.phone,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
    };
  }
}
