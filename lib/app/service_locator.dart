import 'package:contacts_manager/repositories/contacts_repository.dart';
import 'package:contacts_manager/services/sources/api/contacts_api.dart';
import 'package:contacts_manager/services/sources/local/share_pref.dart';
import 'package:contacts_manager/services/sources/local/sqliteDb.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUp() {
  // started register block for Contacts
  getIt.registerSingleton<ContactsApiService>(ContactsApiService());

  getIt.registerSingleton<SharePreferencesService>(SharePreferencesService());

  getIt.registerSingleton<SqliteDbService>(SqliteDbService());

  getIt.registerLazySingleton<ContactsRepository>(() {
    return ContactsRepository(
        contactsApiService: GetIt.I.get<ContactsApiService>(),
        sharePrefService: GetIt.I.get<SharePreferencesService>(),
        sqliteDbService: GetIt.I.get<SqliteDbService>());
  });
  // finished register block for Contacts
}
