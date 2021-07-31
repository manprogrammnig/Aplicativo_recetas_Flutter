import 'package:app_recetas/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modulo1_fake_backend/user.dart';

class LoginPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;

  LoginPage(this.serverController, this.context, {Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userName = "";
  String password = "";

  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.cyan[300], Colors.cyan[800]]),
              ),
              child: Image.asset(
                "assets/images/logo.png",
                color: Colors.white,
                height: mediaQuery.size.height *0.15,
              ),
            ),
            Transform.translate(
              offset: Offset(0, -120),
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, top: 260),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
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
                            decoration:
                                InputDecoration(labelText: "Contraseña"),
                            obscureText: true,
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
                          Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: Colors.white),
                            child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              textColor: Colors.white,
                              onPressed: () {
                                _login(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Iniciar sesión"),
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
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(child: Text("¿No estas registrado?")),
                              //Spacer(),
                              FlatButton(
                                child: Text("Registrarse"),
                                textColor: Theme.of(context).primaryColor,
                                onPressed: () {
                                  _showRegister(context);
                                },
                              )
                            ],
                          )
                        ],
                      ),
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

  void _login(BuildContext context) async {
    if (!_loading) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {
          _loading = true;
          _errorMessage = "";
        });
        User user = await widget.serverController.login(userName, password);
        if (user != null) {
          Navigator.of(context).pushReplacementNamed("/home", arguments: user);
        } else {
          setState(() {
            _errorMessage = "Usuario o contraseña incorrecto";
            _loading = false;
          });
        }
      }
    }
  }

  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed("/register");
  }

  @override
  void initState() {
    super.initState();
    widget.serverController.init(widget.context);
  }
}
