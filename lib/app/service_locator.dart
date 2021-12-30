import 'package:contacts_manager/presenter/providers/contacts/abstract/contacts_repository_abstr.dart';
import 'package:get_it/get_it.dart';

import 'package:contacts_manager/repositories/abstr_sources/contacts_api_abstr.dart';
import 'package:contacts_manager/repositories/abstr_sources/share_pref_abstr.dart';
import 'package:contacts_manager/repositories/abstr_sources/sqlite_db_abstr.dart';
import 'package:contacts_manager/repositories/contacts_repository.dart';
import 'package:contacts_manager/services/sources/api/contacts_api.dart';
import 'package:contacts_manager/services/sources/local/share_pref.dart';
import 'package:contacts_manager/services/sources/local/sqlite_db.dart';

final getIt = GetIt.instance;

void setUp() {
  // started register block for Contacts
  getIt.registerSingleton<ContactsApiServiceAbstr>(ContactsApiService());

  getIt.registerSingleton<SharePreferencesServiceAbstr>(
      SharePreferencesService());

  getIt.registerSingleton<SqliteDbServiceAbstr>(SqliteDbService());

  getIt.registerLazySingleton<ContactsRepositoryAbstr>(() {
    return ContactsRepository(
        contactsApiService: GetIt.I.get<ContactsApiServiceAbstr>(),
        sharePrefService: GetIt.I.get<SharePreferencesServiceAbstr>(),
        sqliteDbService: GetIt.I.get<SqliteDbServiceAbstr>());
  });
  // finished register block for Contacts
}
