class Email {
  final String id;
  final String sender;
  final String subject;
  final String body;
  final bool read;
  final DateTime createdAt;
  final String attachment; // Nouvelle propriété ajoutée

  Email({
    required this.id,
    required this.sender,
    required this.subject,
    required this.body,
    required this.read,
    required this.createdAt,
    required this.attachment, // Ajout de la nouvelle propriété ici
  });

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      id: json['id'],
      sender: json['sender'],
      subject: json['subject'],
      body: json['body'],
      read: json['read'], // Assurez-vous que 'read' est un booléen dans votre JSON
      createdAt: DateTime.parse(json['createdAt']), // Parsez 'createdAt' en tant que DateTime
      attachment: json['attachment'], // Assurez-vous que la clé 'attachment' existe dans votre JSON
    );
  }
}
