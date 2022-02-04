import 'package:email_password_login/logic/logic.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hidePass = true;

  //firebase
  final _auth = FirebaseAuth.instance;

  // form key
  final _formKey = GlobalKey<FormState>();

  // user model
  UserModel loggedInUser = UserModel();

  //editing controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final regExpClass = RegExpClass();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //email feeld
    final emailFeeld = TextFormField(
      autofocus: false,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ('Please Enter Your Email');
        }
        if (!regExpClass.validEmail.hasMatch(value)) {
          return ('Please Enter a valid Email');
        }
        return null;
      },
      onSaved: (value) => loggedInUser.email = value!,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 10),
        labelText: 'Email',
        hintText: 'Enter@email.adress',
      ),
    );

    //password feeld
    final passwordFeeld = TextFormField(
      autofocus: false,
      controller: _passwordController,
      obscureText: _hidePass,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regExpClass.validPass.hasMatch(value)) {
          return ("'Enter 8 or more symbols'");
        }
      },
      onSaved: (value) => loggedInUser.password = value!,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        labelText: 'Password',
        hintText: 'Use 8 or more symbols',
        suffixIcon: IconButton(
          icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _hidePass = !_hidePass;
            });
          },
        ),
      ),
    );

    //login button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.blueAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        onPressed: () {
          signIn(_emailController.text, _passwordController.text);
        },
        child: const Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 100),
                  emailFeeld,
                  const SizedBox(height: 20),
                  passwordFeeld,
                  const SizedBox(height: 45),
                  loginButton,
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Don't have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen()));
                        },
                        child: const Text(
                          " Register",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //login function

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Login Successful"),
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen())),
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
      print('Mail: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      print('loggedInUser1: ${loggedInUser.email}');
      print('loggedInUser2: ${loggedInUser.password}');
    }
  }
}
