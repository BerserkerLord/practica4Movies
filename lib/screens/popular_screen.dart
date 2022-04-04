import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:practica2/models/popular_model.dart';
import 'package:practica2/network/api_popular.dart';
import 'package:practica2/views/card_popular_view.dart';
import 'package:practica2/settings/settings_color.dart';
import 'package:practica2/database/database_peliculas.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> with SingleTickerProviderStateMixin {
  late DatabaseMovies dbMovies;
  ApiPopular? apiPopular;
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    dbMovies = DatabaseMovies();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        backgroundColor: SettingsColor.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: bubbleButton(),
      body: FutureBuilder(
        future: apiPopular!.getAllPopular(),
        builder: (BuildContext context, AsyncSnapshot<List<PopularModel>?> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Ocurrio un error en la solicitud'),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              return _listPopularMovies(snapshot.data);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        }
      ),
      backgroundColor: SettingsColor.primaryColor,
    );
  }

  Widget _listPopularMovies(List<PopularModel>? movies) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemBuilder: (context, index) {
          PopularModel popular = movies![index];
          return CardPopularView(popularModel: popular);
        },
        separatorBuilder: (_, __) => const Divider(
          height: 10,
        ),
        itemCount: movies!.length
      )
    );
  }

  Widget bubbleButton(){
    return FloatingActionBubble(
      items: <Bubble>[
        Bubble(
          title:"Favoritas",
          iconColor: SettingsColor.primaryColor,
          bubbleColor: SettingsColor.secundaryColor,
          icon: Icons.favorite,
          titleStyle:const TextStyle(fontSize: 16 , color: SettingsColor.primaryColor),
          onPress: () {
            Navigator.pushNamed(context, '/favorites');
            //Navigator.pushNamed(context, '/favorites');
            _animationController.reverse();
          },
        ),
      ],
      animation: _animation,
      onPress: () => _animationController.isCompleted
          ? _animationController.reverse()
          : _animationController.forward(),
      iconColor: SettingsColor.primaryColor,
      iconData: Icons.add,
      backGroundColor: SettingsColor.secundaryColor,
    );
  }
}
