import 'package:flutter/material.dart';
import 'package:practica2/screens/dashboard.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isValidating = false;
  @override
  Widget build(BuildContext context) {
    var txtUsuarioController = TextEditingController();
    var txtPasswordController = TextEditingController();

    final txtUsuario = TextFormField(
        controller: txtUsuarioController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Introduce el usuario',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    final txtPassword = TextFormField(
        controller: txtPasswordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Introduce el password',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))));

    final btnEntrar = ElevatedButton(
        onPressed: () {
          //print(txtUsuarioController.text);
          isValidating = !isValidating;
          setState(() {});
          Future.delayed(new Duration(seconds: 4), () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          });
        },
        child: Text('Entrar'));

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/paisaje.jpeg"), fit: BoxFit.fill)),
        ),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                txtUsuario,
                SizedBox(
                  height: 5,
                ),
                txtPassword,
                SizedBox(
                  height: 5,
                ),
                btnEntrar
              ],
            ),
          ),
        ),
        Positioned(
          child: Image.asset(
            'assets/logoitc.png',
            width: 100,
          ),
          bottom: 200,
        ),
        Positioned(
            child: isValidating ? CircularProgressIndicator() : Container(),
            bottom: 350)
      ],
    );
  }
}
