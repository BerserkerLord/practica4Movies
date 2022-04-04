import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practica2/models/actor_model.dart';
import 'package:practica2/models/popular_model.dart';

class ApiPopular {
  static const String key = 'bb3b71dea9c54fafbc063a45c765ce72';
  static Uri urlMovies = Uri.parse(
      'https://api.themoviedb.org/3/movie/popular?api_key=$key&language=es-MX&page=1');

  Future<List<PopularModel>?> getAllPopular() async {
    var response = await http.get(urlMovies);
    if (response.statusCode == 200) {
      var popular = jsonDecode(response.body)['results'] as List;
      var listPopular = popular.map((movie) => PopularModel.fromMap(movie)).toList();
      movies: for(final movie in listPopular){
        var urlVideo = Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie.id.toString()}/videos?api_key=$key&language=es'
        );
        var urlActor = Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie.id.toString()}/credits?api_key=$key&language=es'
        );
        var responseActors = await http.get(urlActor);
        var responseVideo = await http.get(urlVideo);
        if(responseActors.statusCode == 200){
          List<dynamic> actors = jsonDecode(responseActors.body)['cast'];
          movie.actors = actors.map((actor) => Actor.fromMap(actor)).toList();
        }
        if(jsonDecode(responseVideo.body)['results'].toString() != "[]"){
          List<dynamic> videos = jsonDecode(responseVideo.body)['results'];
          bool existsAnyTrailer = false;
          for(final video in videos) {
            if(video['type'] == 'Trailer') {
              existsAnyTrailer = true;
            }
            if(existsAnyTrailer) {
              movie.trailer = video['key'];
              continue movies;
            }
            else {
              movie.trailer = 'No trailer';
            }
          }
        } else {
          movie.trailer = 'No trailer';
        }
      }
      return listPopular;
    } else {
      return null;
    }
  }

  Future<List<PopularModel>?> getAllFavourites(List<Map<String, Object?>> list) async {
    List<PopularModel> listFavourite = [];
    int i = 0;
    for(final movie in list){
      var urlMovie = Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie['id'].toString()}?api_key=$key&language=es'
      );
      var responseMovie = await http.get(urlMovie);
      if(responseMovie.statusCode == 200){
        Map<String, dynamic> movieResponse = Map<String, dynamic>.from(jsonDecode(responseMovie.body));
        listFavourite.add(PopularModel.fromMap(movieResponse));
      }
    }
    return listFavourite;
  }
}
