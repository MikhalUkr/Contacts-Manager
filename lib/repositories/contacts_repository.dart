import 'dart:developer';

import 'package:contacts_manager/models/contacts/contact_data_model.dart';
import 'package:contacts_manager/presenter/providers/contacts/abstract/contacts_repository_abstr.dart';
import 'package:contacts_manager/repositories/abstr_sources/contacts_api_abstr.dart';
import 'package:contacts_manager/repositories/abstr_sources/share_pref_abstr.dart';
import 'package:contacts_manager/repositories/abstr_sources/sqlite_db_abstr.dart';
import 'package:contacts_manager/repositories/constants/api_constants.dart';
import 'package:contacts_manager/repositories/models/contact_data_model_repo.dart';

typedef ListContacts = List<ContactDataModelRepo>;
typedef Json = Map<String, dynamic>;

class ContactsRepository implements ContactsRepositoryAbstr {
  final ContactsApiServiceAbstr contactsApiService;
  final SharePreferencesServiceAbstr sharePrefService;
  final SqliteDbServiceAbstr sqliteDbService;

  ContactsRepository({
    required this.contactsApiService,
    required this.sharePrefService,
    required this.sqliteDbService,
  });

  static const String mainTag = '## ContactsRepository';
  final String _nameContactsDbTable = 'contacts';
  final _apiUrl = ApiConstants.loadContactsApi;

  /// Completely changes contacts (loads new contacts from the API)
  @override
  Future<ListContacts> refreshContactsRepo() async {
    log('$mainTag changeContactsRepo()');
    try {
      await removeAllContactsRepo();
      return await _loadContactsFromApiAndInsertIntoDb(_apiUrl);
    } catch (error) {
      rethrow;
    }
  }

  /// loads from the API or from the database
  @override
  Future<ListContacts> getContactsRepo() async {
    log('$mainTag getContactsRepo()');
    try {
      final willLoadFromAPI = await sharePrefService.isContactsLoadingInit();
      if (willLoadFromAPI) {
        return await _loadContactsFromApiAndInsertIntoDb(_apiUrl);
      }
      return await _loadContactsFromDb();
    } catch (error) {
      rethrow;
    }
  }

  Future<ListContacts> _loadContactsFromApiAndInsertIntoDb(
      String apiUrl) async {
    final ListContacts loadedContacts = [];
    log('$mainTag _loadContactsFromApiAndInsertIntoDb()');
    try {
      Uri? url = Uri.tryParse(apiUrl);
      if (url == null) {
        throw 'The [uri] string is not valid as a URI or URI reference!';
      }
      final extractedData = await contactsApiService.loadContactsData(url);
      // log('$mainTag _loadContactsFromApiAndInsertIntoDb() extractedData: $extractedData');
      final extractedListData = (extractedData['results']).toList();
      // final List<Map<String, dynamic>> extractedListData =
      //     (extractedData['results'] as List<Map<String, dynamic>>).toList();
      extractedListData.forEach((element) async {
        final contact = ContactDataModelRepo.fromJsonApi(element as Json);
        loadedContacts.add(contact);
        await _insertContactIntoDb(contact);
      });
      return loadedContacts;
    } catch (error) {
      // return Future.error('error occured when contacts loaded: $e ');
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
    } catch (error) {
      rethrow;
    }
    return;
  }

  Future<ListContacts> _loadContactsFromDb() async {
    final ListContacts loadedContacts = [];
    log('$mainTag _loadContactsFromDb()');
    try {
      final extractedListData =
          await sqliteDbService.getData(_nameContactsDbTable);
      extractedListData.forEach((element) {
        loadedContacts.add(ContactDataModelRepo.fromJsonDb(element));
      });
      return loadedContacts;
    } catch (error) {
      rethrow;
    }
  }

  @override
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
    } catch (error) {
      rethrow;
    }
    return;
  }

  @override
  Future<void> removeContactByIdRepo(String contactId) async {
    try {
      await sqliteDbService.delete(_nameContactsDbTable,
          where: "id = ?", whereArgs: [contactId]);
    } catch (error) {
      rethrow;
    }
    // where: "id = \"$contactId\"");
    return;
  }

  @override
  Future<void> removeAllContactsRepo() async {
    log('$mainTag removeAllContactsRepo()');
    try {
      await sqliteDbService.delete(_nameContactsDbTable);
    } catch (error) {
      rethrow;
    }
    return;
  }
}
