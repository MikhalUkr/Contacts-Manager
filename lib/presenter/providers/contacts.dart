import 'dart:developer';

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

  ContactDataModel getContactByUserId(String contactId) {
    try {
      final contact = items.firstWhere((contact) => contact.id == contactId);
      return contact;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getContacts() async {
    try {
      final loadedItems = await _contactsRepository.getContactsRepo();
      _items = loadedItems;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeContacts() async {
    try {
      final loadedItems = await _contactsRepository.changeContactsRepo();
      _items = loadedItems;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeContactById(String contactId) async {
    log('$mainTag.removeContactById() contactId: $contactId');
    await _contactsRepository.removeContactByIdRepo(contactId);
    await getContacts();
    return;
  }

  Future<void> updateContactById(
      String contactId, ContactDataModel data) async {
    await _contactsRepository.updateContactByIdRepo(contactId, data);
    await getContacts();
    return;
  }
}
