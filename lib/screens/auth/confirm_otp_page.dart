import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:did/screens/channel_homepage.dart';
import 'package:did/screens/users/add_update_users.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class ConfirmOtpPage extends StatefulWidget {
  final String? phoneNo;
  ConfirmOtpPage({required this.phoneNo});
  @override
  _ConfirmOtpPageState createState() => _ConfirmOtpPageState();
}

class _ConfirmOtpPageState extends State<ConfirmOtpPage> {
  Color accentPurpleColor = const Color(0xFF6A53A1);
  Color deepOrange = Colors.deepOrange;
  Color primaryColor = const Color(0xFF121212);
  Color accentPinkColor = const Color(0xFFF99BBD);
  Color accentDarkGreenColor = Colors.grey;
  Color accentYellowColor = const Color(0xFFFFB612);
  Color accentOrangeColor = const Color(0xFFEA7A3B);
  late List<TextStyle> otpTextStyles;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();
  late String verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String smscode = "";
  bool isLoading = false;

  int resendClicked = 0;

  TextStyle createStyle(Color color) {
    ThemeData theme = Theme.of(context);
    return theme.textTheme.headline3!.copyWith(color: color);
  }

  Future<void> verifyPhone(phoneNo) async {
    setState(() {
      isLoading = true;
      _counter = 30;
    });

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (phoneAuthCredential) async {
          setState(() {
            isLoading = false;
          });
        },
        verificationFailed: (verificationFailed) {
          setState(() {
            isLoading = false;
          });
          if (kDebugMode) {
            print("failed");
          }
        },
        codeSent: (verificationId, resendingToken) async {
          setState(() {
            isLoading = false;
            this.verificationId = verificationId;
            print(verificationId);
          });
        },
        codeAutoRetrievalTimeout: (verificationId) async {});
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      isLoading = true;
    });

    await _auth.signInWithCredential(phoneAuthCredential).then((value) async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User user = _auth.currentUser!;
      GetStorage().write('isloggedIn', true);
      print("${GetStorage().read('isloggedIn')} this is the confirm page");
      GetStorage().write('userid', user.uid);
      GetStorage().write('mob', widget.phoneNo);
      await checkAccountExists(user.uid);
    });

    setState(() {
      isLoading = false;
    });
  }

  checkAccountExists(mob) async {
    FirebaseFirestore.instance.collection('Users').doc(mob).get().then((value) {
      if (value.exists) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ChannelHomePage()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AddUpdateUser()));
      }
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  String? phone;
  @override
  void initState() {
    verifyPhone('+91${widget.phoneNo}');
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  int _counter = 30;
  late Timer _timer;

  void _startTimer() {
    _counter = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _counter--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    otpTextStyles = [
      createStyle(deepOrange),
      createStyle(accentYellowColor),
      createStyle(accentDarkGreenColor),
      createStyle(accentOrangeColor),
      createStyle(accentPinkColor),
      createStyle(deepOrange),
    ];
    Widget title = const Center(
      child: Text(
        'Confirm your OTP',
        style: TextStyle(
          color: Colors.black,
          fontSize: 26.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ],
        ),
      ),
    );

    Widget subTitle = Text(
      'Enter the Verification Code we just sent you on your Phone',
      style: TextStyle(
        color: Colors.grey[900]!,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        shadows: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            offset: Offset(0, 5),
            blurRadius: 10.0,
          )
        ],
      ),
      textAlign: TextAlign.center,
    );

    // Widget subTitle = Padding(
    //     padding: const EdgeInsets.only(right: 56.0),
    //     child: Text(
    //       'Please wait, we are confirming your OTP',
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontSize: 16.0,
    //       ),
    //     ));

    Widget verifyButton = Center(
      child: InkWell(
        onTap: () {
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smscode);
          signInWithPhoneAuthCredential(phoneAuthCredential);
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (_) => IntstartroPage()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 1.4,
          height: 60,
          child: const Center(
            child: Text(
              "Verify and Proceed",
              style: TextStyle(
                  color: Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0),
            ),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.orange[600]!,
                    Colors.orange[900]!,
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget resendText = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Resend again after ",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.blue[900]!,
            fontSize: 14.0,
          ),
        ),
        InkWell(
          onTap: () {
            verifyPhone('+91${widget.phoneNo}');
          },
          child: Text(
            _counter > 60 ? "Resend" : '$_counter',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Confirm OTP',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
              shadows: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.15),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
            ),
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.blue[900],
              ))
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Lottie.asset('assets/lotties/otp.json',
                              height: size.height * 0.4,
                              width: size.width * 0.7),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: subTitle,
                        ),
                        OtpTextField(
                          numberOfFields: 6,
                          borderColor: accentPurpleColor,
                          focusedBorderColor: accentPurpleColor,
                          styles: otpTextStyles,
                          showFieldAsBox: false,
                          borderWidth: 4.0,
                          //runs when a code is typed in
                          onCodeChanged: (String code) {},
                          //runs when every textfield is filled
                          onSubmit: (String verificationCode) {
                            smscode = verificationCode;
                            print("smscode is : $smscode");
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: verifyButton,
                        ),
                        resendText
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void signInAnonymously() async {
    setState(() {
      isLoading = true;
    });
    _auth.signInAnonymously().then((result) async {
      // setState(() {
      final User? user = result.user;
      // });
      GetStorage().write('isloggedIn', true);
      print("${GetStorage().read('isloggedIn')} this is the confirm page");

      GetStorage().write('userid', user!.uid);
      GetStorage().write('mob', widget.phoneNo);
      await checkAccountExists(user.uid);
      setState(() {
        isLoading = true;
      });
    });
  }
}
