
import 'package:contacts_manager/models/contacts/contact_data_model.dart';
import 'package:contacts_manager/services/sources/api/contacts_api.dart';
import 'package:contacts_manager/services/sources/local/share_pref.dart';
import 'package:contacts_manager/services/sources/local/sqliteDb.dart';

typedef ListContacts = List<ContactDataModel>;
typedef Json = Map<String, dynamic>;

class ContactsRepository {
  final ContactsApiService contactsApiService;
  final SharePreferencesService sharePrefService;
  final SqliteDbService sqliteDbService;

  ContactsRepository({
    required this.contactsApiService,
    required this.sharePrefService,
    required this.sqliteDbService,
  });

  static const String mainTag = '## ContactsRepository';
  final String _nameContactsDbTable = 'contacts';
    final _apiUrl =
        'https://randomuser.me/api/?results=2&inc=name,picture,email&noinfo';

  Future<List<ContactDataModel>> getContactsRepo() async {
    // either load from Api or from database
    try {
      final willLoadFromAPI = await sharePrefService.isContactsLoadingInit();
      if (willLoadFromAPI) {
        return await _loadContactsFromApiAndInsertIntoDb(_apiUrl);
      }
      return await _loadContactsFromDb();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ContactDataModel>> changeContactsRepo() async {
    // Completely change contacts
    try {
      await _removeAllContactsRepo();
      return await _loadContactsFromApiAndInsertIntoDb(_apiUrl);
    } catch (e) {
      rethrow;
    }
  }

  Future<ListContacts> _loadContactsFromApiAndInsertIntoDb(
      String apiUrl) async {
    final ListContacts loadedContacts = [];
    try {
      Uri? url = Uri.tryParse(apiUrl);
      if (url == null) {
        throw 'The [uri] string is not valid as a URI or URI reference!';
      }
      final extractedData = await contactsApiService.loadContactsData(url);
      final List extractedListData = extractedData['results'].toList();
      extractedListData.forEach((element) async{
        loadedContacts.add(ContactDataModel.fromJsonApi(element));
        await _insertContactIntoDb(ContactDataModel.fromJsonApi(element));
      });
      return loadedContacts;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _insertContactIntoDb(ContactDataModel contact) async {
    try {
      await sqliteDbService.insert(_nameContactsDbTable, {
        'id': contact.id,
        'name': contact.name,
        'surname': contact.surname,
        'email': contact.email,
        'image': contact.image
      });
    } catch (e) {
      rethrow;
    }
    return;
  }

  Future<ListContacts> _loadContactsFromDb() async {
    final ListContacts loadedContacts = [];
    try {
      final extractedListData =
          await sqliteDbService.getData(_nameContactsDbTable);
      extractedListData.forEach((element) {
        loadedContacts.add(ContactDataModel.fromJsonDb(element));
      });
      return loadedContacts;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateContactByIdRepo(
      String contactId, ContactDataModel contact) async {
    try {
      await sqliteDbService.update(
          _nameContactsDbTable,
          {
            'id': contact.id,
            'name': contact.name,
            'surname': contact.surname,
            'email': contact.email,
            'image': contact.image
          },
          where: "id = \"$contactId\"");
    } catch (e) {
      rethrow;
    }
    return;
  }

  Future<void> removeContactByIdRepo(String contactId) async {
    await sqliteDbService.delete(_nameContactsDbTable,
        where: "id = \"$contactId\"");
    return;
  }

  Future<void> _removeAllContactsRepo() async {
    await sqliteDbService.delete(_nameContactsDbTable);
    return;
  }
}
