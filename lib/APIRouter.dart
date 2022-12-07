import 'package:csc_185_project/main.dart';
import 'package:csc_185_project/pages/logged in/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIRouter
{

  Future<List<Anime>> getAnime(String query) async
  {
    var result = await http.get(Uri.parse("https://kitsu.io/api/edge/anime?filter%5Btext%5D=" + query + "&page%5Blimit%5D=10"));
    var response = json.decode(result.body)['data'] as List<dynamic>;
    // print(response[0]);
    print(response.map((e) => e['attributes']['canonicalTitle']));
    return response.map((e) => Anime(
        e['attributes']['canonicalTitle'] as String,
        //e['attributes']['startDate'], //e['attributes']['synopsis'] as String
        e['attributes']['posterImage']['original'] as String
        )).toList();
  }
}

class APITopRouter
{

  Future<List<topAnime>> getTopAnime() async
  {
    var result = await http.get(Uri.parse("https://kitsu.io/api/edge/trending/anime"));
    var topResponse = json.decode(result.body)['data'] as List<dynamic>;
    // print(topResponse[0]);
    print(topResponse.map((e) => e['attributes']['canonicalTitle']));
    return topResponse.map((e) => topAnime(
      e['attributes']['canonicalTitle'] as String, 
      e['attributes']['posterImage']['original'] as String,
      e['attributes']['synopsis'] as String
      )).toList();
  }
}

class APIGenreRouter
{

  Future<List<genreAnimes>> getGenreAnimes(String query) async
  {
    var result = await http.get(Uri.parse("https://kitsu.io/api/edge/anime?filter%5Bcategories%5D=" + query + "&page%5Blimit%5D=20"));
    var topResponse = json.decode(result.body)['data'] as List<dynamic>;
    // print(topResponse[0]);
    print(topResponse.map((e) => e['attributes']['synopsis']));
    return topResponse.map((e) => genreAnimes(
      e['attributes']['canonicalTitle'] as String, 
      e['attributes']['posterImage']['original'] as String,
      //e['attributes']['synopsis'] as String
      )).toList();
  }
}

class APISingleRouter
{
  Future<singleAnime> getAnimeInfo(String query) async
  {
    var result = await http.get(Uri.parse("https://kitsu.io/api/edge/anime?filter%5Btext%5D=" + query + "&page%5Blimit%5D=1"));
    var response = json.decode(result.body)['data'] as List<dynamic>;
    // print(response[0]);
    print(response.map((e) => e['attributes']['canonicalTitle']));
    print(response.map((e) => e['attributes']['startDate']));
    print(response.map((e) => e['attributes']['synopsis']));
    print(response.map((e) => e['attributes']['posterImage']['original']));
    try{return response.map((e) => singleAnime(
        e['attributes']['canonicalTitle'] as String,
        e['attributes']['startDate'],e['attributes']['synopsis'] as String
        ,e['attributes']['posterImage']['original'] as String
        )).toList()[0];}catch(e){
          try{return response.map((e) => singleAnime(
        e['attributes']['canonicalTitle'] as String,
        e['attributes']['startDate'],"Descroption Not Available" as String
        ,e['attributes']['posterImage']['original'] as String
        )).toList()[0];} catch(e){
          try{return response.map((e) => singleAnime(
        e['attributes']['canonicalTitle'] as String,
        "Unavailable",e['attributes']['synopsis'] as String
        ,e['attributes']['posterImage']['original'] as String
        )).toList()[0];}catch(e){
          return response.map((e) => singleAnime(
        e['attributes']['canonicalTitle'] as String,
        "Not Available","Description Not Available"
        ,e['attributes']['posterImage']['original'] as String
        )).toList()[0];
        }
        }
        }
  }
}


class Anime
{
  String canonName;
  String image;
  Anime(this.canonName, this.image); 
}

// ignore: camel_case_types
class topAnime
{
  String name;
  String image;
  String description;
  topAnime(this.name, this.image, this.description);
}

class genreAnimes 
{
  String title;
  String poster;
  //String info;
  genreAnimes(this.title, this.poster);//, this.info);
}

class singleAnime
{
  String canonName;
  String releaseDate;
  String synopsis;
  String image;
  singleAnime(this.canonName, this.releaseDate, this.synopsis, this.image);
}