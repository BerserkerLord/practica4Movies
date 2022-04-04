import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green[700],
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/logoitc.png'),
                ),
                accountName: Text('ISC. Rubén Torres Frias'),
                accountEmail: Text('ruben.torres@itcelaya.edu.mx')),
            ListTile(
              title: Text('FruitApp'),
              subtitle: Text('Widget Challenge'),
              leading: Icon(Icons.restaurant, color: Colors.black),
              trailing: Icon(Icons.chevron_right, color: Colors.black),
              onTap: () {
                Navigator.pushNamed(context, '/fruit');
              },
            ),
            ListTile(
              title: Text('NotesApp'),
              subtitle: Text('Test SQLite'),
              leading: Icon(Icons.data_exploration, color: Colors.black),
              trailing: Icon(Icons.chevron_right, color: Colors.black),
              onTap: () {
                Navigator.pushNamed(context, '/notes');
              },
            ),
            ListTile(
              title: Text('MoviesApp'),
              subtitle: Text('Test API'),
              leading: Icon(Icons.movie, color: Colors.black),
              trailing: Icon(Icons.chevron_right, color: Colors.black),
              onTap: () {
                Navigator.pushNamed(context, '/movies');
              },
            )
          ],
        ),
      ),
    );
  }
}
