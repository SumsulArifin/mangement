import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hospitalplanner/navigation/navigation_bar.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Admin());
}

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _Admin(),
      theme: ThemeData.dark(),
    );
  }
}

class _Admin extends StatefulWidget {
  const _Admin({Key? key}) : super(key: key);

  @override
  State<_Admin> createState() => _AdminState();
}

class _AdminState extends State<_Admin> {
  TextEditingController user = TextEditingController();
  final ScrollController controller = ScrollController();
  final List<String> newMedic = [];

  @override
  void initState(){
    super.initState();
    takeInformations();
  }

  Future<void> takeInformations() async{
    try {
      var response = await http.get(
          Uri.parse("http://192.168.10.135:8080/api/admin/get-doctor-list"));
      if (response.statusCode == 200) {
        setState(() {
          final responseData = json.decode(response.body);
          final doctorsNo = responseData['doctors'] as List;
          for (int i = 0; i < doctorsNo.length; ++i) {
            final doctor = doctorsNo[i] as Map<String, dynamic>;
            final doctorEmail = doctor['email'].toString();
            setState(() {
              newMedic.add(doctorEmail);
            });
          }
        });
      }
    // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              TextField(
                controller: user,
                decoration: const InputDecoration(
                  hintText: 'Enter user email',
                ),
              ),
              TextButton(
                onPressed: (){
                  String myuser = user.text;

                  if(myuser == ''){
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
                                Text("User $myuser will become a medic. Are you sure about this?"),
                                const SizedBox(height: 15),
                                Row(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () async{
                                        try {
                                          var response = await http.post(
                                              Uri.parse("http://192.168.10.135:8080/api/admin/add-medic?email=$myuser"));
                                          if(response.statusCode == 200){
                                            setState(() {
                                              newMedic.add(myuser);
                                            });
                                          }
                                          else{
                                            // ignore: use_build_context_synchronously
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
                                                        const Text("Doctor Email Invalid!"),
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
                                        }catch(e){
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
                                                      const Text("User Email invalid!"),
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
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'YES',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'NO',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                    setState(() {
                      user.clear();
                    });
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 500,
                  child: ListView.builder(
                    controller: controller,
                    itemCount: newMedic.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (newMedic.isNotEmpty) {
                        final String currentMedic = newMedic.elementAt(index);
                        return Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
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
                                            Text(
                                                "Medic $currentMedic will become a normal user. Are you sure about this?"),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: <Widget>[
                                                TextButton(
                                                  onPressed: () async{
                                                    try {
                                                      var response = await http.post(
                                                          Uri.parse("http://192.168.10.135:8080/api/admin/remove-medic?email=$currentMedic"));
                                                      if(response.statusCode == 200){
                                                        setState(() {
                                                          newMedic.removeAt(index);
                                                        });
                                                      }
                                                    }catch(e){
                                                      if (kDebugMode) {
                                                        print('Error: $e');
                                                      }
                                                    }
                                                    // ignore: use_build_context_synchronously
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'YES',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'NO',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Text(
                              "Medic#$index:  $currentMedic",
                            ),
                          ],
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
