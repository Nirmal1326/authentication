import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  // String? _email, _password;
  bool _isObscured = true;
  bool isLoading = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _email.text,
            password: _password.text,
          )
          .then((value) => Navigator.pushReplacementNamed(
                context,
                '/HomePage',
              ));
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'invalid-credential') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Your email or password was wrong."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0), //or 15.0
                child: Container(
                  height: 100.0,
                  width: 100.0,
                  color: Colors.white,
                  child: const Image(
                    image: AssetImage('images/auth.png'),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: const Center(
                child: Text(
                  'SIGN-IN',
                  style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.blue,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 0),
                      child: TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Your E-mail',
                        ),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Email is required.';
                          }
                          if (text == 'nirmal06112002@gmail.com') {
                            return 'Enter a valid mail';
                          }
                          if (!text.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0),
                      child: TextFormField(
                        obscureText: _isObscured,
                        controller: _password,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Password is required.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signInWithEmailAndPassword();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          // add boxShadow property
                          shadowColor: MaterialStateProperty.all(Colors.black),
                          elevation: MaterialStateProperty.all(20),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.red,
                              )
                            : const Text(
                                'Sign-in',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(20.0, 30.0, 10.0, 0),
              child: Row(
                children: [
                  const Text(
                    'If you don’t have an account ?',
                    style: TextStyle(fontSize: 17.0, color: Colors.blue),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/RegisterPage');
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 17.0, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
