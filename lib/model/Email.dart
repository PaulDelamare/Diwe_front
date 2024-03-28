class Email {
  final String id;
  final String sender;
  final String subject;
  final String body;
  final bool read;
  final DateTime createdAt;

  Email({
    required this.id,
    required this.sender,
    required this.subject,
    required this.body,
    required this.read,
    required this.createdAt,
  });

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      id: json['id'],
      sender: json['sender'],
      subject: json['subject'],
      body: json['body'],
      read: json['read'], // Assurez-vous que 'read' est un booléen dans votre JSON
      createdAt: DateTime.parse(json['createdAt']), // Parsez 'createdAt' en tant que DateTime
    );
  }
}
