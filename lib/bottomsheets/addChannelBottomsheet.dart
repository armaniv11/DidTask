import 'package:did/appConstants.dart';
import 'package:did/custom_classes/custom_dropdown.dart';
import 'package:did/custom_classes/custom_textfield.dart';
import 'package:did/custom_functions/custom_timestamp.dart';
import 'package:did/models/task_model.dart';
import 'package:did/screens/apis/firebaseapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

import '../models/channel_model.dart';

class AddChannelBottomSheet extends StatefulWidget {
  final ChannelModel? channelModel;
  const AddChannelBottomSheet({Key? key, this.channelModel}) : super(key: key);

  @override
  State<AddChannelBottomSheet> createState() => _AddChannelBottomSheetState();
}

class _AddChannelBottomSheetState extends State<AddChannelBottomSheet> {
  final TextEditingController channelController = TextEditingController();

  bool isPrivate = false;

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.taskModel!.assignTo);
    loadData();
  }

  void loadData() async {
    // loadMembers().then((value) {
    //   if (widget.taskModel != null) {
    //     taskController.text = widget.taskModel!.task;
    //     taskCompletionDate =
    //         CustomFunctions().formatTimestamp(widget.taskModel!.completionDate);
    //     _selectedMember = mobMap[widget.taskModel!.assignTo];
    //   }
    // });
  }

  Future loadMembers() async {
    // final allusers = await FirebaseApi.getusers();
    // for (var user in allusers) {
    //   membersMenu.add(user.fullname);
    //   membersMap[user.fullname] = user.mob;
    //   mobMap[user.mob] = user.fullname;
    //   tokensMap[user.mob] = user.fcmToken;
    // }
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          // height: 100,
          padding: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
              color: AppConstants.appBackGroundColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24), topLeft: Radius.circular(24))),
          child: Column(
            children: [
              Text(
                "Add Channel",
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 20, color: Colors.grey[900]!)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: CustomTextField(
                  fillColor: AppConstants.appBackGroundColor,
                  controller: channelController,
                  width: double.maxFinite,
                  inputType: TextInputType.text,
                  // maxlines: 6,
                  isDense: true,
                  hintText: "Channel Name",
                  headingColor: Colors.yellow,
                  headingSize: 16,
                  validationEnabled: true,
                ),
              ),
              InkWell(
                onTap: saveChannel,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    shadowColor: Colors.yellow,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue[900]),
                      child: Center(
                          child: Text("Create",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18))),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void saveChannel() async {
    if (channelController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Channel Name cannot be empty!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
      return;
    }
    setState(() {
      isLoading = true;
    });
    // DateTime asd = DateTime(taskCompletionDate).t;
    // final selectedNUmber = membersMap[_selectedMember!];
    await FirebaseApi()
        .upsertChannel(ChannelModel(
            channelName: channelController.text,
            isPrivate: isPrivate,
            adminId: GetStorage().read('mob'),
            channelId: widget.channelModel?.channelId ?? randomAlphaNumeric(6),
            createdAt: DateTime.now().millisecondsSinceEpoch))
        .then((value) {
      if (value) {
        Navigator.of(context).pop();
        // await CustomFunctions().sendFCM(
        //     title: "New Task",
        //     body: taskController.text.toString(),
        //     fcmToken: tokensMap[selectedNUmber]);

        return Fluttertoast.showToast(
            msg: "Channel has been created successfully!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green[900],
            textColor: Colors.white,
            fontSize: 14.0);
      }
    });

    //         assignBy: widget.taskModel != null
    //             ? widget.taskModel!.assignBy
    //             : GetStorage().read('mob'),
    //         taskId: widget.taskModel != null
    //             ? widget.taskModel!.taskId
    //             : randomAlphaNumeric(6),
    //         assignTime: DateTime.now().millisecondsSinceEpoch,
    //         taskStatus: widget.taskModel != null
    //             ? widget.taskModel!.taskStatus
    //             : TaskStatus.process,
    //         completionDate: widget.taskModel != null
    //             ? widget.taskModel!.completionDate
    //             : taskInDateTime!.millisecondsSinceEpoch))
    //     .then((value) async {
    //   if (value) {
    //     Navigator.of(context).pop();
    //     await CustomFunctions().sendFCM(
    //         title: "New Task",
    //         body: taskController.text.toString(),
    //         fcmToken: tokensMap[selectedNUmber]);

    //     return Fluttertoast.showToast(
    //         msg: "Task has been assigned successfully!!",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 3,
    //         backgroundColor: Colors.green[900],
    //         textColor: Colors.white,
    //         fontSize: 14.0);
    //   }
    // });
    // setState(() {
    //   isLoading = false;
    // });
    // Da
  }
}
