import 'dart:developer';

import 'package:contacts_manager/presenter/providers/contacts.dart';
import 'package:flutter/material.dart';

import 'package:contacts_manager/models/contacts/contact_data_model.dart';
import 'package:provider/provider.dart';

class DetailContactScreen extends StatelessWidget {
  static const String routeName = '/detail-contact-screen';
  static const String mainTag = '## DetailContactScreen';

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
                Provider.of<Contacts>(context, listen: false)
                    .removeContactById(contact.id);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
        body: Column(children: [
          Center(
            child: ClipOval(
              clipBehavior: Clip.hardEdge,
              child: Hero(
                tag: 'contact-${contact.id}',
                transitionOnUserGestures: true,
                child: contact.image.isNotEmpty
                    ? Image.network(
                        contact.image,
                        fit: BoxFit.cover,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          log('$mainTag.Image.network() frame: $frame; wasSynchronouslyLoaded: $wasSynchronouslyLoaded');
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            opacity: frame == null ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                            onEnd: () {},
                            child: child,
                          );
                        },
                        height: heightDevice / 6.0,
                        width: heightDevice / 6.0,
                      )
                    : const Icon(Icons.person_pin),
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
