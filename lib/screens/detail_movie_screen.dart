import 'dart:async';
import 'package:flutter/material.dart';
import 'package:practica2/database/database_peliculas.dart';
import 'package:practica2/settings/settings_color.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../models/actor_model.dart';
class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({Key? key}) : super(key: key);

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  bool readMore = false;
  late DatabaseMovies dbMovies;
  late Map<String, dynamic> movie;

  @override
  void initState() {
    dbMovies = DatabaseMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    movie = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final maxLines = readMore ? null : 5;
    final overflow = readMore ? TextOverflow.visible : TextOverflow.ellipsis;
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: movie['trailer'],
      params: const YoutubePlayerParams(
        color: 'red',
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FutureBuilder<bool>(
            future: isFav,
            initialData: false,
            builder: (context, snapshot) {
              if(snapshot.hasError) {
                return const Icon(Icons.error, color: SettingsColor.warningColor);
              }
              else {
                if(snapshot.connectionState == ConnectionState.done){
                  return snapshot.data! ? IconButton(
                    onPressed: () async {
                      await dbMovies.delete(movie['id']);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(snack("Removido de favoritos"));
                    },
                    icon: const Icon(Icons.favorite, color: SettingsColor.secundaryColor)
                  ) :
                  IconButton(
                    onPressed: () async {
                      await dbMovies.insertar(movie);
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(snack("Agregado a favoritos"));
                    },
                    icon: const Icon(Icons.favorite_border, color: SettingsColor.secundaryColor)
                  );
                }
                else{
                  return const CircularProgressIndicator();
                }
              }
            }
          )
        ],
        backgroundColor: SettingsColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            headMovie(_controller),
            const SizedBox(height: 30.0),
            Text(movie['title'], style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: SettingsColor.secundaryColor)),
            const SizedBox(height: 10.0),
            Text('Lanzamiento: ' + movie['releaseDate'], style: const TextStyle(fontSize: 12, color: SettingsColor.secundaryColor, fontStyle: FontStyle.italic)),
            Text(movie['overview'], maxLines: maxLines, overflow: overflow, style: (const TextStyle(letterSpacing: 2.0, fontSize: 15.0, color: SettingsColor.secundaryColor))),
            buttonReadMore(),
            const SizedBox(height: 10.0),
            const Text("Elenco", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: SettingsColor.secundaryColor)),
            Row(children: [Expanded(child: _listActors())]),
            const SizedBox(height: 10.0),
            const Text("Poster", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: SettingsColor.secundaryColor)),
            gallery()
          ],
        ),
      ),
      backgroundColor: SettingsColor.primaryColor,
    );
  }

  Widget _listActors(){
    final movie = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return cardActor(index);
        },
        itemCount: movie['actors']!.length
      )
    );
  }

  Widget headMovie(_controller){
    return Container(
      child: movie['trailer'] == 'No trailer' ?
      FadeInImage(
        placeholder: const AssetImage('assets/activity_indicator.gif'),
        image: NetworkImage(
          'https://image.tmdb.org/t/p/w500/${movie['backdropPath']}'
        ),
        fadeInDuration: const Duration(milliseconds: 500),
      ) :
      YoutubePlayerIFrame(
        controller: _controller,
        aspectRatio: 16 / 9,
      )
    );
  }

  Widget buttonReadMore(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: SettingsColor.secundaryColor),
      onPressed: (){
        setState(() {
          readMore = !readMore;
        });
      },
      child: Text(readMore ? "Mostrar menos" : "Mostrar más", style: const TextStyle(color: SettingsColor.primaryColor)),
    );
  }

  Widget cardActor(index){
    return Card(
      child: Column(
        children: [
          Expanded(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                movie['actors'][index].profilePath != null ? 'https://image.tmdb.org/t/p/w500/${movie['actors'][index].profilePath}' : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
              )
            )
          ),
          Text(movie['actors'][index].name, style: const TextStyle(fontSize: 11, color: SettingsColor.primaryColor, fontWeight: FontWeight.bold)),
          Text(movie['actors'][index].character, style: const TextStyle(fontSize: 10, color: SettingsColor.primaryColor, fontStyle: FontStyle.italic)),
          const SizedBox(height: 5)
        ]
      )
    );
  }

  Widget gallery(){
    return Column(
      children: [
        FadeInImage(
          placeholder: const AssetImage('assets/activity_indicator.gif'),
          image: NetworkImage(
            'https://image.tmdb.org/t/p/w500/${movie['posterPath']}'
          ),
          fadeInDuration: const Duration(milliseconds: 500),
        )
      ]
    );
  }

  SnackBar snack(status){
    return SnackBar(
      content: Text(status),
      action: SnackBarAction(
        textColor: SettingsColor.secundaryColor,
        label: "¡Listo!",
        onPressed: (){},
      ),
    );
  }

  Future<bool> get isFav async {
    bool _isFavorite = await dbMovies.exists(movie);
    return _isFavorite;
  }
}
