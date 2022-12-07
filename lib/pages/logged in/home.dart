import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_185_project/APIRouter.dart';
import 'package:csc_185_project/pages/logged in/account_page.dart';
import 'package:csc_185_project/pages/logged in/login_page.dart';
import 'package:csc_185_project/pages/logged%20in/search_and_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser!;

  List<String> userreference = [];
  Future getUsesr() async {
    await FirebaseFirestore.instance.collection('users')
    .where('email', isEqualTo: user.email)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference.id);
          userreference.add(document.reference.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
         FittedBox(
           child: Padding(
             padding: const EdgeInsets.only(left: 1.0),
             child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Home")
              ),
           ),
         ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
              onTap: () async {
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => false);
                Navigator.push(context,MaterialPageRoute(
                           builder: (context) {
                           return LoginPage(showRegisterPage: () {  },);
                          },
                        ), );
              },
                child: const Text("Logout",
                style: TextStyle(
                  color : Colors.white,
                  fontWeight: FontWeight.bold,
                ))
                     ),
            ),
          )],
      ),


    body:
    Column(
      children: [
      Container(
        child: ButtonBar(
            alignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: (){
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return HomePage();
              }));
              }, // route to home page
              child: Text('Home'),
            ),
            ElevatedButton(
              onPressed: (){
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return searchPage(); // CHANGE TO SEARCH PAGE
              }));
              }, // route to search page
              child: Text('Search'),
            ),
            ElevatedButton(
              onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return AccountPage(); 
              }));
              }, // route to account page
              child: Text('Account'),
            ),
          ]
        )
      ),

    SizedBox(height: 10),

    Expanded(
      child: FutureBuilder<List<topAnime>>(
          future: APITopRouter().getTopAnime(),
          builder: (context, snapshot) {
            if(snapshot.hasData)
              {
            List<topAnime> animes= snapshot.data ?? [];
            return 
                Column(
                  children: [
                    Text("What's Hot Right Now",style: GoogleFonts.bigShouldersInlineDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                    Expanded(
                      child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context,index)
                      {
                        return 
                          Column(
                            children: [
                              Text("------------------------------------------------------------------------------------------------"),
                              ListTile(
                              leading: Image.network(animes[index].image),
                              subtitle: Text(animes[index].description),
                              title: Text(animes[index].name),
                        ),
                            ],
                          );
                      }),
                    ),
                  ],
                );
                }
              else{
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                      "Welcome To",
                      style: GoogleFonts.bigShouldersInlineDisplay(
                        fontSize: 60,
                        fontWeight: FontWeight.w500,
                      ),
                      ),
                      Text(
                      "Anime Connect",
                      style: GoogleFonts.bigShouldersInlineDisplay(
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 145, 132, 229),
                      ),
                      ),
                    ],
                  ),
                );
              }
          }
      ),
    ),

    ],)

    );
  }
}