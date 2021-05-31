import 'package:contacts_manager/presenter/ui/screens/contacts_screen.dart';
import 'package:contacts_manager/presenter/ui/screens/detail_contact_screen.dart';
import 'package:contacts_manager/presenter/ui/screens/edit_contact_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:contacts_manager/app/service_locator.dart';
import 'package:contacts_manager/presenter/providers/contacts.dart';


void main() {
  setUp();
  runApp(MyApp());}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Contacts>(create: (_) => Contacts()),

        ],
        child: MaterialApp(
          // supportedLocales: const <Locale>[
          //   Locale('en', 'US'),
          //   Locale('uk', 'UA'),
          // ],
          title: 'Contacts Manager',
          theme: ThemeData(
            primaryColor: Colors.purple,
            backgroundColor: Colors.pink,
            accentColor: Colors.deepPurple,
            accentColorBrightness: Brightness.dark,
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            textTheme: const TextTheme(),
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => ContactsScreen(),
            DetailContactScreen.routeName: (ctx) => DetailContactScreen(),
            EditContactScreen.routeName: (ctx) => EditContactScreen(),
          },
        ));
  }
}
