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

  factory ContactDataModel.fromJson(Json json) {
    return ContactDataModel(
        id: json['id'] as String,
        name: json['name'] as String,
        surname: json['surname'] as String,
        email: json['email'] as String,
        image: json['image'] as String);
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
