import 'dart:developer';

import 'package:contacts_manager/presenter/providers/contacts/contacts.dart';
import 'package:contacts_manager/presenter/ui/constants/color_constants.dart';
import 'package:contacts_manager/presenter/ui/widgets/contact_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ContactsScreen extends StatelessWidget {
  static const String routeName = '/contacts-screen';
  static const String mainTag = 'ContactsScreen';

  @override
  Widget build(BuildContext context) {
    _init(context);
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
          future: Provider.of<Contacts>(context, listen: false).getContacts(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : snapshot.hasError
                  ? Text(
                      'Something went wrong. The error occurred: ${snapshot.error}')
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

  void _init(BuildContext context) {
    log('$mainTag _init()');
    final errorHandleStream =
        Provider.of<Contacts>(context, listen: false).errorHandlerStream;
    final successHandleStream =
        Provider.of<Contacts>(context, listen: false).successHandlerStream;
    errorHandleStream.listen((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong. The error occurred: $error',
            textAlign: TextAlign.center,
          ),
          backgroundColor: ColorCotstants.errorColor,
        ),
      );
    });
    successHandleStream.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$message',
            textAlign: TextAlign.center,
          ),
          backgroundColor: ColorCotstants.successColor,
        ),
      );
    });
  }
}
