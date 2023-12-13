// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hospitalplanner/navigation/Connection.dart';
import 'package:hospitalplanner/navigation/Consultation.dart';
import 'package:hospitalplanner/navigation/User.dart';
import 'package:hospitalplanner/navigation/navigation_bar.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MedicForMe());
}

class MedicForMe extends StatelessWidget {
  const MedicForMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _MedicForMe(),
      theme: ThemeData.dark(),
    );
  }
}

class _MedicForMe extends StatefulWidget {
  const _MedicForMe({Key? key}) : super(key: key);

  @override
  State<_MedicForMe> createState() => _MedicForMeState();
}

class _MedicForMeState extends State<_MedicForMe> {
  final ScrollController controller = ScrollController();
  final List<Consultation> consultations = [];

  @override
  void initState() {
    super.initState();
    takeConsultation();
  }

  Future<void> takeConsultation() async {
    try {
      var response = await http.get(
          Uri.parse("http://192.168.10.135:8080/api/consultation/get-consultations-doctor?doctor_id=${myUser.getId()}"));
      if (kDebugMode) {
        print("http://192.168.10.135:8080/api/consultation/get-consultations-doctor?doctor_id=${myUser.getId()}");
      }
      if (response.statusCode == 200) {
        setState(() {
          final responseData = json.decode(response.body);
          final consultationNo = responseData['consultations'] as List;
          for (int i = 0; i < consultationNo.length; ++i) {
            final consult = consultationNo[i] as Map<String, dynamic>;
            final status = consult['status'].toString();
            final data = consult['consultation_date'].toString();
            final id = consult['consultationId'];
            final userId = consult['userId'];
            final doctorId = consult['doctorId'];
            if(status == 'Pending') {
              setState(() {
                Consultation consultation = Consultation(id, userId, doctorId, data, status);
                consultations.add(consultation);
              });
            }
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
            children: <Widget>[
              const Center(
                child: Text(
                  "Consultation Panel",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 500,
                  child: ListView.builder(
                      controller: controller,
                      itemCount: consultations.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Consultation currentConsult = consultations.elementAt(index);
                        final String dataConsult = currentConsult.getData();
                        final int userId = currentConsult.getUserId();
                        final int id = currentConsult.getId();
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Consultation#$id ($dataConsult): USER#$userId",
                                style: const TextStyle(
                                  fontSize: 10,
                                ),
                              ),
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
                                                    const Text(
                                                        "This consultation will be cancelled. Are you sure about this?"),
                                                    const SizedBox(height: 15),
                                                    Row(
                                                      children: <Widget>[
                                                        TextButton(
                                                          onPressed: () async {
                                                            try {
                                                              var response = await http.put(
                                                                  Uri.parse("http://192.168.10.135:8080/api/consultation/change-status?consultation_id=$id&status=Reject"));
                                                              if(response.statusCode == 200){
                                                                setState(() {
                                                                    consultations.removeAt(index);
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
                                                                            const Text("Invalid Consultations!"),
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
                                                                          const Text("Error!"),
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
                                          ));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.check),
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
                                                    const Text(
                                                        "The patient will have to be prepared for the consultation. Are you sure about this?"),
                                                    const SizedBox(height: 15),
                                                    Row(
                                                      children: <Widget>[
                                                        TextButton(
                                                          onPressed: () async {
                                                            try {
                                                              var response = await http.put(
                                                                  Uri.parse("http://192.168.10.135:8080/api/consultation/change-status?consultation_id=$id&status=Done"));
                                                              if(response.statusCode == 200){
                                                                setState(() {
                                                                  consultations.removeAt(index);
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
                                                                            const Text("Invalid Consultations!"),
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
                                                                          const Text("Error!"),
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
                                          ));
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
