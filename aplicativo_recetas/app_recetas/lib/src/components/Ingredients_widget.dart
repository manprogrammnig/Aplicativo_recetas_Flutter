import 'package:flutter/material.dart';

typedef OnIngredientDeleteCallback = void Function(int index);

class IngredientsWidget extends StatelessWidget {
  final int index;
  final String ingredientsName;
  final OnIngredientDeleteCallback onIngredientDeleteCallback;
  final OnIngredientDeleteCallback onIngredientEditCallback;

  const IngredientsWidget({
    this.index,
    this.ingredientsName,
    this.onIngredientDeleteCallback,
    this.onIngredientEditCallback,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Color textColor = Colors.black;
    Color backColor = Colors.white;
    if ((index % 2) == 1) {
      backColor = Colors.grey[300];
    }

    return DecoratedBox(
      decoration: BoxDecoration(color: backColor),
      child: ListTile(
          leading: Text(
            "${index + 1}",
            style: TextStyle(fontSize: 16),
          ),
          title: Text(
            ingredientsName,
            style: TextStyle(fontSize: 16),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  this.onIngredientEditCallback(index);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  this.onIngredientDeleteCallback(index);
                },
              ),
            ],
          )),
    );
  }
}
