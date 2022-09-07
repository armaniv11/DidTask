import 'package:did/appConstants.dart';
import 'package:did/models/channel_model.dart';
import 'package:did/screens/auth/confirm_otp_page.dart';
import 'package:did/screens/homepage.dart';
import 'package:did/screens/users/add_update_users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterPagePhone extends StatefulWidget {
  const RegisterPagePhone({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterPagePhoneState createState() => _RegisterPagePhoneState();
}

class _RegisterPagePhoneState extends State<RegisterPagePhone> {
  TextEditingController mobController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget title = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/mainlogo.png',
          height: size.height / 4,
          width: size.width / 2,
        ),
        Center(
          child: Text('Welcome To',
              style: GoogleFonts.pacifico(color: Colors.grey, fontSize: 24)),
        ),
        Text(
          AppConstants.appName,
          style: TextStyle(
              color: Colors.grey,
              fontSize: 44.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              shadows: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ]),
        ),
      ],
    );

    Widget registerButton = InkWell(
      onTap: () async {
        if (mobController.text.length < 10) {
          // Flushbar(
          //   backgroundColor: Colors.red[900]!,
          //   title: "Note!",
          //   flushbarPosition: FlushbarPosition.TOP,
          //   message: "Mobile Number should be 10 digits!!",
          //   duration: Duration(seconds: 3),
          // )..show(context);
        } else
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ConfirmOtpPage(
                    phoneNo: mobController.text,
                  )));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: PhysicalModel(
          color: Colors.black,
          borderRadius: BorderRadius.circular(9),
          elevation: 20,
          child: Container(
            padding: EdgeInsets.all(16),
            // width: MediaQuery.of(context).size.width / 2,
            height: 60,
            child: Center(
                child: new Text("Confirm",
                    style: const TextStyle(
                        color: const Color(0xfffefefe),
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0))),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.orange[600]!,
                      Colors.orange[900]!,
                    ],
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.16),
                    offset: Offset(0, 5),
                    blurRadius: 10.0,
                  )
                ],
                borderRadius: BorderRadius.circular(9.0)),
          ),
        ),
      ),
    );

    Widget registerForm() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(
                    width: 80,
                    decoration: BoxDecoration(
                      // color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "+91",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3),
                      ),
                    )),
                Expanded(
                  child: TextField(
                    controller: mobController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                    decoration: InputDecoration(
                      // fillColor: Colors.white,
                      // filled: true,
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      hintText: 'Mobile Number',
                      // prefixIcon: Icon(Icons.phone),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(right: 20, top: 20, bottom: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      // backgroundColor: Colors.yellow,
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.s
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.1,
                ),
                title,
                SizedBox(
                  height: size.height * 0.05,
                ),
                registerForm(),
                registerButton,
                SizedBox(
                  height: size.height * 0.2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
