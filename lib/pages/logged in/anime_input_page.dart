import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_185_project/pages/logged%20in/account_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimePage extends StatefulWidget {
  const AnimePage({super.key});

  @override
  State<AnimePage> createState() => _AnimePageState();
}

final user = FirebaseAuth.instance.currentUser!;


List<String> hasDataArray = [];

  //get fullNames
   checkAnimeData()  {
    FirebaseFirestore.instance.collection('animes')
    .where('email', isEqualTo: user.email)
    .get().then(
      (snapshot) => snapshot.docs.forEach(
        (document) {
          print(document.reference);
          hasDataArray.add(document.reference.id);
        },
      ),
    );
  }

class _AnimePageState extends State<AnimePage> {
  final user = FirebaseAuth.instance.currentUser!;

  String animeGenre1 = "Genre";
  String animeGenre2 = "Genre"; 
  String animeGenre3 = "Genre"; 
  String animeGenre4 = "Genre"; 
  String animeGenre5 = "Genre"; 
  String animeRating1 = "Rating";
  String animeRating2 = "Rating";
  String animeRating3 = "Rating";
  String animeRating4 = "Rating";
  String animeRating5 = "Rating";
  var genres = ["Genre", "Shonen", "Shojo", "Slice of Life", "Adventure", "Fantasy", "Romance", "Sports", "Comedy", "Isekai", "Horror", "Sci-Fi"];
  var rating = ["Rating", "1", "2", "3", "4", "5"];

  //anime controllers
  final _animeController1 = TextEditingController();
  final _animeController2 = TextEditingController();
  final _animeController3 = TextEditingController();
  final _animeController4 = TextEditingController();
  final _animeController5 = TextEditingController();
  final _animeNoteController1 = TextEditingController();
  final _animeNoteController2 = TextEditingController();
  final _animeNoteController3 = TextEditingController();
  final _animeNoteController4 = TextEditingController();
  final _animeNoteController5 = TextEditingController();

  @override
  void dispose() {
    _animeController1.dispose();
    _animeController2.dispose();
    _animeController3.dispose();
    _animeController4.dispose();
    _animeController5.dispose();
    _animeNoteController1.dispose();
    _animeNoteController2.dispose();
    _animeNoteController3.dispose();
    _animeNoteController4.dispose();
    _animeNoteController5.dispose();
    super.dispose();
  }

