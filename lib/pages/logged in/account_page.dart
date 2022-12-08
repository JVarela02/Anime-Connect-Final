// import 'dart:html';

// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_185_project/APIRouter.dart';
import 'package:csc_185_project/pages/logged in/login_page.dart';
import 'package:csc_185_project/pages/logged%20in/home.dart';
import 'package:csc_185_project/pages/logged%20in/search_and_result.dart';
import 'package:csc_185_project/read%20data/get_account_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register_page.dart';
import 'anime_input_page.dart';

class AccountPage extends StatefulWidget{
  const AccountPage({ Key? key }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final user = FirebaseAuth.instance.currentUser!;


  // full Names list
  List<String> fullNames = [];

  //get fullNames
  Future getfullName() async {
    await FirebaseFirestore.instance.collection('users')
    .where('email', isEqualTo: user.email)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference);
          fullNames.add(document.reference.id);
        },
      ),
    );
  }


  // user names
  List<String> userNames = [];

  //get userNames
  Future getuserName() async {
    await FirebaseFirestore.instance.collection('users')
    .where('email', isEqualTo: user.email)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference);
          userNames.add(document.reference.id);
        },
      ),
    );
  }

  List<String> topAnimesreference = []; 

  //get animeNames
  Future getanimeName() async {
    await FirebaseFirestore.instance.collection('animes')
    .where('email', isEqualTo: user.email)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference.id);
          topAnimesreference.add(document.reference.id);
        },
      ),
    );
  }

  List<String> topAnimesNotesreference = []; 

  //get animeNames
  Future getanimeNotes() async {
    await FirebaseFirestore.instance.collection('animes')
    .where('email', isEqualTo: user.email)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference.id);
          topAnimesNotesreference.add(document.reference.id);
        },
      ),
    );
  }

  Future getUsertop() async {
    await getanimeName();
    await getanimeNotes();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:
         const FittedBox(
           child: Padding(
             padding: EdgeInsets.only(left: 1.0),
             child: Align(
              alignment: Alignment.centerLeft,
              child: Text("My Account")
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
        Center(
          child: Column(
      
        children: [

        Expanded(
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

         Expanded(
               child: FutureBuilder(
                 future: getUsertop(),
                 builder:(context, snapshot) {
                   return ListView.builder(
                     itemCount: 1,
                     itemBuilder: ((context, index) {
                      if(topAnimesreference.isNotEmpty){
                       return 
                       ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Getanime1Name(anime1Name: topAnimesreference[0],),
                            Getanime1Rating(anime1Rating: topAnimesreference[0])
                          ],
                        ),
                        subtitle: Getanime1Note(anime1Note: topAnimesNotesreference[0]),
                       );
                      }
                      else{
                        return SizedBox(height:20);
                      }
                     }),);
                 },
               ),
             ),
      
         Expanded(
               child: FutureBuilder(
                 future: getUsertop(),
                 builder:(context, snapshot) {
                   return ListView.builder(
                     itemCount: 1,
                     itemBuilder: ((context, index) {
                      if(topAnimesreference.isNotEmpty){
                       return ListTile(
                         title: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Getanime2Name(anime2Name: topAnimesreference[0],),
                             Getanime2Rating(anime2Rating: topAnimesNotesreference[0])
                           ],
                         ),
                         subtitle: Getanime2Note(anime2Note: topAnimesNotesreference[0],)
                       );
                      }
                      else{
                        return SizedBox(height:10);
                      }
                     }),);
                 },
               ),
             ),
      
         Expanded(
               child: FutureBuilder(
                 future: getUsertop(),
                 builder:(context, snapshot) {
                   return ListView.builder(
                     itemCount: 1,
                     itemBuilder: ((context, index) {
                      if(topAnimesreference.isNotEmpty){
                       return ListTile(
                         title: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Getanime3Name(anime3Name: topAnimesreference[0],),
                             Getanime3Rating(anime3Rating: topAnimesreference[0])
                           ],
                         ),
                         subtitle: Getanime3Note(anime3Note: topAnimesNotesreference[0]),
                       );
                      }
                      else{
                        return SizedBox(height: 10,);
                      }
                     }),);
                 },
               ),
             ),
      
         Expanded(
               child: FutureBuilder(
                 future: getUsertop(),
                 builder:(context, snapshot) {
                   return ListView.builder(
                     itemCount: 1,
                     itemBuilder: ((context, index) {
                      if(topAnimesreference.isNotEmpty){
                       return ListTile(
                         title: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Getanime4Name(anime4Name: topAnimesreference[0],),
                             Getanime4Rating(anime4Rating: topAnimesreference[0])
                           ],
                         ),
                         subtitle: Getanime4Note(anime4Note: topAnimesNotesreference[0]),
                       );
                      }
                      else{
                        return SizedBox(height:10);
                      }
                     }),);
                 },
               ),
             ),
      
         Expanded(
               child: FutureBuilder(
                 future: getUsertop(),
                 builder:(context, snapshot) {
                   return ListView.builder(
                     itemCount: 1,
                     itemBuilder: ((context, index) {
                      if(topAnimesreference.isNotEmpty){
                       return ListTile(
                         title: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Getanime5Name(anime5Name: topAnimesreference[0],),
                             Getanime5Rating(anime5Rating: topAnimesNotesreference[0])
                           ],
                         ),
                        subtitle: Getanime5Note(anime5Note: topAnimesNotesreference[0]),
                       );
                      }
                      else{
                        return SizedBox(height:10);
                      }
                     }),);
                 },
               ),
             ),
        
      
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0,),
          child: 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                        onTap: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AnimePage();
                                    },
                                  ),
                                );
                              },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color:Color.fromARGB(255, 145, 132, 229),
                            border: Border.all(color: Colors.white,
                              width: 3),
                              borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Text("Update Top 5 Animes",
                            style: TextStyle(color: Colors.white),
                            ),
                            ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return friendsPage();
                                    },
                                  ),
                                );
                              },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color:Color.fromARGB(255, 145, 132, 229),
                            border: Border.all(color: Colors.white,
                              width: 3),
                              borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Text("Friends List",
                            style: TextStyle(color: Colors.white),
                            ),
                            ),
                        ),
                      ),
            ],
          ),
        ),

        SizedBox(height:10),

              
        ]
      
        ),
      
          ),
      
    );
    
  }

}


