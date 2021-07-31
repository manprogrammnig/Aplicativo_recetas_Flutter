import 'dart:ui';

import 'package:app_recetas/src/connection/server_controller.dart';
import 'package:app_recetas/src/screens/add_recipe_page.dart';
import 'package:app_recetas/src/screens/details_page.dart';
import 'package:app_recetas/src/screens/home_page.dart';
import 'package:app_recetas/src/screens/login_page.dart';
import 'package:app_recetas/src/screens/my_favorites_page.dart';
import 'package:app_recetas/src/screens/mys_recipes_page.dart';
import 'package:app_recetas/src/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';
import 'package:flutter_modulo1_fake_backend/user.dart';

ServerController _serverController = ServerController();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.cyan,
        accentColor: Colors.cyan[300],
        accentIconTheme: IconThemeData(
          color: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(color: Colors.white, fontSize: 20),
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            // ignore: missing_return
            builder: (BuildContext context) {
          switch (settings.name) {
            case "/":
              return LoginPage(_serverController, context);
            case "/home":
              User loggedUser = settings.arguments;
              _serverController.loggedUser = loggedUser;
              return HomePage(_serverController);
            case "/register":
              User looggedUser = settings.arguments;
              return RegisterPage(
                _serverController,
                context,
                userToEdit: looggedUser,
              );
            case "/favorites":
              return MyFavoritesPage(
                _serverController,
              );
            case "/my_recipes":
              return MyRecipesPage(
                _serverController,
              );
              case "/add_recipe":
              return AddRecipePage(
                _serverController,
              );
            case "/details":
              Recipe recipe = settings.arguments;
              return DetailsPage(
                recipe: recipe,
                serverController: _serverController,
              );
          }
        });
      },
    );
  }
}
