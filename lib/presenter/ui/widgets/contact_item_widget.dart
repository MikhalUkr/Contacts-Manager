import 'dart:developer';

import 'package:contacts_manager/presenter/ui/screens/detail_contact_screen.dart';
import 'package:contacts_manager/presenter/ui/screens/edit_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:contacts_manager/presenter/providers/contacts.dart';
import 'package:contacts_manager/models/contacts/contact_data_model.dart';

class ContactItem extends StatefulWidget {
  final ContactDataModel contact;

  ContactItem(this.contact);

  @override
  _ContactItemState createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  static const String mainTag = '## ContactItem ';
  @override
  Widget build(BuildContext context) {
    final heightDevice = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        _showDetailContact(widget.contact);
      },
      onLongPress: () {
        _showEditContact(widget.contact.id, widget.contact);
      },
      child: Dismissible(
        key: ValueKey(widget.contact.id),
        direction: DismissDirection.endToStart,
        onDismissed: (dismissdirection) {
          _removeContact(widget.contact.id);
        },
        confirmDismiss: (direction) {
          return _showAlertDialog(context);
        },
        background: Container(
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
        ),
        child: ListTile(
          leading: ClipOval(
            child: SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? heightDevice / 12.0
                        : heightDevice / 8.0,
                width:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? heightDevice / 12.0 * 0.8
                        : heightDevice / 8.0 * 0.8,
                child: Hero(
                    tag: 'contact-${widget.contact.id}',
                    transitionOnUserGestures: true,
                    child:
                        Image.network(widget.contact.image, fit: BoxFit.fill))),
          ),
          title: Text(
            '${widget.contact.name}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${widget.contact.surname}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Are you sure?',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).errorColor),
        ),
        content: Text(
          'Do you want to remove this item from the cart?',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  Future<void> _removeContact(
    String contactId,
  ) async {
    await context.read<Contacts>().removeContactById(contactId);
    return Future(() => {});
  }

  void _showDetailContact(
    ContactDataModel contact,
  ) {
    Navigator.of(context)
        .pushNamed(DetailContactScreen.routeName, arguments: contact);
    return;
  }

  void _showEditContact(
    String contactId,
    ContactDataModel contact,
  ) {
    Navigator.of(context).pushNamed(EditContactScreen.routeName,
        arguments: {'contact': contact, 'callback': _editContactCallback});
    return;
  }

  void _editContactCallback(ContactDataModel editedContact) {
    Provider.of<Contacts>(context, listen: false).updateContactById(
      editedContact.id,
      editedContact,
    );
  }
}
