import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shoporia_app/controllers/auth_service.dart';
import 'package:shoporia_app/providers/user_provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Text(
                    'Signup',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Create your account and get started',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: _nameController,
                      validator: (value) =>
                          value!.isEmpty ? 'Name cant be Empty' : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Name'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) =>
                          value!.isEmpty ? 'Email cant be Empty' : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Email'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) => value!.length < 8
                          ? 'password must be min 8 characters long'
                          : null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text('Password'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          AuthService()
                              .createUserWithEmail(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text)
                              .then((value) {
                            if (value == 'account created') {
                              Provider.of<UserProvider>(context, listen: false)
                                  .loadUserData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Account created')));
                              Navigator.restorablePushNamedAndRemoveUntil(
                                  context, '/login', (route) => false);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  value,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red.shade400,
                              ));
                            }
                          });
                        }
                      },
                      child: Text(
                        'Signup',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: const Color.fromARGB(220, 7, 55, 139)),
                          ))
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
