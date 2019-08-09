import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';


class Cadastro extends StatefulWidget {

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final FirebaseAuth _autenticador = FirebaseAuth.instance;
  DocumentReference _formularioRef;
 
  final _formKey = GlobalKey<FormState> ();
  final _snackBar1 = GlobalKey<ScaffoldState>();
  String nomeCad, emailCad, senhaCad;
  var senhaCripto, bytes;
  

  @override
  void initState(){
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
           image: DecorationImage(image:AssetImage('assets/imagens/oriental2.jpg'), fit:BoxFit.cover),
         ),
        ), 
      Scaffold(
      backgroundColor:Colors.transparent,
      key: _snackBar1,
      appBar: AppBar(
        title: Text('Cadastro', style:TextStyle(fontSize:30)),
        titleSpacing: -10,
      ),
      body: Container( 
       child: SingleChildScrollView(
        padding: EdgeInsets.only(top:15.0, left:50.0, right:50.0),
        child: Form(
         key: _formKey,
         child: Column(
          children: <Widget>[
            Icon(Icons.keyboard_arrow_down, size:40.0), 
            TextFormField(
              style: TextStyle(fontSize: 10, fontFamily: 'Korean 0.3'),
              decoration: InputDecoration(
                labelText: 'Nome:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              maxLength: 20,
              validator: (value) {
                if (value.isEmpty){
                  return 'Por favor digite seu nome';
                } return null;
              },
              onSaved: (val) => nomeCad = val,
              
            ),
            SizedBox(height: 20),
            TextFormField(
              style: TextStyle( fontSize: 10, fontFamily: 'Korean 0.3'),
              decoration: InputDecoration(
                labelText: 'Email:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              maxLength: 32,
              validator: (value) {
                Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = RegExp (pattern);
                if (!regex.hasMatch(value)) {
                  return 'Por favor insira um email válido';  
                }
                if (value.isEmpty){
                  return 'Por favor digite seu email';
                } 
                return null;
              },
              onSaved: (val) => emailCad = val,          
            ),
            SizedBox(height: 20),
            TextFormField(
              style: TextStyle(fontSize: 10, fontFamily: 'Korean 0.3'),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
              maxLength: 20,
              validator: (value) {
                if (value.isEmpty){
                  return 'Por favor digite sua senha';
                } else if (value.length < 6) {
                  return 'A senha não pode conter menos de 6 caracteres';
                } return null;
              },
              onSaved: (val) => senhaCad = val,
            ),
            SizedBox(height: 30),
            RaisedButton(
              padding: EdgeInsets.only(top:10,left:10, right:10,  bottom:10 ),
              elevation:8.0,
              onPressed:() async { await registrarUsuario();},
              child: Text(
                'Finalizar Cadastro',
                style: TextStyle(fontSize:22),
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              padding: EdgeInsets.all(10),
              elevation:8.0,
              onPressed: () {Navigator.pop(context); _formKey.currentState.reset();},
              child: Text(
                'Voltar',
                style: TextStyle(fontSize: 22),
              ),
            ),
           ],
          ),
         ),
        ),
       ),
      ),
     ],
    );
  }
    Future<void> registrarUsuario() async {
    final FormState formulario2= _formKey.currentState;
    if(formulario2.validate()) {
      formulario2.save();
      try{
        FirebaseUser user = await _autenticador.createUserWithEmailAndPassword(email: emailCad, password: senhaCad);
        UserUpdateInfo atualizaUsuario = UserUpdateInfo();
        atualizaUsuario.displayName = nomeCad;
        user.updateProfile(atualizaUsuario).then((onValue) async {            
            bytes = utf8.encode(senhaCad);
            senhaCripto = sha1.convert(bytes).toString();
            _formularioRef = Firestore.instance.collection("Alunos").document(user.uid);  
            Map<String, String> dados =<String, String>{ 
              "(a) Nome": nomeCad, "(b) Email": emailCad, "(c) Senha ": senhaCripto
            };
            _formularioRef.setData(dados);

          formulario2.reset();
          final mostradorSnackBar =  SnackBar(
            content: Text('Cadastro realizado com sucesso!', style: TextStyle(fontSize: 22, fontFamily: 'Korean 0.2', color:Colors.black)),
            backgroundColor: Colors.amber[50],       
            duration: Duration (minutes: 2),
            action: SnackBarAction(label: ">>", textColor: Colors.black, onPressed:() {
              Navigator.of(context).pop();
           }),
          );
          //Como mostrar a snackbar?
          _snackBar1.currentState.showSnackBar(mostradorSnackBar);
        }); 
      }catch(error){
           AlertDialog dialogo = AlertDialog(
              backgroundColor: Colors.amber[50],
              content: SingleChildScrollView(
                child: ListBody( 
                  children: <Widget>[
                  Text("Uma conta com essas credenciais já existe! Tente de novo.", style: TextStyle(fontSize:30)),
                  SizedBox(height:10),
                  Icon(Icons.error_outline, size:60, color: Colors.red[900],)
                  ],
                ),
              ),
            );  
            showDialog(
              context: context, 
              builder: (BuildContext context) {return dialogo;}
            );
        formulario2.reset();
      }
    } 
  }
}

