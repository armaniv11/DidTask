import 'dart:developer';

import 'package:did/appConstants.dart';
import 'package:did/custom_classes/custom_button.dart';
import 'package:did/custom_classes/custom_textfield.dart';
import 'package:did/models/user_model.dart';
import 'package:did/screens/apis/firebaseapi.dart';
import 'package:did/screens/channel_homepage.dart';
import 'package:did/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class AddUpdateUser extends StatefulWidget {
  const AddUpdateUser({Key? key}) : super(key: key);

  @override
  State<AddUpdateUser> createState() => _AddUpdateUserState();
}

class _AddUpdateUserState extends State<AddUpdateUser> {
  final phoneController = TextEditingController();

  final whatsappController = TextEditingController();

  final nameController = TextEditingController();

  final box = GetStorage();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController.text = box.read('mob');
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: AppConstants.appBackGroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppConstants.appBackGroundColor,
          // shadowColor: Colors.yellow,
          title: Text("Profile"),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    fillColor: AppConstants.appBackGroundColor,
                    controller: phoneController,
                    width: double.maxFinite,
                    inputType: TextInputType.phone,
                    headingColor: Colors.black,
                    headingSize: 16,
                    hintText: "Mobile Number",
                    enabled: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    fillColor: AppConstants.appBackGroundColor,
                    controller: whatsappController,
                    width: double.maxFinite,
                    inputType: TextInputType.phone,
                    headingColor: Colors.black,
                    headingSize: 16,
                    hintText: "Whatsapp Number",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    fillColor: AppConstants.appBackGroundColor,
                    controller: nameController,
                    width: double.maxFinite,
                    inputType: TextInputType.name,
                    headingColor: Colors.black,
                    headingSize: 16,
                    validationEnabled: true,
                    hintText: "Full Name",
                  ),
                ),
                // Spacer(),
                InkWell(
                    onTap: saveProfile,
                    child: CustomButton(
                        bgColor: Colors.yellow[800], buttonText: "Save"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      UserModel userModel = UserModel(
          fullname: nameController.text,
          mob: phoneController.text,
          whatsapp: whatsappController.text,
          uid: const Uuid().v1());
      await FirebaseApi.upsertUser(userModel).then((value) {
        log("$value value is");
        if (value) {
          final asd = GetStorage().write('selfProfile', userModel.toJson());
          print(asd);
          print('asd');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const ChannelHomePage()));
        }
        setState(() {
          isLoading = false;
        });
      });
    }
  }
}
