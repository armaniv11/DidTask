import 'package:did/appConstants.dart';
import 'package:did/custom_classes/custom_dropdown.dart';
import 'package:did/custom_classes/custom_textfield.dart';
import 'package:did/custom_functions/custom_timestamp.dart';
import 'package:did/models/channel_model.dart';
import 'package:did/models/task_model.dart';
import 'package:did/models/user_model.dart';
import 'package:did/screens/apis/firebaseapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final TaskModel? taskModel;
  final ChannelModel channel;
  final List<UserModel> allUsers;
  const AddTaskBottomSheet(
      {Key? key, this.taskModel, required this.channel, required this.allUsers})
      : super(key: key);

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController taskController = TextEditingController();

  final List<String> membersMenu = [];

  bool isAdmin = false;

  String? _selectedMember;
  String? taskCompletionDate;
  DateTime? taskInDateTime;

  bool isLoading = true;
  final box = GetStorage();

  Map<String, dynamic> membersMap = {};
  Map<String, dynamic> tokensMap = {};
  Map<String, dynamic> mobMap = {};

  void selectMember(String selected) {
    setState(() {
      _selectedMember = selected;
      print("Selectted member $_selectedMember");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAdmin = box.read('isAdmin');

    // print(widget.taskModel!.assignTo);
    loadData();
  }

  void loadData() async {
    loadMembers().then((value) {
      if (widget.taskModel != null) {
        taskController.text = widget.taskModel!.task;
        taskCompletionDate =
            CustomFunctions().formatTimestamp(widget.taskModel!.completionDate);
        _selectedMember = mobMap[widget.taskModel!.assignTo];
      }
    });
  }

  Future loadMembers() async {
    // final allusers = widget.allUsers;
    final allusers = await FirebaseApi.getusersFromProfile();

    for (var user in allusers) {
      membersMenu.add(user.fullname);
      membersMap[user.fullname] = user.mob;
      mobMap[user.mob] = user.fullname;
      tokensMap[user.mob] = user.fcmToken;
    }
    setState(() {
      print("printing mobmap");
      print(mobMap);

      isLoading = false;
    });
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
                "Add Task",
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 20, color: Colors.grey[900]!)),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: CustomTextField(
                  fillColor: AppConstants.appBackGroundColor,
                  controller: taskController,
                  width: double.maxFinite,
                  inputType: TextInputType.text,
                  maxlines: 6,
                  isDense: false,
                  hintText: "New Task",
                  headingColor: Colors.yellow,
                  headingSize: 16,
                  validationEnabled: false,
                ),
              ),
              // Text("Assign Task To"),
              // widget.isAdmin
              //     ?
              isAdmin
                  ? CustomDropDown(
                      heading: "Assign Task To:",
                      items: membersMenu,
                      selected: _selectedMember,
                      callBack: selectMember)
                  : SizedBox(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: TextButton(
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2022, 5, 20),
                              maxTime: DateTime(2022, 11, 11),
                              onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              taskInDateTime = date;
                              taskCompletionDate = DateFormat.MMMMEEEEd()
                                  .add_jm()
                                  .format(date)
                                  .toString();
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Text(
                          'Task Completion Time',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ),
              Text(
                taskCompletionDate ?? "",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.grey[800], fontWeight: FontWeight.bold)),
              ),
              InkWell(
                onTap: saveTask,
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
                          child: Text("Assign Task",
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

  void saveTask() async {
    if (_selectedMember == null ||
        taskController.text.isEmpty ||
        taskCompletionDate == null) {
      Fluttertoast.showToast(
          msg: "Task, Assign To and Completion date are compulsory!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
      return;
    }
    // setState(() {
    //   isLoading = true;
    // });
    // DateTime asd = DateTime(taskCompletionDate).t;
    final selectedNUmber = membersMap[_selectedMember!];
    final selfProfile = UserModel.fromJson(box.read('selfProfile'));

    print(selfProfile.fullname);
    print("adddf");
    print(_selectedMember);

    // return;

    print("Selected Member is ${membersMap[_selectedMember!]}");
    print("Selected Mobmap is ${mobMap[_selectedMember!]}");
    // return;
    await FirebaseApi.upsertTask(
            TaskModel(
                task: taskController.text,
                assignTo: isAdmin ? selectedNUmber : GetStorage().read('mob'),
                assignBy: widget.taskModel != null
                    ? widget.taskModel!.assignBy
                    : selfProfile.fullname,
                assignToName: widget.taskModel != null
                    ? widget.taskModel!.assignToName
                    : _selectedMember,
                taskId: widget.taskModel != null
                    ? widget.taskModel!.taskId
                    : randomAlphaNumeric(6),
                assignTime: DateTime.now().millisecondsSinceEpoch,
                taskStatus: widget.taskModel != null
                    ? widget.taskModel!.taskStatus
                    : TaskStatus.process,
                completionDate: widget.taskModel != null
                    ? widget.taskModel!.completionDate
                    : taskInDateTime!.millisecondsSinceEpoch),
            widget.channel)
        .then((value) async {
      if (value) {
        await FirebaseApi()
            .addChannelToOtherUser(widget.channel, selectedNUmber);
        Navigator.of(context).pop();
        await CustomFunctions().sendFCM(
            title: "New Task",
            body: taskController.text.toString(),
            fcmToken: tokensMap[selectedNUmber]);

        return Fluttertoast.showToast(
            msg: "Task has been assigned successfully!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green[900],
            textColor: Colors.white,
            fontSize: 14.0);
      }
    });
    // setState(() {
    //   isLoading = false;
    // });
    // Da
  }
}