  Future animesUpload() async{
    checkAnimeData();
    // add anime list
    if(hasDataArray.isEmpty)
    {try{addAnimeDetails(
      user.email.toString(),
      _animeController1.text.trim(), 
      _animeController2.text.trim(), 
      _animeController3.text.trim(), 
      _animeController4.text.trim(),
      _animeController5.text.trim(),
      _animeNoteController1.text.trim(), 
      _animeNoteController2.text.trim(), 
      _animeNoteController3.text.trim(), 
      _animeNoteController4.text.trim(),
      _animeNoteController5.text.trim(),
      animeGenre1, 
      animeGenre2, 
      animeGenre3, 
      animeGenre4,
      animeGenre5,
      int.parse(animeRating1), 
      int.parse(animeRating2), 
      int.parse(animeRating3), 
      int.parse(animeRating4),
      int.parse(animeRating5),);
      Navigator.popUntil(context, (route) => false);
        Navigator.push(context,MaterialPageRoute(
          builder: (context) {
          return AccountPage();
          },
        ),);
      print("Add");
      showDialog(context: context, builder: (context){
          return const AlertDialog(
              content: Text("Anime Added"),
          );
        });
        }
       on Exception catch (e) {
      showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text("Error Uploading Please Check Your Inputs"),
        );
      });
      }}
      else{
        try{updateAnimeDetails(
      user.email.toString(),
      _animeController1.text.trim(), 
      _animeController2.text.trim(), 
      _animeController3.text.trim(), 
      _animeController4.text.trim(),
      _animeController5.text.trim(),
      _animeNoteController1.text.trim(), 
      _animeNoteController2.text.trim(), 
      _animeNoteController3.text.trim(), 
      _animeNoteController4.text.trim(),
      _animeNoteController5.text.trim(),
      animeGenre1, 
      animeGenre2, 
      animeGenre3, 
      animeGenre4,
      animeGenre5,
      int.parse(animeRating1), 
      int.parse(animeRating2), 
      int.parse(animeRating3), 
      int.parse(animeRating4),
      int.parse(animeRating5),);
      print("update");
      Navigator.popUntil(context, (route) => false);
        Navigator.push(context,MaterialPageRoute(
          builder: (context) {
          return AccountPage();
          },
        ),);
      showDialog(context: context, builder: (context){
          return const AlertDialog(
              content: Text("Anime Added"),
          );
        });}
       on Exception catch (e) {
      showDialog(context: context, builder: (context){
        return const AlertDialog(
          content: Text("Error Uploading Please Check Your Inputs"),
        );
      });
      }
      }
    }
  

  Future addAnimeDetails(String email,
   String anime1, String anime2, String anime3, String anime4, String anime5,
   String animenote1, String animenote2, String animenote3, String animenote4, String animenote5,
   String animegenre1, String animegenre2, String animegenre3, String animegenre4, String animegenre5,
   int animerating1, int animerating2, int animerating3, int animerating4, int animerating5,) async{
    await FirebaseFirestore.instance.collection("animes").add({
      'email': email,
      'anime 1': anime1,
      'anime note 1': "  $animenote1",
      'anime genre 1' : animegenre1,
      'anime rating 1' : animeRating1,
      'anime 2': anime2,
      'anime note 2': "  $animenote2",
      'anime genre 2' : animegenre2,
      'anime rating 2' : animeRating2,
      'anime 3': anime3,
      'anime note 3': "  $animenote3",
      'anime genre 3' : animegenre3,
      'anime rating 3' : animeRating3,
      'anime 4': anime4,
      'anime note 4': "  $animenote4",
      'anime genre 4' : animegenre4,
      'anime rating 4' : animeRating4,
      'anime 5': anime5,
      'anime note 5': "  $animenote5",
      'anime genre 5' : animegenre5,
      'anime rating 5' : animeRating5,
    });
  }

  updateAnimeDetails(String email,
   String anime1, String anime2, String anime3, String anime4, String anime5,
   String animenote1, String animenote2, String animenote3, String animenote4, String animenote5,
   String animegenre1, String animegenre2, String animegenre3, String animegenre4, String animegenre5,
   int animerating1, int animerating2, int animerating3, int animerating4, int animerating5,) {
    FirebaseFirestore.instance.collection("animes").doc(hasDataArray[0]).update({
      'email': email,
      'anime 1': anime1,
      'anime note 1': "  $animenote1",
      'anime genre 1' : animegenre1,
      'anime rating 1' : animeRating1,
      'anime 2': anime2,
      'anime note 2': "  $animenote2",
      'anime genre 2' : animegenre2,
      'anime rating 2' : animeRating2,
      'anime 3': anime3,
      'anime note 3': "  $animenote3",
      'anime genre 3' : animegenre3,
      'anime rating 3' : animeRating3,
      'anime 4': anime4,
      'anime note 4': "  $animenote4",
      'anime genre 4' : animegenre4,
      'anime rating 4' : animeRating4,
      'anime 5': anime5,
      'anime note 5': "  $animenote5",
      'anime genre 5' : animegenre5,
      'anime rating 5' : animeRating5,
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),

    //email textfield
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Add Animes",
                style: GoogleFonts.bigShouldersInlineDisplay(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                ),

            const SizedBox(height: 20,),

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
                      controller: _animeController1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Anime 1",
                      ),
                    ),
                  ),
                ),
              ),
            
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton(
                    value: animeGenre1,
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 227, 227, 243),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: genres.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        animeGenre1 = newValue!;
                      });
                    },
                  ),
                  DropdownButton(
                    value: animeRating1,
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 227, 227, 243),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: rating.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        animeRating1 = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),

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
                      controller: _animeNoteController1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Anime 1 Notes",
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height:15),
            Text("----------------------------------------------------------",
            style: GoogleFonts.bigShouldersInlineDisplay(color: Color.fromARGB(255, 145, 132, 229),fontWeight: FontWeight.bold),),
            const SizedBox(height: 15,),


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
                    controller: _animeController2,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Anime 2",
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton(
                    value: animeGenre2,
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 227, 227, 243),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: genres.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        animeGenre2 = newValue!;
                      });
                    },
                  ),
                  DropdownButton(
                    value: animeRating2,
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 227, 227, 243),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: rating.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        animeRating2 = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),

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
                      controller: _animeNoteController2,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Anime 2 Notes",
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height:15),
            Text("----------------------------------------------------------",
            style: GoogleFonts.bigShouldersInlineDisplay(color: Color.fromARGB(255, 145, 132, 229),fontWeight: FontWeight.bold),),
            const SizedBox(height: 15,),


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
                      controller: _animeController3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Anime 3",
                      ),
                    ),
                  ),
                ),
              ),

              Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton(
                    value: animeGenre3,
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 227, 227, 243),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: genres.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        animeGenre3 = newValue!;
                      });
                    },
                  ),
                  DropdownButton(
                    value: animeRating3,
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 227, 227, 243),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: rating.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        animeRating3 = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),


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
                      controller: _animeNoteController3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Anime 3 Notes",
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height:15),
            Text("----------------------------------------------------------",
            style: GoogleFonts.bigShouldersInlineDisplay(color: Color.fromARGB(255, 145, 132, 229),fontWeight: FontWeight.bold),),
            const SizedBox(height: 15,),

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
                        controller: _animeController4,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Anime 4",
                        ),
                      ),
                    ),
                  ),
                ),

              Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton(
                    value: animeGenre4,
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 227, 227, 243),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: genres.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        animeGenre4 = newValue!;
                      });
                    },
                  ),
                  DropdownButton(
                    value: animeRating4,
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 227, 227, 243),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: rating.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        animeRating4 = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),

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
                      controller: _animeNoteController4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Anime 4 Notes",
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height:15),
            Text("----------------------------------------------------------",
            style: GoogleFonts.bigShouldersInlineDisplay(color: Color.fromARGB(255, 145, 132, 229),fontWeight: FontWeight.bold),),
            const SizedBox(height: 15,),

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
                        controller: _animeController5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Anime 5",
                        ),
                      ),
                    ),
                  ),
                ),

                Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton(
                    value: animeGenre5,
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 227, 227, 243),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: genres.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        animeGenre5 = newValue!;
                      });
                    },
                  ),
                  DropdownButton(
                    value: animeRating5,
                    underline: Container(
                      height: 2,
                      color: const Color.fromARGB(255, 227, 227, 243),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: rating.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      // This is called when the user selects an item.
                      setState(() {
                        animeRating5 = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),

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
                      controller: _animeNoteController5,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Anime 5 Notes",
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),
               
              //sign in button
              GestureDetector(
                onTap: animesUpload, 
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
                    child: Text("Add Animes",
                    style: TextStyle(color: Color.fromARGB(255, 235, 235, 235)),
                    ),
                    ),
                ),
              ),
              SizedBox(height:10),
            ]
          ),
        ),
      ),
    ),

    );
  }
}