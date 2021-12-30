import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'package:contacts_manager/app/service_locator.dart';
import 'package:contacts_manager/models/contacts/contact_data_model.dart';
import 'package:contacts_manager/presenter/providers/contacts/abstract/contacts_repository_abstr.dart';

typedef Json = Map<String, dynamic>;

class Contacts with ChangeNotifier {
  static const String mainTag = '## Contacts ';
  List<ContactDataModel> _items = [];
  final _contactsRepository = getIt.get<ContactsRepositoryAbstr>();
  final _errorHandlerSubject = BehaviorSubject<Object>();
  final _successHandlerSubject = BehaviorSubject<Object>();

  Stream<Object> get errorHandlerStream => _errorHandlerSubject.stream;
  Stream<Object> get successHandlerStream => _successHandlerSubject.stream;

  List<ContactDataModel> get items {
    return [..._items];
  }

  ContactDataModel getContactByUserId(String contactId) {
    final contact = items.firstWhere((contact) => contact.id == contactId);
    return contact;
  }

  Future<void> getContacts() async {
    log('$mainTag getContacts()');
    try {
      final loadedItems = await _contactsRepository.getContactsRepo();
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      _errorHandlerSubject.sink.add(error);
    }
  }

  Future<void> refreshContacts() async {
    try {
      final loadedItems = await _contactsRepository.refreshContactsRepo();
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      _errorHandlerSubject.sink.add(error);
    }
  }

  Future<void> removeContactById(String contactId) async {
    try {
      await _contactsRepository.removeContactByIdRepo(contactId);
    } catch (error) {
      _errorHandlerSubject.sink.add(error);
    }
    await getContacts();
    _successHandlerSubject.sink.add('Contact was successfully removed!');
    return;
  }

  Future<void> updateContactById(
      String contactId, ContactDataModel data) async {
    try {
      await _contactsRepository.updateContactByIdRepo(contactId, data);
    } catch (error) {
      _errorHandlerSubject.sink.add(error);
    }
    await getContacts();
    _successHandlerSubject.sink.add('Contact was successfully updated!');
    return;
  }

  @override
  void dispose() {
    super.dispose();
    _errorHandlerSubject.close();
    _successHandlerSubject.close();
  }
}
