
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:contacts_manager/models/contacts/contact_data_model.dart';
import 'package:contacts_manager/presenter/providers/contacts/contacts.dart';
import 'package:contacts_manager/presenter/ui/screens/detail_contact_screen.dart';
import 'package:contacts_manager/presenter/ui/screens/edit_contact_screen.dart';

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
    final portraiteImageHeight = heightDevice / 12.0;
    final portraiteImageWidth = heightDevice / 12.0;
    final landscapeImageHeight = heightDevice / 8.0;
    final landscapeImageWidth = heightDevice / 8.0;

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
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        child: ListTile(
          leading: ClipOval(
            child: Hero(
              tag: 'contact-${widget.contact.id}',
              transitionOnUserGestures: true,
              child: FittedBox(
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.fill,
                child: Image.network(
                  widget.contact.image,
                  fit: BoxFit.cover,
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? portraiteImageHeight
                          : landscapeImageHeight,
                  width:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? portraiteImageWidth
                          : landscapeImageWidth,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOut,
                      child: child,
                    );
                  },
                ),
              ),
            ),
          ),
          title: Text(
            widget.contact.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.contact.surname,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        content: const Text(
          'Do you want to remove this contact from the contacts?',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
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

  Future<void> _editContactCallback(ContactDataModel editedContact) async {
    await Provider.of<Contacts>(context, listen: false).updateContactById(
      editedContact.id,
      editedContact,
    );
  }
}
