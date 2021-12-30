import 'package:contacts_manager/models/contacts/contact_data_model.dart';
import 'package:contacts_manager/repositories/models/contact_data_model_repo.dart';

typedef ListContacts = List<ContactDataModelRepo>;

abstract class ContactsRepositoryAbstr {

  /// Completely changes contacts (loads new contacts from the API)
  Future<ListContacts> refreshContactsRepo();

  /// loads from the API or from the database
  Future<ListContacts> getContactsRepo();

  Future<void> updateContactByIdRepo(
      String contactId, ContactDataModel contact);

  Future<void> removeContactByIdRepo(String contactId);

  Future<void> removeAllContactsRepo();
}
