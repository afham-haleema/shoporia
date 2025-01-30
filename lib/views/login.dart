import 'package:flutter/material.dart';
import 'package:shoporia_app/controllers/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                    'Login',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Get Started with your account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 60,
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
                      controller: _passwordController,
                      obscureText: true,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  return AlertDialog(
                                    title: Text('Forgot password'),
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Enter your Email'),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                          controller: _emailController,
                                          validator: (value) => value!.isEmpty
                                              ? 'Email cant be Empty'
                                              : null,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text('Email'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            if (_emailController.text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'email cant be empty')));
                                            }
                                            await AuthService()
                                                .sendResetEmail(
                                                    _emailController.text)
                                                .then((value) {
                                              if (value == 'mail sent') {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text('Mail sent')));
                                                Navigator.pop(context);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    value,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor:
                                                      Colors.red.shade400,
                                                ));
                                              }
                                            });
                                          },
                                          child: Text('Submit'))
                                    ],
                                  );
                                });
                          },
                          child: Text('Forgot password'))
                    ],
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
                              .loginWithEmail(_emailController.text,
                                  _passwordController.text)
                              .then((value) {
                            if (value == 'login successful') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Login successful')));
                              Navigator.restorablePushNamedAndRemoveUntil(
                                  context, '/home', (route) => false);
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
                        'Login',
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
                      Text('Dont have an account?'),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            'Signup',
                            style: TextStyle(
                                color: const Color.fromARGB(220, 7, 55, 139)),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 60,
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              String result =
                                  await AuthService().SignInWithGoogle();
                              if (result == 'login successful') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Login successful')));
                                Navigator.restorablePushNamedAndRemoveUntil(
                                    context, '/home', (route) => false);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    result,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  '${e}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Login with Google',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                'assets/google-removebg-preview.png',
                                height: 40,
                              )
                            ],
                          )),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
