typedef Json = Map<String, dynamic>;

abstract class ContactsApiServiceAbstr {
  Future<Json> loadContactsData(Uri url);
}
