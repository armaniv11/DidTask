import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:did/screens/channel_homepage.dart';
import 'package:did/screens/homepage.dart';
import 'package:did/screens/users/add_update_users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get_storage/get_storage.dart';

class ConfirmOtpPage extends StatefulWidget {
  final String? phoneNo;
  ConfirmOtpPage({required this.phoneNo});
  @override
  _ConfirmOtpPageState createState() => _ConfirmOtpPageState();
}

class _ConfirmOtpPageState extends State<ConfirmOtpPage> {
  // TextEditingController otp1 = TextEditingController(text: '1');
  // TextEditingController otp2 = TextEditingController(text: '2');
  // TextEditingController otp3 = TextEditingController(text: '3');
  // TextEditingController otp4 = TextEditingController(text: '4');
  // TextEditingController otp5 = TextEditingController(text: '5');
  Color accentPurpleColor = const Color(0xFF6A53A1);
  Color primaryColor = Color(0xFF121212);
  Color accentPinkColor = Color(0xFFF99BBD);
  Color accentDarkGreenColor = Colors.white;
  Color accentYellowColor = Color(0xFFFFB612);
  Color accentOrangeColor = Color(0xFFEA7A3B);
  late List<TextStyle> otpTextStyles;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String verificationId;
  FirebaseAuth _auth = FirebaseAuth.instance;

  String smscode = "";
  bool isLoading = false;

  TextStyle createStyle(Color color) {
    ThemeData theme = Theme.of(context);
    return theme.textTheme.headline3!.copyWith(color: color);
  }

  Future<void> verifyPhone(phoneNo) async {
    setState(() {
      isLoading = true;
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
          print("failed");
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

  // DatabaseService databaseService = DatabaseService();

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      isLoading = true;
    });
    print(widget.phoneNo);

    final dynamic authCredential = await _auth
        .signInWithCredential(phoneAuthCredential)
        .then((value) async {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User user = _auth.currentUser!;
      print(user.uid);
      print("checking");
      GetStorage().write('isloggedIn', true);
      GetStorage().write('userid', user.uid);
      GetStorage().write('mob', widget.phoneNo);
      await checkAccountExists(widget.phoneNo);

      // await databaseService.createProfile(widget.phoneNo).then((value) {
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => AddCompany(
      //               mob: widget.phoneNo,
      //             )));
      // });

      // HelperFunctions.saveUserLoggedInStatus(
      //     isLoggedIn: true, userid: user.uid);
    });

    setState(() {
      isLoading = false;
    });
    print("verifying");
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
    });
  }

  String? phone;
  @override
  void initState() {
    verifyPhone('+91${widget.phoneNo}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    otpTextStyles = [
      createStyle(accentPurpleColor),
      createStyle(accentYellowColor),
      createStyle(accentDarkGreenColor),
      createStyle(accentOrangeColor),
      createStyle(accentPinkColor),
      createStyle(Colors.cyan),
    ];
    Widget title = const Center(
      child: Text(
        'Confirm your OTP',
        style: TextStyle(
          color: Colors.white,
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
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 60,
          child: const Center(
            child: Text(
              "Verify",
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
                    Colors.orange,
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
      children: <Widget>[
        const Text(
          "Resend again after ",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color.fromRGBO(255, 255, 255, 0.5),
            fontSize: 14.0,
          ),
        ),
        InkWell(
          onTap: () {},
          child: const Text(
            '0:39',
            style: TextStyle(
              color: Colors.white,
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
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 0.0,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ))
            : Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Spacer(flex: 3),
                        title,
                        const Spacer(),
                        // subTitle,
                        const Spacer(flex: 1),

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
                        const Spacer(flex: 1),
//                      otpCode,
                        Padding(
                          padding: const EdgeInsets.only(right: 28.0),
                          child: verifyButton,
                        ),
                        const Spacer(flex: 2),
                        resendText,
                        const Spacer()
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
