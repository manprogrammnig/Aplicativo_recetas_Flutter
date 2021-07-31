import 'dart:io';
import 'package:app_recetas/src/components/image_picker_widget.dart';
import 'package:app_recetas/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/user.dart';

class RegisterPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;
  User userToEdit;

  RegisterPage(this.serverController, this.context, {Key key, this.userToEdit})
      : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();

  String userName = "";
  String password = "";

  String _errorMessage = "";

  File imageFile;
  bool showPassword = false;
  bool editinguser = false;

  Genrer genrer = Genrer.MALE;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            ImagePickerWidget(
                imageFile: this.imageFile,
                onImageSelected: (File file) {
                  setState(() {
                    imageFile = file;
                  });
                }),
            SizedBox(
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              height: kToolbarHeight,
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, -120),
                child: Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 260),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          initialValue: userName,
                          decoration: InputDecoration(labelText: "Usuario"),
                          onSaved: (value) {
                            userName = value;
                          },
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Este campo es obligatorio";
                            }
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          initialValue: password,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            suffixIcon: IconButton(
                              icon: Icon(showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: !showPassword,
                          onSaved: (value) {
                            password = value;
                          },
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Este campo es obligatorio";
                            }
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Género",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RadioListTile(
                                    title: Text(
                                      "Masculino",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: Genrer.MALE,
                                    groupValue: genrer,
                                    onChanged: (value) {
                                      setState(() {
                                        genrer = value;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: Text(
                                      "Femenino",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    value: Genrer.FEMALE,
                                    groupValue: genrer,
                                    onChanged: (value) {
                                      setState(() {
                                        genrer = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.white),
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            textColor: Colors.white,
                            onPressed: () => _doProcess(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    (editinguser) ? "Actualizar" : "Registrar"),
                                if (_loading)
                                  Container(
                                    height: 20,
                                    width: 20,
                                    margin: const EdgeInsets.only(left: 20),
                                    child: CircularProgressIndicator(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _doProcess(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (imageFile == null) {
        showSnackbar(context, "Seleccione una imágen por favor", Colors.orange);
        return;
      }
      User user = User(
          genrer: this.genrer,
          nickname: this.userName,
          password: this.password,
          photo: this.imageFile);
      var state;
      if (editinguser) {
        user.id = widget.serverController.loggedUser.id;
        state = await widget.serverController.updateUser(user);
      } else {
        state = await widget.serverController.addUser(user);
      }
      final action = editinguser ? "actualizar" : "guardar";
      final action2 = editinguser ? "actualizado" : "guardado";

      if (state == false) {
        showSnackbar(context, "No se pudo $action", Colors.orange);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Información"),
              content: Text("Su usuario se ha $action2 exitosamente"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },
        );
      }
    }
  }

  void showSnackbar(BuildContext context, String title, Color backColor) {
    _scaffKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: backColor,
      ),
    );
  }

  @override
  void initState() {
    //TODO: implemente initstate
    super.initState();
    editinguser = (widget.userToEdit != null);
    if (editinguser) {
      userName = widget.userToEdit.nickname;
      password = widget.userToEdit.password;
      imageFile = widget.userToEdit.photo;
      genrer = widget.userToEdit.genrer;
    }
  }

  void _update(BuildContext context) {}

  //@override
  //void initState() {
  //  super.initState();
  //  widget.serverController.init(widget.context);
  //}
}
