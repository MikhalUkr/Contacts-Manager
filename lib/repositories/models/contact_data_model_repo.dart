import 'package:contacts_manager/models/contacts/contact_data_model.dart';

class ContactDataModelRepo extends ContactDataModel {
  ContactDataModelRepo({
    required String id,
    required String name,
    required String surname,
    required String email,
    String image = '',
  }) : super(id: id, name: name, surname: surname, email: email, image: image);

  @override
  factory ContactDataModelRepo.fromJson(Json json) {
    return ContactDataModelRepo(
        id: json['id'] as String,
        name: json['name'] as String,
        surname: json['surname'] as String,
        email: json['email'] as String,
        image: json['image'] as String);
  }
  @override
  Json toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'image': image
    };
  }

  factory ContactDataModelRepo.fromJsonApi(Json json) {
    return ContactDataModelRepo(
        id: DateTime.now().toIso8601String(),
        name: json['name']['first'] as String,
        surname: json['name']['last'] as String,
        email: json['email'] as String,
        image: json['picture']['large'] as String);
  }

  factory ContactDataModelRepo.fromJsonDb(Json json) {
    return ContactDataModelRepo(
        id: json['id'] as String,
        name: json['name'] as String,
        surname: json['surname'] as String,
        email: json['email'] as String,
        image: json['image'] as String);
  }

  @override
  String toString() {
    return 'UserDataModel: id: $id; name: $name; surname: $surname; email: $email; image: $image;\n';
  }
}
