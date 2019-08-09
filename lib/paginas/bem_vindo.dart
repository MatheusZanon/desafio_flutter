import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bemvindo extends StatefulWidget {
  final FirebaseUser user;
  Bemvindo ({Key key, this.user}): super(key:key);
  
  @override
  State<StatefulWidget> createState() => _BemvindoState();
}

class _BemvindoState extends State<Bemvindo> {
  final FirebaseAuth _autenticador = FirebaseAuth.instance;

  @override
  void initState() {
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Hōmupēji', style: TextStyle(fontSize:30)),
          titleSpacing: -35,
          actions: <Widget> [
            IconButton(
             icon: Icon(Icons.close),
             onPressed: () {_autenticador.signOut(); Navigator.of(context).pop(null);},
            )
          ],
          leading: Container(),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection("Alunos").document(widget.user.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child:CircularProgressIndicator());
            return Column( 
             children: <Widget> [
              Expanded(
              flex: 2,
              child: Container(           
              height: 50.0,
              width: 400.0,
              child: Padding(
               padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
               child: Column(
                 children: <Widget>[
                 Text("Olá " + snapshot.data["(a) Nome"] + "!", style:TextStyle(fontSize: 28)),
                 Padding(
                  padding:EdgeInsets.only(left: 46, right: 30),
                  child: Text(
                  "Aqui você poderá fazer contato com seus professores do Intituto Niten à distancia e seus companheiros da jornada no caminho do samurai!", 
                  style: TextStyle(fontSize: 22), 
                  ),
                 ),
                 SizedBox(height: 5),
                 Text("Nos vemos nas aulas!", style: TextStyle(fontSize: 22)),
                 SizedBox(height: 10),
                 Hero(
                   tag:"finalicação",
                   child: CircleAvatar(
                     backgroundColor: Colors.transparent,
                     radius: 25,
                     child: Image.asset('assets/icons/ffxiv_samurai.jpg'),
                   ),
                 ),
                ],
               ),
              ),
             ),
            ),
            Expanded(
              child: Container(
              width: 400.0,
              child: Padding(
               padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
               child: Column(
                 children: <Widget>[
                 Text("Olá " + snapshot.data["(a) Nome"] + "!", style:TextStyle(fontSize: 28)),
                 Padding(
                  padding:EdgeInsets.only(left: 46, right: 30),
                  child: Text(
                  "Aqui você poderá fazer contato com seus professores do Intituto Niten à distancia e seus companheiros da jornada no caminho do samurai!", 
                  style: TextStyle(fontSize: 22), 
                  ),
                 ),
                 SizedBox(height: 5),
                 Text("Nos vemos nas aulas!", style: TextStyle(fontSize: 22)),
                 SizedBox(height: 10),
                 Hero(
                   tag:"finalicação",
                   child: CircleAvatar(
                     backgroundColor: Colors.transparent,
                     radius: 25,
                     child: Image.asset('assets/icons/ffxiv_samurai.jpg'),
                   ),
                 ),
                ],
               ),
              ),
             ),
            ), 
           ],
          );    
         },
        ),         
       ),
      ], 
    );    
  }
}

