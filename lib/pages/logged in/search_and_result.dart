import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_185_project/APIRouter.dart';
import 'package:csc_185_project/pages/logged%20in/account_page.dart';
import 'package:csc_185_project/pages/logged%20in/home.dart';
import 'package:csc_185_project/read%20data/get_account_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';


class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {

  var searchTypes = ["Search", "Genre", "Anime", "User"];
  String searchType = "Search";
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              child: Text("Search Page")
              ),
           ),
         ),
      ),

      body:
      Center(
        child: Column(
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

      SizedBox(height:10),

      DropdownButton(
        value: searchType,
        underline: Container(
        height: 2,
        color: const Color.fromARGB(255, 227, 227, 243),
        ),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: searchTypes.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
        }).toList(),
        onChanged: (String? newValue) {
         // This is called when the user selects an item.
         setState(() {
         searchType = newValue!;
         });
        },
        ),

        SizedBox(height: 10,),

        Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 227, 227, 243),
                    border: Border.all(color: const Color.fromARGB(255, 235, 235, 235),
                    width: 3),
                    borderRadius: BorderRadius.circular(6),
                   ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:6.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Criteria",
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height:10),

               GestureDetector(
                onTap: (){
                  var route = MaterialPageRoute(
                    builder: (BuildContext context) => resultPage(
                      searchCriteria: _searchController.text.toString(),
                      searchType: searchType,),
                  );
                  Navigator.of(context).push(route);
                }, 
                child: Container(
                  height: 50,
                  width: 110,
                  decoration: BoxDecoration(
                    color:const Color.fromARGB(255, 145, 132, 229),
                    border: Border.all(color: Colors.white,
                      width: 3),
                      borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text("Search",
                    style: TextStyle(color: Color.fromARGB(255, 235, 235, 235)),
                    ),
                    ),
                ),
              ),



          ],), ),
    );
  }
}




class resultPage extends StatefulWidget {
  final String searchType;
  final String searchCriteria;
  const resultPage({super.key, required this.searchType, required this.searchCriteria});

  @override
  State<resultPage> createState() => _resultPageState();
}

