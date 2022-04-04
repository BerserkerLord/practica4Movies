import 'package:flutter/material.dart';
import 'package:practica2/models/popular_model.dart';
import 'package:practica2/settings/settings_color.dart';

class CardPopularView extends StatelessWidget {
  CardPopularView({Key? key, this.popularModel}) : super(key: key);

  PopularModel? popularModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, '/detail',
          arguments: {
            'title': popularModel!.title,
            'posterPath': popularModel!.posterPath,
            'overview': popularModel!.overview,
            'trailer': popularModel!.trailer,
            'actors': popularModel!.actors,
            'releaseDate': popularModel!.releaseDate,
            'id': popularModel!.id,
            'backdropPath': popularModel!.backdropPath
          }
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            imageMovie(),
            bandMovie()
          ]
        )
      )
    );
  }

  Widget imageMovie(){
    return FadeInImage(
      placeholder: const AssetImage('assets/activity_indicator.gif'),
      image: NetworkImage(
          'https://image.tmdb.org/t/p/w500/${popularModel!.backdropPath}'
      ),
      fadeInDuration: const Duration(milliseconds: 500),
    );
  }

  Widget bandMovie(){
    return Opacity(
      opacity: .5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 60,
        color: SettingsColor.bandColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                popularModel!.title!,
                style: const TextStyle(color: SettingsColor.secundaryColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.chevron_right,
                color: SettingsColor.secundaryColor,
              )
            )
          ]
        )
      )
    );
  }
}
