
import 'dart:developer';

import 'package:contacts_manager/presenter/providers/contacts.dart';
import 'package:flutter/material.dart';

import 'package:contacts_manager/models/contacts/contact_data_model.dart';
import 'package:provider/provider.dart';

class DetailContactScreen extends StatelessWidget {
  static const String routeName = '/detail-contact-screen';
  static const String mainTag = 'DetailContactScreen';

  @override
  Widget build(BuildContext context) {
    final heightDevice = MediaQuery.of(context).size.height;
    final ContactDataModel contact =
        ModalRoute.of(context)?.settings.arguments as ContactDataModel;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Contact'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                log('$mainTag.onPressed: name: ${contact.name} id: ${contact.id}');
                Provider.of<Contacts>(context, listen: false)
                    .removeContactById(contact.id);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
        body: Column(children: [
          Center(
            child: ClipOval(
              // ignore: sized_box_for_whitespace
              child: Container(
                // If we want obtain the Circle shape, we are using height == width
                height: heightDevice / 7.0,
                width: heightDevice / 7.0,
                child: Hero(
                  tag: 'contact-${contact.id}',
                  transitionOnUserGestures: true,
                  child: contact.image.isNotEmpty
                      ? Image.network(contact.image, fit: BoxFit.cover)
                      : const Icon(Icons.person_pin),
                ),
              ),
            ),
          ),
          SizedBox(
            height: heightDevice / 15,
          ),
          Text(
            '${contact.name} ${contact.surname}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '${contact.email}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ]));
  }
}
