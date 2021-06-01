typedef Json = Map<String, dynamic>;

class ContactDataModel {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String image;

  ContactDataModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.image = '',
  });

  factory ContactDataModel.fromJsonApi(Json json) {
    // List<Map<String, dynamic>> results = json['results'];
    return ContactDataModel(
        id: DateTime.now().toIso8601String(),
        name: json['name']['first'],
        surname: json['name']['last'],
        email: json['email'],
        image: json['picture']['large']);
  }

  factory ContactDataModel.fromJsonDb(Json json) {
    return ContactDataModel(
        id: json['id'],
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        image: json['image']);
  }

  Json toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'image': image
    };
  }

  @override
  String toString() {
    return 'UserDataModel: id: $id; name: $name; surname: $surname; email: $email; image: $image;\n';
  }
}