class _resultPageState extends State<resultPage> {
  List<String> matchingUser = [];
  Future getUsers() async {
    await FirebaseFirestore.instance.collection('users')
    .where('username', isEqualTo: widget.searchCriteria)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference.id);
          matchingUser.add(document.reference.id);
        },
      ),
    ); 
  }


  Future getDetails(String selected) async {
    singleAnime A = await APISingleRouter().getAnimeInfo(selected);
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return animePage(selectedAnime: A.canonName, selectedDate: A.releaseDate, selectedDescription: A.synopsis, selectedImage: A.image,);
    }));
  }


  @override
  Widget build(BuildContext context) {
    if(widget.searchType == "Genre")
      {
      return Scaffold(
      appBar: AppBar(
        title:
         FittedBox(
           child: Padding(
             padding: const EdgeInsets.only(left: 1.0),
             child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Search Results")
              ),
           ),
         ),),

      body: 
      Column(
        children: [
      Expanded(
      child: FutureBuilder<List<genreAnimes>>(
          future: APIGenreRouter().getGenreAnimes(widget.searchCriteria),
          builder: (context, snapshot) {
            if(snapshot.hasData)
              {
            List<genreAnimes> animes= snapshot.data ?? [];
            return 
                Column(
                  children: [
                    Text(widget.searchCriteria.toUpperCase(),style: GoogleFonts.bigShouldersInlineDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                    Expanded(
                      child: ListView.builder(
                      itemCount: animes.length,
                      itemBuilder: (context,index)
                      {
                        return 
                          Column(
                            children: [
                              Text("------------------------------------------------------------------------------------------------"),
                              ListTile(
                              leading: Image.network(animes[index].poster),
                              //subtitle: Text(animes[index].info),
                              title: Text(animes[index].title),
                              onTap: () {
                              getDetails(animes[index].title,);
                              },
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
                      "Loading",
                      style: GoogleFonts.bigShouldersInlineDisplay(
                        fontSize: 60,
                        fontWeight: FontWeight.w500,
                      ),
                      ),
                      Text(
                      "Results",
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
        ],
      ),
      );
      }

    if(widget.searchType == "Anime") {
      return Scaffold(
        appBar: AppBar(
        title:
         FittedBox(
           child: Padding(
             padding: const EdgeInsets.only(left: 1.0),
             child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Search Results")
              ),
           ),
         ),),

      body: 
      Column(
        children: [
      Expanded(
      child: FutureBuilder<List<Anime>>(
          future: APIRouter().getAnime(widget.searchCriteria),
          builder: (context, snapshot) {
            if(snapshot.hasData)
              {
            List<Anime> animes= snapshot.data ?? [];
            return 
                Column(
                  children: [
                    Text(widget.searchCriteria.toUpperCase(),style: GoogleFonts.bigShouldersInlineDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                    SizedBox(height: 10,),
                    Expanded(
                      child: ListView.builder(
                      itemCount: animes.length,
                      itemBuilder: (context,index)
                      {
                        return 
                          Column(
                            children: [
                              Text("------------------------------------------------------------------------------------------------"),
                              ListTile(
                              leading: Image.network(animes[index].image),
                              title: Text(animes[index].canonName),
                              onTap: () {
                              getDetails(animes[index].canonName,);
                              },
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
                      "Loading",
                      style: GoogleFonts.bigShouldersInlineDisplay(
                        fontSize: 60,
                        fontWeight: FontWeight.w500,
                      ),
                      ),
                      Text(
                      "Results",
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
        ],
      ),
      );
    }

    if(widget.searchType == "User"){
      return Scaffold(
      appBar: AppBar(
        title:
         FittedBox(
           child: Padding(
             padding: const EdgeInsets.only(left: 1.0),
             child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Search Results")
              ),
           ),
         ),),

      body: Center(
          child: Column(
      
        children: [

         Expanded(
               child: FutureBuilder(
                 future: getUsers(),
                 builder:(context, snapshot) {
                   return ListView.builder(
                     itemCount: matchingUser.length,
                     itemBuilder: ((context, index) {
                      if(matchingUser.isNotEmpty){
                       return 
                       ListTile(
                        title: GetFullName(fullName: matchingUser[index],),
                        subtitle: GetuserName(userName: matchingUser[index],),
                        leading: Icon(Icons.accessibility_new_rounded),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                          String userIndex = matchingUser[index];
                          return userPage(userIndex: userIndex); 
                          }));
                        },
                       );
                      }
                      else{
                        return SizedBox(height:20);
                      }
                     }),);
                 },
               ),
             ),],))
         
         
      );

    }

    else{
      return Scaffold(
        appBar: AppBar(
        title:
         FittedBox(
           child: Padding(
             padding: const EdgeInsets.only(left: 1.0),
             child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Error")
              ),
           ),
         ),),
        body: Center(child: Column(
          children: [
            Text("No Search Type was Selected"),
          ],
        )));
    }
  }
}






class userPage extends StatefulWidget {
  final String userIndex;
  const userPage({super.key, required this.userIndex});

  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {

  String selectedUsername = "";

  List<String> topAnimesreference = []; 

  //get animeNames
  Future getanimeName() async {
    var userCollection = FirebaseFirestore.instance.collection('users').doc(widget.userIndex);
    var userSnapShot = await userCollection.get();
    var email = "";
    Map<String,dynamic> user = userSnapShot.data()!;
    String userEmail = user['email'];
    email = userEmail;

    await FirebaseFirestore.instance.collection('animes')
    .where('email', isEqualTo: email)
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
    var userCollection = FirebaseFirestore.instance.collection('users').doc(widget.userIndex);
    var userSnapShot = await userCollection.get();
    var selectedEmail = "";
    Map<String,dynamic> user = userSnapShot.data()!;
    String userSelectedEmail = user['email'];
    selectedEmail = userSelectedEmail;

    await FirebaseFirestore.instance.collection('animes')
    .where('email', isEqualTo: selectedEmail)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference.id);
          topAnimesNotesreference.add(document.reference.id);
        },
      ),
    );
  }

  List<String> myFriend = []; 
  List<String> notMyFriend = [];
  List<String> theirFriend = [];
  
  final user = FirebaseAuth.instance.currentUser!;

  Future checkMyFriendship() async {
    print("Running Check My Friendship");
    var userCollection = FirebaseFirestore.instance.collection('users').doc(widget.userIndex);
    var userSnapShot = await userCollection.get();
    var selectedEmail = "";
    Map<String,dynamic> selectedUser = userSnapShot.data()!;
    String userSelectedUser = selectedUser['email'];
    selectedEmail = userSelectedUser;

    await FirebaseFirestore.instance.collection('friendships')
    .where('loggedUser', isEqualTo: user.email).where('friend', isEqualTo: selectedEmail).where('check', isEqualTo: true)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference.id);
          myFriend.add(document.reference.id);
          print("Found my Friend");
        },
      ),
    );
    if(myFriend.isNotEmpty){
      print("List1: " + myFriend[0]);
    }
    print("The length of list 1 is: " + myFriend.length.toString());
    checkNotFriend();
  }

  Future checkNotFriend() async {
    print("Running Check Not Friend");
    var userCollection = FirebaseFirestore.instance.collection('users').doc(widget.userIndex);
    var userSnapShot = await userCollection.get();
    var selectedEmail = "";
    Map<String,dynamic> selectedUser = userSnapShot.data()!;
    String userSelectedUser = selectedUser['email'];
    selectedEmail = userSelectedUser;

    await FirebaseFirestore.instance.collection('friendships')
    .where('loggedUser', isEqualTo: user.email).where('friend', isEqualTo: selectedEmail).where('check', isEqualTo: false)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference.id);
          notMyFriend.add(document.reference.id);
          print("Found an Enemy");
        },
      ),
    );
    if(notMyFriend.isNotEmpty){
      print("List2: " + notMyFriend[0]);
    }
    print("The length of list 2 is: " + notMyFriend.length.toString());
    checkTheirFriendship();
  }

  Future checkTheirFriendship() async {
    print("Running check their friend");
    var userCollection = FirebaseFirestore.instance.collection('users').doc(widget.userIndex);
    var userSnapShot = await userCollection.get();
    var selectedEmail = "";
    Map<String,dynamic> selectedUser = userSnapShot.data()!;
    String userSelectedUser = selectedUser['email'];
    selectedEmail = userSelectedUser;

    await FirebaseFirestore.instance.collection('friendships')
    .where('loggedUser', isEqualTo: selectedEmail).where('friend', isEqualTo: user.email).where('check', isEqualTo: true)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference.id);
          theirFriend.add(document.reference.id);
          print("They're my Friend");
        },
      ),
    );
    if(theirFriend.isNotEmpty){
      print("List3: " + theirFriend[0]);
    }
    print("The length of list 3 is: " + theirFriend.length.toString());
  }

  Future checkFriendship() async {
    print("Checking Friendships");
     await checkMyFriendship();
    //checkNotFriend();
    //checkTheirFriendship();
  }

  Future getUsertop() async {
    await getanimeName();
    await getanimeNotes();
  }

  Future friendshipUpload() async {
    //checkFriendship();
    print("In friendship upload");
    var userCollection = FirebaseFirestore.instance.collection('users').doc(widget.userIndex);
    var userSnapShot = await userCollection.get();
    var selectedEmail = "";
    Map<String,dynamic> selectedUser = userSnapShot.data()!;
    String userSelectedUser = selectedUser['email'];
    selectedEmail = userSelectedUser;
    if(myFriend.isEmpty && notMyFriend.isEmpty){
      print("going to upload");
      uploadStatus(user.email.toString(), selectedEmail, true );
    }
    if(myFriend.isNotEmpty){
      print("updating false");
      updateStatus(user.email.toString(), selectedEmail, false, 1);
    }
    if(notMyFriend.isNotEmpty){
      print("updating true");
      updateStatus(user.email.toString(), selectedEmail, true, 2);
    }
    Navigator.pop(context);
    Navigator.push(context,MaterialPageRoute(
          builder: (context) {
          return userPage(userIndex: widget.userIndex,);
          },
        ),);
  }

  Future uploadStatus(String logged, String friend, bool check) async {
    await FirebaseFirestore.instance.collection("friendships").add({
      'loggedUser' : logged,
      'friend' : friend,
      'check' : true,
    });
    print("upload complete");
  }

  updateStatus(String logged, String friend, bool checked, int option) {
    if(option == 1){
        FirebaseFirestore.instance.collection("friendships").doc(myFriend[0]).update({
          'loggedUser' : logged,
          'friend' : friend,
          'check' : false,
        });
        print("update flase complete");
    }
    else{
      FirebaseFirestore.instance.collection("friendships").doc(notMyFriend[0]).update({
          'loggedUser' : logged,
          'friend' : friend,
          'check' : true,
        });
        print("update true complete");
    }
  }

  createText()  {
    //checkFriendship();
    if(myFriend.isEmpty) {
      print("In first if");
      return "Add Friend?";
    }
    if(myFriend.isNotEmpty) {
      print("In second if");
      return "Remove Friend?";
    }
    else{
      print("In else");
      return "awueifhiewu";
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
          FittedBox(
           child: Padding(
             padding: EdgeInsets.only(left: 1.0),
             child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Selected User")
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
                 future: getUsertop(),
                 builder:(context, snapshot) {
                   return ListView.builder(
                     itemCount: 1,
                     itemBuilder: ((context, index) {
                      if(topAnimesreference.isNotEmpty){
                       return 
                       ListTile(
                        title: Getanime1Name(anime1Name: topAnimesreference[0],),
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
                         title: Getanime2Name(anime2Name: topAnimesreference[0],),
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
                         title: Getanime3Name(anime3Name: topAnimesreference[0],),
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
                         title: Getanime4Name(anime4Name: topAnimesreference[0],),
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
                         title: Getanime5Name(anime5Name: topAnimesreference[0],),
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
          child: FutureBuilder(
            future: checkMyFriendship(),
            builder: ((context, snapshot) {
              return GestureDetector(onTap: () {
                friendshipUpload();
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
              child: Center(
              child: //buttonText(context)
               Text(createText(),
               style: TextStyle(color: Colors.white),
               ),
              ),
              ),);
            }),
            // child: GestureDetector(
            //   onTap: () {
            //     friendshipUpload();
            //   },
            // child: Container(
            //   height: 50,
            //   width: 200,
            //   decoration: BoxDecoration(
            //     color:Color.fromARGB(255, 145, 132, 229),
            //     border: Border.all(color: Colors.white,
            //    width: 3),
            //    borderRadius: BorderRadius.circular(6),
            //   ),
            //   child: Center(
            //   child: //buttonText(context)
            //    Text(createText(),
            //    style: TextStyle(color: Colors.white),
            //    ),
            //   ),
            //   ),
            //   ),
          ),
        ),

        SizedBox(height:10),

              
        ]
      
        ),
      
          ),
      
    );
  }
}

class animePage extends StatefulWidget {
  final String selectedAnime;
  final String selectedDescription;
  final String selectedDate;
  final String selectedImage;
  const animePage({super.key, required this.selectedAnime, required this.selectedDescription, required this.selectedDate, required this.selectedImage});

  @override
  State<animePage> createState() => _animePageState();
}

class _animePageState extends State<animePage> {

  List<String> matchingAccounts = []; 

  //get animeNames
  Future getMatchingAccounts1() async {
    print("1. checking 1");
    await FirebaseFirestore.instance.collection('animes')
    .where('anime 1'.toLowerCase(), isEqualTo: widget.selectedAnime.toLowerCase())
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print("checking 1");
          print(document.reference.id);
          matchingAccounts.add(document.reference.id);
        },
      ),
    );
  }
    Future getMatchingAccounts2() async{
    print("2. checking 2");
    await FirebaseFirestore.instance.collection('animes')
    .where('anime 2'.toLowerCase(), isEqualTo: widget.selectedAnime.toLowerCase())
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print("checking 2");
          print(document.reference.id);
          matchingAccounts.add(document.reference.id);
        },
      ),
    );}
    Future getMatchingAccounts3() async{
    print("3. checking 3");
    await FirebaseFirestore.instance.collection('animes')
    .where('anime 3'.toLowerCase(), isEqualTo: widget.selectedAnime.toLowerCase())
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print("checking 3");
          print(document.reference.id);
          matchingAccounts.add(document.reference.id);
        },
      ),
    );}
    Future getMatchingAccounts4() async{
    print("4. checking 4");
    await FirebaseFirestore.instance.collection('animes')
    .where('anime 4'.toLowerCase(), isEqualTo: widget.selectedAnime.toLowerCase())
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print("checking 4");
          print(document.reference.id);
          matchingAccounts.add(document.reference.id);
        },
      ),
    );}
    Future getMatchingAccounts5() async{
    print("5. checking 5");
    await FirebaseFirestore.instance.collection('animes')
    .where('anime 5'.toLowerCase(), isEqualTo: widget.selectedAnime.toLowerCase())
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print("checking 5");
          print(document.reference.id);
          matchingAccounts.add(document.reference.id);
        },
      ),
    );}
    
    Future getMatchingAccounts() async{
      await getMatchingAccounts1();
      await getMatchingAccounts2();
      await getMatchingAccounts3();
      await getMatchingAccounts4();
      await getMatchingAccounts5();
      print(matchingAccounts);
    }
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
          FittedBox(
           child: Padding(
             padding: EdgeInsets.only(left: 1.0),
             child: Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.selectedAnime)
              ),
           ),
         ),
      ),



      body:  
          SingleChildScrollView(
            child: Center(
              child: Column(
               
            children: [
            
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Image.network(widget.selectedImage),
                    SizedBox(height: 10),
                    Text("Original Release Date: " + widget.selectedDate, style: TextStyle(fontSize: 16),),
                    SizedBox(height: 10,),
                    Text(widget.selectedDescription, style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),

          
              // SingleChildScrollView(
              //   child: Center(
              //     child: Column(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsets.all(12.0),
              //           child: Column(
              //             children: [
              //               Image.network(widget.selectedImage),
              //               SizedBox(height: 10),
              //               Text("Original Release Date: " + widget.selectedDate, style: TextStyle(fontSize: 16),),
              //               SizedBox(height: 10,),
              //               Text(widget.selectedDescription, style: TextStyle(fontSize: 16),),
              //             ],
              //           ),
              //         ),
              //         // Expanded(
              //         //  child: 
              //         // FutureBuilder(
              //         //   future: getMatchingAccounts(),
              //         //   builder:(context, snapshot) {
              //         //     return ListView.builder(
              //         //      //scrollDirection: Axis.horizontal,
              //         //       itemCount: matchingAccounts.length,
              //         //       itemBuilder: ((context, index) {
              //         //        if(matchingAccounts.isNotEmpty){
              //         //         return ListTile(
              //         //           title: GetEmail( userEmail: matchingAccounts[index],),
              //         //           //subtitle: GetuserName(userName: matchingAccounts[index]),
              //         //         );
              //         //        }
              //         //        else{
              //         //          return SizedBox(height:10);
              //         //        }
              //         //       }),);
              //         //   },
              //         // ),
              //         //  ),
              //       ],
              //     ),
              //   ),
              // ),
         
             ],
             ),
             ),
           ),
    );
  }
}