import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencesService {
  /// if returns [true] - then make loading from an [API]
  /// if [false] - from a [database]
  Future<bool> isContactsLoadingInit() async {
    final String initKey = 'isContactsLoadingInit';
    final instance = await SharedPreferences.getInstance();
    if (instance.containsKey(initKey)) {
      return false;
      // return true; // for tests
    }
    // set initKey for future loading from a database
    instance.setInt(initKey, 1);
    return true;
  }
}
