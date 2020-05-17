import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vecchio/providers/database.dart';
import 'home.dart';
import '.././widgets/inputs.dart';
import '.././widgets/text.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _spacing = 20;
  String _usernameOrEmail = "";
  String _password = "";

  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
            builder: (context) => Row(children: <Widget>[
                  // row padding
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),

                  //main row
                  Expanded(
                    flex: 8,
                    child: Form(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          obscureText: false,
                          autocorrect: false,
                          maxLengthEnforced: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "username or email",
                            icon: Icon(Icons.email),
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_typedUsername) {
                            setState(() {
                              _usernameOrEmail = (_typedUsername == null)
                                  ? ""
                                  : _typedUsername;
                            });
                          },
                        ),
                        SizedBox(height: _spacing),
                        TextFormField(
                          obscureText: true,
                          autocorrect: false,
                          maxLengthEnforced: true,
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
                        SizedBox(height: _spacing),

                        ButtonBar(
                          children: <Widget>[
                            ///
                            ///
                            /// LOGIN button
                            ///
                            ///
                            FlatButton(
                              onPressed: (_usernameOrEmail != "" && _password != "")
                                  ? () async {
                                        bool _userExists =
                                            await DatabaseProvider()
                                                .checkIfUserExists(
                                                    username: _usernameOrEmail, email: _usernameOrEmail);
                                        if (!_userExists){
                                            var snackBar = SnackBar(
                                                content: Text(
                                                    'No user found...\n'
                                                        'You can register by swiping to the right!'));
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                        }
                                        else {
                                          await DatabaseProvider().clearLocalStorage();
                                          await DatabaseProvider()
                                              .saveUserCredentialsToLocalStorage(
                                                  username: _usernameOrEmail);
                                          print(await DatabaseProvider().getLoggedUserCredentialsFromLocalStorage());
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()));
                                        }
                                    }
                                  : null,
                              child: Text("LOGIN"),
                            )
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
