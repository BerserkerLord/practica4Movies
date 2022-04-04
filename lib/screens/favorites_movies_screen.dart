import 'package:flutter/material.dart';
import 'package:practica2/settings/settings_color.dart';
import 'package:practica2/views/card_popular_view.dart';
import '../database/database_peliculas.dart';
import '../models/popular_model.dart';
import '../network/api_popular.dart';

class FavoritesMoviesScreen extends StatefulWidget {
  const FavoritesMoviesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesMoviesScreenState createState() => _FavoritesMoviesScreenState();
}

class _FavoritesMoviesScreenState extends State<FavoritesMoviesScreen> {
  ApiPopular? apiPopular;
  late DatabaseMovies dbMovies;

  @override
  void initState(){
    super.initState();
    dbMovies = DatabaseMovies();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites Movies'),
        backgroundColor: SettingsColor.primaryColor,
      ),
      body: FutureBuilder(
        future: dbMovies.getAllFavorites(),
        builder: (BuildContext context,
            AsyncSnapshot<List<PopularModel>?> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Ocurrio un error en la solicitud'),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              return _listFavouritesrMovies(snapshot.data);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        },
      ),
      backgroundColor: SettingsColor.primaryColor,
    );
  }

  Widget _listFavouritesrMovies(List<PopularModel>? movies) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.4),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
          itemBuilder: (context, index) {
            PopularModel popular = movies![index];
            return GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                  PageRouteBuilder(
                    barrierColor: SettingsColor.primaryColor,
                    barrierDismissible:true,
                    pageBuilder: (BuildContext context, _, __) {
                      return Container(
                        child: Hero(
                          tag: "image-poster${popular.id}",
                          child: FadeInImage(
                            placeholder: const AssetImage('assets/activity_indicator.gif'),
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500/${popular.posterPath}'
                            ),
                            fadeInDuration: const Duration(milliseconds: 500),
                          ),
                        ),
                      );
                    }
                  )
                );//dialogPoster(context, popular.posterPath);
              },
              child: Hero(
                tag: "image-poster${popular.id}",
                child: FadeInImage(
                  placeholder: const AssetImage('assets/activity_indicator.gif'),
                  image: NetworkImage('https://image.tmdb.org/t/p/w500/${popular.posterPath}'),
                  fadeInDuration: const Duration(milliseconds: 500),
                ),
              )
          );
        },
        itemCount: movies!.length,
      )
    );
  }
}

