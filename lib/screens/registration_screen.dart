import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/logic/logic.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  final _regExpClass = RegExpClass();

  //firebase
  final _auth = FirebaseAuth.instance;

  //editing controller
  final TextEditingController _emailEditController = TextEditingController();
  final TextEditingController _passwordEditController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    //email edit feeld
    final emailEditFeeld = TextFormField(
      autofocus: false,
      controller: _emailEditController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ('Please Enter Your Email');
        }
        if (!_regExpClass.validEmail.hasMatch(value)) {
          return ('Please Enter a valid Email');
        }
        return null;
      },
      onSaved: (value) {
        _emailEditController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 10),
        labelText: 'Email',
        hintText: 'Enter@email.adress',
      ),
    );

    //password edit feeld

    final passwordEditFeeld = TextFormField(
      autofocus: false,
      controller: _passwordEditController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!_regExpClass.validPass.hasMatch(value)) {
          return ("'Enter 8 or more symbols'");
        }
      },
      onSaved: (value) {
        _passwordEditController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 10),
        labelText: 'Password',
        hintText: 'Use 8 or more symbols',
      ),
    );

    //password confirm feeld

    final passwordConfirmFeeld = TextFormField(
      autofocus: false,
      controller: _confirmPasswordController,
      validator: (value) {
        if (_confirmPasswordController.text != _passwordEditController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        _confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 10),
        labelText: 'Confirm Password',
      ),
    );

    //Registration button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.blue[900],
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        onPressed: () {
          signUp(_emailEditController.text, _passwordEditController.text);
        },
        child: const Text(
          'Registration',
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
                  emailEditFeeld,
                  const SizedBox(height: 20),
                  passwordEditFeeld,
                  const SizedBox(height: 20),
                  passwordConfirmFeeld,
                  const SizedBox(height: 45),
                  signUpButton,
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    //calling our firestore
    //colling our user model
    //sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.uid = user!.uid;
    userModel.email = user.email;

    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }
}
