import 'dart:developer';

import 'package:contacts_manager/presenter/providers/contacts/contacts.dart';
import 'package:contacts_manager/presenter/ui/widgets/contact_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatelessWidget {
  static const String routeName = '/contacts-screen';
  static const String mainTag = 'ContactsScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contacts'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => Provider.of<Contacts>(context, listen: false)
                  .refreshContacts(),
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: FutureBuilder(
          future:
              Provider.of<Contacts>(context, listen: false).getContacts(),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CircularProgressIndicator())
                  : snapshot.hasError
                      ? _errorMessage(snapshot.error)
                      : Consumer<Contacts>(
                          child: const Center(
                            child: Text(
                                'Got no Contacts data yet, start adding some!'),
                          ),
                          builder: (context, userData, childAbove) =>
                              userData.items.isEmpty
                                  ? childAbove!
                                  : ListView.builder(
                                      itemCount: userData.items.length,
                                      itemBuilder: (context, index) {
                                        final users = userData.items;
                                        return users.isEmpty
                                            ? const Text('Empty List')
                                            : ContactItem(users[index]);
                                      },
                                    ),
                        ),
        ));
  }

  Widget _errorMessage(Object? error) {
    log('Something went wrong. The error occurred: $error');
    return Container();
  }
}
