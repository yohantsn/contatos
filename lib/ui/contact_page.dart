import 'package:contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact}); //Parametro entre {} significa que é opcional

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contact _editedContact;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.contact ==  null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact.name ?? "Novo Contato"),
       centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(
          Icons.save
      ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