class friendsPage extends StatefulWidget {
  const friendsPage({super.key});

  @override
  State<friendsPage> createState() => _friendsPageState();
}


class _friendsPageState extends State<friendsPage> {
  List<String> friends = [];
  List<String> friendsInfo = [];

  getfriendsName() async {
    await FirebaseFirestore.instance.collection('friendships')
    .where('loggedUser', isEqualTo: user.email).where('check', isEqualTo: true)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print('found friend:');
          print(document.reference.id);
          friends.add(document.reference.id);
        },
      ),
    );
  }

    Future getFriendProfile() async{
    print("in get profile");
    await getfriendsName();
    print("back");
    if(friends.isNotEmpty)
    {
    print("in if");
    int i = 0;
    while(i<= (friends.length -1))
    {
    print("in while");
    print(friends[i]);
    var userCollection = FirebaseFirestore.instance.collection('friendships').doc(friends[i]);
    var userSnapShot = await userCollection.get();
    var friendEmail = "";
    Map<String,dynamic> friendlyFriend = userSnapShot.data()!;
    String selectedEmail = friendlyFriend['friend'];
    print(selectedEmail);
    friendEmail = selectedEmail;
    print("my friend" + friendEmail);

    await FirebaseFirestore.instance.collection('users')
    .where('email', isEqualTo: friendEmail)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print("User Id:" + document.reference.id);
          friendsInfo.add(document.reference.id);
        },
      ),
    );
    i = i + 1;
    }
    }
    else{
      print("big sad");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
         const FittedBox(
           child: Padding(
             padding: EdgeInsets.only(left: 1.0),
             child: Align(
              alignment: Alignment.centerLeft,
              child: Text("My Friends")
              ),
           ),
         ),
      ),



      body:  
        Center(
          child: Column(
      
        children: [

         Expanded(
               child: FutureBuilder(
                 future: getFriendProfile(),
                 builder:(context, snapshot) {
                   return ListView.builder(
                     itemCount: friendsInfo.length,
                     itemBuilder: ((context, index) {
                      if(friendsInfo.isNotEmpty){
                       print("number of friends: " + friendsInfo.length.toString());
                       print("in display" + friendsInfo[0]);
                       return ListTile(
                        title: GetFullName(fullName: friendsInfo[index]),
                        subtitle: GetuserName(userName: friendsInfo[index]),
                        //GetFriendEmail(friendEmail: friends[index],)
                        //subtitle: GetEmail(userEmail: friendsInfo[index]),
                       );
                      }
                      else{
                        return SizedBox(height:20);
                      }
                     }),);
                 },
               ),
             ),
        ]))
    );
  }
}