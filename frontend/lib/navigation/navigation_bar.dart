import 'package:adaptive_navbar/adaptive_navbar.dart';
import 'package:flutter/material.dart';
import 'package:hospitalplanner/admin/admin.dart';
import 'package:hospitalplanner/medic/forMedic..dart';
import 'package:hospitalplanner/medic/forUser.dart';
import 'package:hospitalplanner/navigation/User.dart';
import '../login/login.dart';

class TopNavigationBar extends StatelessWidget implements PreferredSizeWidget{
  const TopNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveNavBar(
      iconTheme: const IconThemeData(
        size: 30,
      ),
      title: const Text(
        'Sys Dev',
      ),
      bottomOpacity: 0.8,
      screenWidth: MediaQuery.of(context).size.width,
      navBarItems: [
        if(myUser.getRole() == 'admin')
        NavBarItem(
          text: "Admin",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const Admin()));
          },
        ),
        if(myUser.getRole() == 'medic')
        NavBarItem(
          text: "User",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const MedicForMe()));
          },
        ),
        if(myUser.getRole() != 'medic')
          NavBarItem(
            text: "Medic",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const MedicForUser()));
            },
          ),

        NavBarItem(
          text: "Logout",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => const Login()));
          },
        ),
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}