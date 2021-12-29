typedef Json = Map<String, dynamic>;

abstract class ContactsApiService {
  Future<Json> loadContactsData(Uri url);
}
