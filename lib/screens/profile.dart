import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:juridoc/Profile/edit_profile.dart';
import 'package:juridoc/Profile/mon_profile.dart';
import 'package:juridoc/Profile/achats.dart';
import 'package:juridoc/Profile/collab.dart';
import 'package:juridoc/Profile/abonnements.dart';
import 'package:juridoc/module/UserPrefs.dart';
import 'package:juridoc/screens/welcome/login.dart';
import 'package:juridoc/widgets/app_Bar_ui.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String? name;
  String? surname;

  @override
  void initState() {
    super.initState();
    name = UserPrefs.getName();
    surname = UserPrefs.getSurname();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Stack(fit: StackFit.expand, children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(4, 9, 35, 1),
              Color.fromRGBO(39, 105, 171, 1),
            ],
            begin: FractionalOffset.bottomCenter,
            end: FractionalOffset.topCenter,
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "$name $surname",
                                style: TextStyle(
                                  color: Color.fromRGBO(39, 105, 171, 1),
                                  fontFamily: 'Nunito',
                                  fontSize: 32,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              profileWidget(
                                  context, 'SVG/user.svg', 'Mon profil', () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MonProfile(),
                                    ));
                                return;
                              }),
                              SizedBox(
                                height: 15,
                              ),
                              profileWidget(context, 'SVG/paper-plane.svg',
                                  'Mes abonnements', () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Abonnements()));
                                return;
                              }),
                              SizedBox(
                                height: 15,
                              ),
                              profileWidget(
                                  context, 'SVG/shopbag.svg', "Mes achats", () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Achats()));
                                return;
                              }),
                              SizedBox(
                                height: 15,
                              ),
                              profileWidget(context, 'SVG/users.svg',
                                  "Mes collaborateurs", () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Collab()));
                                return;
                              }),
                              SizedBox(
                                height: 15,
                              ),
                              profileWidget(context, 'SVG/tools.svg',
                                  'Mettre à jour profil', () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EditProfile(),
                                    ));
                                return;
                              }),
                              SizedBox(
                                height: 15,
                              ),
                              profileWidget(
                                  context, 'SVG/logout.svg', 'Se déconnecter',
                                  () {
                                showAlertDialog(context, "Déconnecter ?",
                                    () async {
                                  UserPrefs.clear().then((res) async {
                                    await FirebaseMessaging.instance
                                        .unsubscribeFromTopic('new');
                                    Navigator.pushAndRemoveUntil<void>(
                                      context,
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              LogInScreen()),
                                      ModalRoute.withName('/homescreen'),
                                    );
                                  });
                                });
                                return;
                              }),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  Widget profileWidget(
      BuildContext context, String image, String text, Function? func()) {
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: func,
      child: Container(
          height: height * 0.15,
          decoration: BoxDecoration(
            color: Color.fromRGBO(39, 105, 171, 1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SvgPicture.asset(
                  image,
                  height: 100.0,
                  width: 100.0,
                  allowDrawingOutsideViewBox: true,
                  color: Colors.white,
                ),
                SizedBox(width: 30),
                Flexible(
                  child: Wrap(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        text,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  showAlertDialog(BuildContext context, String text, Future<void> func()) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Attention"),
          content: Text(text),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            ),
            TextButton(
              child: Text("Continue"),
              onPressed: () {
                func();
                Navigator.of(context).pop();
                return;
              },
            ),
          ],
        );
      },
    );
  }
}
