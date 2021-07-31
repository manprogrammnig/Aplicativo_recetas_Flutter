import 'package:app_recetas/src/connection/server_controller.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final ServerController serverController;
  const MyDrawer(this.serverController, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/drawer.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            accountName: Text(
              serverController.loggedUser.nickname,
              style: TextStyle(color: Colors.white),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: FileImage(serverController.loggedUser.photo),
            ),
            onDetailsPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/register",
                  arguments: serverController.loggedUser);
            },
            arrowColor: Colors.cyan,
          ),
          ListTile(
            title: Text(
              "Mis recetas",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.book,
              color: Colors.green,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/my_recipes");
            },
          ),
          ListTile(
            title: Text(
              "Mis favoritos",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/favorites");
            },
          ),
          ListTile(
            title: Text(
              "Cerrar sesión",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.power_settings_new,
              color: Colors.cyan,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/");
            },
          )
        ],
      ),
    );
  }
}
