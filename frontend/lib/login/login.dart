// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hospitalplanner/register/register.dart';
import 'package:http/http.dart' as http;
import '../home/home.dart';
import '../navigation/Connection.dart';
import '../navigation/User.dart';

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _Login(),
      theme: ThemeData.dark(),
    );
  }
}

class _Login extends StatefulWidget {
  const _Login({Key? key}) : super(key: key);

  @override
  State<_Login> createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Sign In')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Email",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              TextField(
                controller: email,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              TextField(
                controller: password,
                obscureText: true,
              ),

              // Buttons
              Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        child: const Text(
                          "Do you have an account?",
                        ),
                        onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (BuildContext context) => const Register())),
                      ),
                    ),
                    TextButton(
                      // ignore: duplicate_ignore
                      onPressed: () async {
                        String myEmail = email.text;
                        String myPassword = password.text;
                        if(myEmail == '' || myPassword == ''){
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text("The fields are not filled! Please try again!"),
                                      const SizedBox(height: 15),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        else{
                          try {
                            var response = await http.post(Uri.parse("http://$localhost:8080/api/auth/login?email=$myEmail&user_password=$myPassword"));
                            if (response.statusCode == 200) {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Text("You are logged!"),
                                          const SizedBox(height: 15),
                                          TextButton(
                                            onPressed: () {
                                              final responseData = json.decode(response.body);

                                              final userPassword = responseData['user_password'].toString();
                                              final userRole = responseData['role'];
                                              final userId = responseData['user_id'];
                                              final userLastName = responseData['last_name'].toString();
                                              final userPhoneNumber = responseData['phone_number'].toString();
                                              final userFirstName = responseData['first_name'].toString();
                                              final userEmail = responseData['email'].toString();

                                              if (userRole == 0) {
                                                myUser = User("user", userPhoneNumber, userEmail, userFirstName,
                                                    userLastName, userPassword, userId);
                                              } else if (userRole == 1) {
                                                myUser = User("medic", userPhoneNumber, userEmail, userFirstName,
                                                    userLastName, userPassword, userId);
                                              } else if (userRole == 2) {
                                                myUser = User("admin", userPhoneNumber, userEmail, userFirstName,
                                                    userLastName, userPassword, userId);
                                              }
                                              Navigator.pop(context);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (BuildContext context) => const Home()));
                                            },
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Text("User doesnt exist! Please try again!"),
                                          const SizedBox(height: 15),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            if (kDebugMode) {
                              print('Error during login request: $e');
                            }
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Text("Login Error! Please try again!"),
                                        const SizedBox(height: 15),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
