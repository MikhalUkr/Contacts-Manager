
import 'package:contacts_manager/app/service_locator.dart';
import 'package:contacts_manager/repositories/contacts_repository.dart';
import 'package:flutter/cupertino.dart';

import 'package:contacts_manager/models/contacts/contact_data_model.dart';

typedef Json = Map<String, dynamic>;

class Contacts with ChangeNotifier {
  static const String mainTag = '## Contacts ';
  List<ContactDataModel> _items = [];
  ContactsRepository _contactsRepository = getIt.get<ContactsRepository>();

  List<ContactDataModel> get items {
    return [..._items];
  }

  ContactDataModel getContactByUserId(String contactId){
    try {
      final contact = items.firstWhere((contact) => contact.id == contactId);
      return contact;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getContactData() async {
    try {
      final loadedItems = await _contactsRepository.getContactsRepo();
      _items = loadedItems;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

    Future<void> changeContactData() async {
    try {
      final loadedItems = await _contactsRepository.changeContactsRepo();
      _items = loadedItems;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeContactById(String contactId) async {
    await _contactsRepository.removeContactRepo(contactId);
    getContactData();
    return;
  }

  Future<void> updateContactById(String contactId, ContactDataModel data) async {
    await _contactsRepository.updateContactRepo(contactId, data);
    getContactData();
    return;
  }


}
