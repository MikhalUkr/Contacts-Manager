import 'dart:developer';

import 'package:contacts_manager/models/contacts/contact_data_model.dart';
import 'package:contacts_manager/repositories/abstr_sources/contacts_api_abstr.dart';
import 'package:contacts_manager/repositories/abstr_sources/share_pref_abstr.dart';
import 'package:contacts_manager/repositories/abstr_sources/sqlite_db_abstr.dart';
import 'package:contacts_manager/repositories/models/contact_data_model_repo.dart';

typedef ListContacts = List<ContactDataModelRepo>;
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
      'https://randomuser.me/api/?results=20&inc=name,picture,email&noinfo';

  /// Completely changes contacts (loads new contacts from the API)
  Future<ListContacts> changeContactsRepo() async {
    try {
      await removeAllContactsRepo();
      return await _loadContactsFromApiAndInsertIntoDb(_apiUrl);
    } catch (e) {
      rethrow;
    }
  }

  /// loads from the API or from the database
  Future<ListContacts> getContactsRepo() async {
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

  Future<ListContacts> _loadContactsFromApiAndInsertIntoDb(
      String apiUrl) async {
    final ListContacts loadedContacts = [];
    try {
      Uri? url = Uri.tryParse(apiUrl);
      if (url == null) {
        throw 'The [uri] string is not valid as a URI or URI reference!';
      }
      final extractedData = await contactsApiService.loadContactsData(url);
      final List<Map<String, dynamic>> extractedListData = (extractedData['results'] as List<Map<String, dynamic>>).toList();
      extractedListData.forEach((element) async {
        final contact = ContactDataModelRepo.fromJsonApi(element);
        loadedContacts.add(contact);
        await _insertContactIntoDb(contact);
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
        loadedContacts.add(ContactDataModelRepo.fromJsonDb(element));
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
    await sqliteDbService
        .delete(_nameContactsDbTable, where: "id = ?", whereArgs: [contactId]);
    // where: "id = \"$contactId\"");
    return;
  }

  Future<void> removeAllContactsRepo() async {
    await sqliteDbService.delete(_nameContactsDbTable);
    return;
  }
}
