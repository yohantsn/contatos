import 'dart:io';

import 'package:contatos/helpers/contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact}); //Parametro entre {} significa que é opcional

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _contactChanged = false;
  final _nomeControler = TextEditingController();
  final _emailControler = TextEditingController();
  final _foneControler = TextEditingController();
  final _focusNome = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nomeControler.text = _editedContact.name;
      _emailControler.text = _editedContact.email;
      _foneControler.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _exitActivty,

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_focusNome);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: 140.0,
                  width: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img))
                              : AssetImage("images/do-utilizador.png"))),
                ),
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 140, maxWidth: 140).then((file){
                    if(file == null)return;
                    setState(() {
                      _editedContact.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nomeControler,
                focusNode: _focusNome,
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
                onChanged: (text) {
                  _contactChanged = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _foneControler,
                decoration: InputDecoration(
                  labelText: "Telefone",
                ),
                onChanged: (text) {
                  _contactChanged = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
              ),
              TextField(
                controller: _emailControler,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                onChanged: (text) {
                  _contactChanged = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _exitActivty(){
    if(_contactChanged){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Descartar Alterações?"),
          content: Text("Se sair as alterações serão perdidas."),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Sim"),
            )
          ],
        );

      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }
}
