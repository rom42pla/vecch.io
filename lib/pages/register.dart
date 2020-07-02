import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vecchio/providers/database.dart';
import 'home.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double spacing = 5;
  String _username = "";
  String _email = "";
  String _password = "";
  String _name = "";
  String _surname = "";
  double _spacing = 20;

  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
            builder: (context) => Row(children: <Widget>[
                  // row padding
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),

                  ///
                  ///
                  ///main row
                  Expanded(
                    flex: 8,
                    child: Form(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ///
                        /// Name and surname
                        ///
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          autocorrect: false,
                          maxLengthEnforced: true,
                          maxLength: 32,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "name",
                            icon: Icon(Icons.person),
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_typedName) {
                            setState(() {
                              _name = (_typedName == null) ? "" : _typedName;
                            });
                          },
                        ),
                        SizedBox(height: spacing),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          autocorrect: false,
                          maxLengthEnforced: true,
                          maxLength: 32,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "surname",
                            icon: Icon(Icons.people),
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_typedSurname) {
                            setState(() {
                              _surname =
                                  (_typedSurname == null) ? "" : _typedSurname;
                            });
                          },
                        ),
                        SizedBox(height: spacing),

                        ///
                        /// Credentials
                        ///
                        TextFormField(
                          obscureText: false,
                          autocorrect: false,
                          maxLengthEnforced: true,
                          maxLength: 32,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "username",
                            icon: Icon(Icons.account_circle),
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_typedUsername) {
                            setState(() {
                              _username = (_typedUsername == null)
                                  ? ""
                                  : _typedUsername;
                            });
                          },
                        ),
                        SizedBox(height: spacing),
                        TextFormField(
                          obscureText: false,
                          autocorrect: false,
                          maxLengthEnforced: true,
                          maxLength: 64,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "email",
                            icon: Icon(Icons.email),
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_typedEmail) {
                            setState(() {
                              _email = (_typedEmail == null) ? "" : _typedEmail;
                            });
                          },
                        ),
                        SizedBox(height: spacing),
                        TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          maxLengthEnforced: true,
                          maxLength: 32,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            labelText: "password",
                            icon: Icon(Icons.vpn_key),
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_typedPassword) {
                            setState(() {
                              _password = (_typedPassword == null)
                                  ? ""
                                  : _typedPassword;
                            });
                          },
                        ),
                        SizedBox(height: spacing),

                        ///
                        /// REGISTER button
                        ///
                        ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              onPressed: (_name != "" &&
                                      _surname != "" &&
                                      _username != "" &&
                                      _email != "" &&
                                      _password != "")
                                  ? () async {
                                      bool _userExists =
                                          await DatabaseProvider()
                                              .checkIfUserExists(
                                                  username: _username,
                                                  email: _email);
                                      print(_userExists);
                                      if (_userExists) {
                                        var snackBar = SnackBar(
                                            content: Text(
                                                'A user with this username or password already exists'));
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        await DatabaseProvider().createUser(
                                            name: _name,
                                            surname: _surname,
                                            email: _email,
                                            username: _username,
                                            password: _password);
                                        await DatabaseProvider().clearLocalStorage();
                                        await DatabaseProvider()
                                            .saveUserCredentialsToLocalStorage(
                                                username: _username);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()));
                                      }
                                    }
                                  : null,
                              child: Text("REGISTER"),
                            ),
                          ],
                        )
                      ],
                    )),
                  ),

                  // row padding
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  )
                ])));
  }
}
