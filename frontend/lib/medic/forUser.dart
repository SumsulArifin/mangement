// ignore_for_file: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:hospitalplanner/navigation/Connection.dart';
import 'package:hospitalplanner/navigation/User.dart';
import 'package:hospitalplanner/navigation/navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../navigation/Consultation.dart';

void main() {
  runApp(const MedicForUser());
}

class MedicForUser extends StatelessWidget {
  const MedicForUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const _MedicForUser(),
      theme: ThemeData.dark(),
    );
  }
}

class _MedicForUser extends StatefulWidget {
  const _MedicForUser({Key? key}) : super(key: key);

  @override
  State<_MedicForUser> createState() => _MedicForUserState();
}

class _MedicForUserState extends State<_MedicForUser> {
  TextEditingController data = TextEditingController();
  TextEditingController userMedic = TextEditingController();
  final ScrollController controller = ScrollController();
  final List<Consultation> consultations = [];

  @override
  void initState() {
    super.initState();
    takeInformations();
  }

  Future<void> takeInformations() async {
    try {
      var response = await http
          .get(Uri.parse("http://192.168.10.135:8080/api/consultation/get-consultations-user?user_id=${myUser.getId()}"));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final consultationNo = responseData['consultations'] as List;
        for (int i = 0; i < consultationNo.length; ++i) {
          final consult = consultationNo[i] as Map<String, dynamic>;
          final status = consult['status'].toString();
          final data = consult['consultation_date'].toString();
          final id = consult['consultationId'];
          final userId = consult['userId'];
          final doctorId = consult['doctorId'];
          Consultation consultation = Consultation(id, userId, doctorId, data, status);
          setState(() {
            consultations.add(consultation);
          });
        }
      }
      // ignore: empty_catches
    } catch (e) {}
  }

  void dateTimePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        DateTime selectedDate = dateTime;
        String myDate = DateFormat('dd-MMM-yyyy - HH:mm').format(selectedDate);
        setState(() {
          data.text = myDate;
        });
      },
    );
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
              TextField(
                controller: data,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  labelText: "Enter Date",
                ),
                readOnly: true,
                onTap: () {
                  dateTimePicker(context);
                },
              ),
              TextField(
                controller: userMedic,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: "Enter Doctor Email",
                ),
              ),
              TextButton(
                onPressed: () {
                  String myData = data.text;
                  String myDoctor = userMedic.text;
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
                                  "You will make an appointment with doctor $myDoctor on date $myData. Are you sure about this?"),
                              const SizedBox(height: 15),
                              Row(
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        var response = await http.post(Uri.parse(
                                            "http://192.168.10.135:8080/api/consultation/create-consultation?user_id=${myUser.getId()}&consultationDate=$myData&doctorEmail=$myDoctor"));
                                        if (response.statusCode == 200) {
                                          final responseData = json.decode(response.body);
                                          final id = responseData['consultation_id'];
                                          final userId = responseData['user_id'];
                                          final status = responseData['status'].toString();
                                          final doctorId = responseData['doctorId'];
                                          Consultation consult = Consultation(id, userId, doctorId, myData, status);
                                          setState(() {
                                            consultations.add(consult);
                                          });
                                        } else {
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
                                        // ignore: empty_catches
                                      } catch (e) {}
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
                    data.clear();
                    userMedic.clear();
                  });
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
                  height: 300,
                  child: ListView.builder(
                    controller: controller,
                    itemCount: consultations.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Consultation currentConsult = consultations.elementAt(index);
                      final String dataConsult = currentConsult.getData();
                      final String status = currentConsult.getStatus();
                      final int doctor = currentConsult.getDoctorId();
                      final id = currentConsult.getId();
                      if (status == 'Pending') {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Consultation#$id ($dataConsult): DOCTOR#$doctor STATUS#$status",
                            style: const TextStyle(
                              color: Colors.yellow,
                            ),
                          ),
                        );
                      } else if (status == 'Reject') {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Consultation#${currentConsult.getId()} ($dataConsult): DOCTOR#$doctor STATUS#$status",
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        );
                      } else if (status == 'Done') {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Consultation#${currentConsult.getId()} ($dataConsult): DOCTOR#$doctor STATUS#$status",
                            style: const TextStyle(
                              color: Colors.green,
                            ),
                          ),
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
