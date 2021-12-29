import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:contacts_manager/models/contacts/contact_data_model.dart';

class EditContactScreen extends StatefulWidget {
  static const String routeName = '/edit-contact-screen';
  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  static const String mainTag = '## EditContactScreen';
  final _formKey = GlobalKey<FormState>();
  final _contactNameLengthRestriction = 70;
  // it will be setting in true when was any [Form] in [AuthForm]changed property
  var _isChanged = false;
  // fields for filling contact's screen content
  var _contactId = '';
  var _contactName = '';
  var _contactSurname = '';
  var _contactEmail = '';
  var _contactImageUrl = '';

  var _editedContactName = '';
  var _editedContactSurname = '';
  var _editedContactEmail = '';

  @override
  Widget build(BuildContext context) {
    final heightDevice = MediaQuery.of(context).size.height;
    ContactDataModel? contact;
    Function? callback;
    final Map<String, Object>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, Object>?;
    if (arguments != null) {
      contact = arguments['contact']! as ContactDataModel;
      callback = arguments['callback']! as Function;
      // filling a conact content for the next view and probably editing
      _contactId = contact.id;
      _contactName = contact.name;
      _contactSurname = contact.surname;
      _contactEmail = contact.email;
      _contactImageUrl = contact.image;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isChanged
                ? () {
                    if (callback != null) {
                      _saveContactAndExit(callback);
                    }
                    // Navigator.of(context).pop();
                  }
                : null,
          )
        ],
      ),
      body: Column(
        children: [
          Center(
            child: ClipOval(
              child: FittedBox(
                // If we want obtain the Circle shape, we are using height == width
                child: Hero(
                  tag: 'contact-${contact?.id}',
                  transitionOnUserGestures: true,
                  child: contact != null
                      ? Image.network(
                          contact.image,
                          fit: BoxFit.cover,
                          height: heightDevice / 6.0,
                          width: heightDevice / 6.0,
                        )
                      : const Icon(Icons.person_pin),
                ),
              ),
            ),
          ),
          SizedBox(
            height: heightDevice / 15,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    onChanged: () {
                      _isChanged = true;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            key: const ValueKey('name'),
                            initialValue: _contactName,
                            onChanged: (value) => setState(() {
                              _isChanged = true;
                            }),
                            validator: (value) =>
                                _validateContactName(value!.trim()),
                            keyboardAppearance: Brightness.dark,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Name*',
                              hintText: 'firstName',
                            ),
                            onSaved: (value) =>
                                _editedContactName = value!.trim(),
                          ),
                          TextFormField(
                            key: const ValueKey('Surname'),
                            initialValue: _contactSurname,
                            onChanged: (value) => setState(() {
                              _isChanged = true;
                            }),
                            validator: (value) =>
                                _validateContactName(value!.trim()),
                            keyboardAppearance: Brightness.dark,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: 'Surname*',
                              hintText: 'secondName',
                            ),
                            onSaved: (value) =>
                                _editedContactSurname = value!.trim(),
                          ),
                          TextFormField(
                            key: const ValueKey('email'),
                            initialValue: _contactEmail,
                            onChanged: (value) => setState(() {
                              _isChanged = true;
                            }),
                            validator: (value) => _validateEmail(
                                value!.trim().replaceAll(' ', '')),
                            keyboardAppearance: Brightness.dark,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: 'Email*', hintText: 'email'),
                            onSaved: (value) =>
                                _editedContactEmail = value!.trim(),
                          ),
                          const SizedBox(height: 15.0),
                          Text(
                              '* if a field is marked (*), this field is obligate for filling',
                              style: TextStyle(
                                  color: Theme.of(context).errorColor)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _saveContactAndExit(Function callback) {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      final editedContact = ContactDataModel(
        id: _contactId,
        name: _editedContactName,
        surname: _editedContactSurname,
        email: _editedContactEmail,
        image: _contactImageUrl,
      );
      callback(editedContact);
      Navigator.of(context).pop();
    }
  }

  String? _validateContactName(String name) {
    if (name.isEmpty) {
      return 'Please enter a name';
    }
    if (name.length > _contactNameLengthRestriction) {
      return 'The length of the name must be maxed $_contactNameLengthRestriction symbols';
    }
    return null;
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter an email';
    }

    if (!email.contains('@') || !email.contains('.')) {
      return 'The email must contain @ symbol and "." symbol';
    }
    return null;
  }
}
