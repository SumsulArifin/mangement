// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospitalplanner/login/login.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Register());
}

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _Register(),
      theme: ThemeData.dark(),
    );
  }
}

class _Register extends StatefulWidget {
  const _Register({Key? key}) : super(key: key);

  @override
  State<_Register> createState() => _RegisterState();
}


class _RegisterState extends State<_Register> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Sign Up')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "First Name",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              TextField(
                controller: firstName,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Last Name",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              TextField(
                controller: lastName,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              TextField(
                controller: email,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Phone",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              TextField(
                controller: phone,
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
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Confirm Password",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              TextField(
                controller: confirmPassword,
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
                            .push(MaterialPageRoute(builder: (BuildContext context) => const Login())),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        String myPassword = password.text;
                        String myConfirmPassword = confirmPassword.text;
                        String myFirstName = firstName.text;
                        String myLastName = lastName.text;
                        String myEmail = email.text;
                        String myPhone = phone.text;
                        if(myConfirmPassword == '' || myPhone == '' || myEmail == '' || myLastName == '' || myFirstName == '' || myPassword == ''){
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
                        else if (myPassword != myConfirmPassword) {
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
                                      const Text("Both passwords don't match! Please try again!"),
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
                        } else {
                          try {
                            // final response = await http.post(Uri.parse("http://192.168.10.135:8080/api/auth/register?first_name=$myFirstName&last_name=$myLastName&email=$myEmail&phone_number=$myPhone&user_password=$myPassword"));
                            final response = await http.post(
                              Uri.parse("http://192.168.10.135:8080/api/auth/register"),
                              body: json.encode({
                                "first_name": myFirstName,
                                "last_name": myLastName,
                                "email": myEmail,
                                "phone_number": myPhone,
                                "user_password": myPassword,
                              }),
                              headers: <String, String>{
                                'Content-Type': 'application/json; charset=UTF-8',
                              },
                            );

                            if(response.statusCode == 200){
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
                                          const Text("User has been registered successfully!"),
                                          const SizedBox(height: 15),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder: (BuildContext context) => const Login()));
                                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Login()));
                                              // Close dialog
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
                                        const Text("Register Error! Please try again!"),
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
                        "Register",
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
