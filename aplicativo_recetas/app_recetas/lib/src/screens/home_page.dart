import 'package:app_recetas/src/components/my_drawer.dart';
import 'package:app_recetas/src/components/recipe_widget.dart';
import 'package:app_recetas/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/models.dart';

class HomePage extends StatefulWidget {
  final ServerController serverController;

  HomePage(this.serverController, {Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My CookBook"),
      ),
      drawer: MyDrawer(
        widget.serverController,
      ),
      body: FutureBuilder<List<Recipe>>(
        future: widget.serverController.getRecipeList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Recipe recipe = list[index];
                return RecipeWidget(
                  recipe: recipe,
                  serverController: widget.serverController,
                  onChange: () {
                    setState(() {});
                  },
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("/add_recipe");
        },
        //foregroundColor: Colors.white,
      ),
    );
  }
}
