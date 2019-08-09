import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:desafio/paginas/bem_vindo.dart';

class TelaLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final FirebaseAuth _autenticador = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState> ();
  String emailLog, senhaLog;

  @override
  void initState(){
    super.initState();
  }

  Future<void> autenticarLogin() async {
    final FormState formulario1 = _formKey.currentState;
    if(formulario1.validate()){
      formulario1.save();
      try{
        FirebaseUser user = await _autenticador.signInWithEmailAndPassword(email: emailLog, password: senhaLog);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Bemvindo(user:user)));
        formulario1.reset();
      }catch(error){  
            AlertDialog dialogo = AlertDialog(
              backgroundColor: Colors.amber[50],
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget> [
                    Text("Email ou senha incorretos!", style: TextStyle(fontSize:30)),
                    SizedBox(height: 10),
                    Icon(Icons.error_outline, size:60, color:Colors.red[900]),
                  ],
                ),
              ),
            );  
            showDialog(
              context: context, 
              builder: (BuildContext context) {return dialogo;}
            );
            formulario1.reset();
      }
    }
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              title: Text('Login', style: TextStyle(fontSize:30)),
              titleSpacing: 22,
            ),
          body: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top:10.0, left:50.0, right:50.0),
            child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                  Hero(
                  tag:'logo',
                  child: CircleAvatar(
                    radius: 80.0,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/imagens/samurai.png'),              
                  ),               
                ),           
                SizedBox(height:10.0),
                TextFormField(
                  style: TextStyle(fontSize: 10, fontFamily: 'Korean 0.3'),
                  decoration: InputDecoration(
                    labelText: 'Digite seu email',
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
                    else if (value.isEmpty){
                      return 'Por favor digite seu email';
                    } 
                    return null;
                  },
                  onSaved: (val) => emailLog = val,
                ),
                SizedBox(height:10),
                TextFormField(
                  style: TextStyle(fontSize: 10, fontFamily: 'Korean 0.3'),
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: 'Digite sua senha',
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                  ),
                  maxLength: 20,
                  validator: (value) {
                    if (value.isEmpty){
                      return 'Por favor digite sua senha';
                    } 
                    else if (value.length < 6) {
                      return 'Senha com menos de 6 caracteres';
                    } 
                    return null;
                  },
                  onSaved: (val) => senhaLog = val,
                ),
                RaisedButton(
                  padding: EdgeInsets.all(10),
                  elevation:8.0,
                  onPressed:() async {await autenticarLogin();},
                  child: Text(
                      'Entrar',
                      style: TextStyle(fontSize: 22),
                  ),
                ), 
                SizedBox(height: 10.0),
                Text(
                  'Ainda não possui conta?', 
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Korean 0.2',
                  ),   
                ),
                SizedBox(height: 10.0),
                RaisedButton(
                  padding: EdgeInsets.all(10),
                  elevation:8.0,
                  onPressed:() {Navigator.pushNamed(context, '/cadastro'); _formKey.currentState.reset(); }, 
                  child: Text(
                      'Cadastrar',
                      style: TextStyle(fontSize: 22),
                  ),
                ),  
              ],
            ),      
          ),   
        )
      ),
     ),
    ],
   );
  }
}
