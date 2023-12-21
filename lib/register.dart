import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // String? _email, _password;
  // String? _confirmPassword;
  bool _isObscured1 = true;
  bool _isObscured2 = true;
  bool isLoading = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? temp;
  createUserWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
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
      if (e.code == 'weak-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The password provided is too weak."),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The account already exists for that email."),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
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
              const Text(
                'SIGN-UP',
                style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.w700),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Your User Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'User name is required.';
                          }
                          if (value.length < 3) {
                            return 'Please enter a Name with at least 3 characters';
                          }
                          if (value.length >= 20) {
                            return 'Please enter a Name with maximum of 20 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Your E-mail',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required.';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: TextFormField(
                        controller: _password,
                        obscureText: _isObscured1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured1 = !_isObscured1;
                              });
                            },
                            icon: Icon(
                              _isObscured1
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          temp = value;
                          if (value!.isEmpty) {
                            return 'Password is required.';
                          }
                          if (value.length < 6) {
                            return 'Please enter a password with at least 6 characters';
                          }
                          if (value.length > 20) {
                            return 'Please enter a password with maximum of 20 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                      child: TextFormField(
                        obscureText: _isObscured2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Re-Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured2 = !_isObscured2;
                              });
                            },
                            icon: Icon(
                              _isObscured2
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required.';
                          }
                          if (temp != value) {
                            return 'Password not matching.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              createUserWithEmailAndPassword();
                            } catch (e) {
                              print(e);
                            }
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
                                'Sign-up',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20.0, 30.0, 10.0, 0),
                child: Row(
                  children: [
                    const Text(
                      'If you already have an account ?',
                      style: TextStyle(fontSize: 17.0, color: Colors.blue),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/LoginPage');
                      },
                      child: const Text(
                        'Log-in',
                        style: TextStyle(fontSize: 17.0, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
