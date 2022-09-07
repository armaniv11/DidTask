import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:did/appConstants.dart';
import 'package:did/bottomsheets/addTaskBottomsheet.dart';
import 'package:did/custom_functions/custom_timestamp.dart';
import 'package:did/models/channel_model.dart';
import 'package:did/models/task_model.dart';
import 'package:did/models/user_model.dart';
import 'package:did/screens/apis/firebaseapi.dart';
import 'package:did/screens/auth/register_page.dart';
import 'package:did/screens/auth/register_page_phone.dart';
import 'package:did/screens/notes/completed_task_user.dart';
import 'package:did/screens/notes/in_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bottomsheets/addChannelBottomsheet.dart';
import '../bottomsheets/addMemberBottomsheet.dart';

class HomePage extends StatefulWidget {
  final ChannelModel channel;
  const HomePage({Key? key, required this.channel}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = GetStorage();
  bool isLoading = true;
  bool isAdmin = false;
  bool initialAdmin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSettings();
    getToken();
  }

  Future<void> getToken() async {
    if (!kIsWeb) {
      await FirebaseMessaging.instance.getToken().then((token) {
        print(token);
        FirebaseFirestore.instance
            .collection('Users')
            .doc(box.read('mob'))
            .update({'fcmToken': token});
      });
    }
  }

  List<UserModel> allUsers = [];

  Future<void> loadSettings() async {
    final allUsers = await FirebaseApi.getusersFromChannel(widget.channel);
    isAdmin = box.read('mob') == widget.channel.adminId ? true : false;
    setState(() {
      initialAdmin = isAdmin;
    });
    box.write('isAdmin', isAdmin);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: AppConstants.appBackGroundColor,
          appBar: AppBar(
            elevation: 0,
            leading: initialAdmin
                ? Switch(
                    activeColor: Colors.yellow,
                    value: isAdmin,
                    onChanged: (val) {
                      setState(() {
                        isAdmin = !isAdmin;
                        print("is admin $isAdmin");
                        GetStorage().write('isAdmin', isAdmin);
                      });
                    })
                : SizedBox(),
            backgroundColor: AppConstants.appBackGroundColor,
            title: const Text("DID TASK"),
            centerTitle: true,
            actions: [
              isAdmin
                  ? IconButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await FirebaseApi()
                            .deleteDoc("Channels", widget.channel.channelId)
                            .then((value) async {
                          print("Value us $value");
                          if (value) {
                            for (var element in allUsers) {
                              print("printing mob for deleting ${element.mob}");
                              print(widget.channel.channelId);
                              Future.wait([
                                FirebaseApi().deleteSubDoc("Users", element.mob,
                                    'Channels', widget.channel.channelId),
                              ]);
                            }
                          }
                          Navigator.of(context).pop();
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                  : SizedBox(),
              IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPagePhone()));
                    });
                  },
                  icon: const Icon(Icons.power_settings_new))
            ],
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(FontAwesomeIcons.clock), text: "In Progress"),
                Tab(icon: Icon(Icons.done), text: "Completed"),
                // Tab(icon: Icon(FontAwesomeIcons.pooStorm), text: "Post Due"),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: Colors.black,
            foregroundColor: AppConstants.appSecondaryColor,
            overlayColor: Colors.black,
            overlayOpacity: 0.7,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.add),
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      // isDismissible: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return AddTaskBottomSheet(
                          channel: widget.channel,
                          allUsers: allUsers,
                        );
                      },
                    );
                  },
                  backgroundColor: Colors.white,
                  label: "Add Task"),
              SpeedDialChild(
                  onTap: () async {
                    if (!isAdmin) {
                      Fluttertoast.showToast(
                          msg: "Only admin can add members!!");
                      return;
                    }
                    if (await Permission.contacts.request().isGranted) {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        // isDismissible: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return AddMemberBottomsheet(
                            channelModel: widget.channel,
                          );
                        },
                      ).then((value) {
                        if (value != null) allUsers.add(value);
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              "Contanct permission is required for functioning of this App!!");
                    }
                  },
                  child: Icon(Icons.person),
                  backgroundColor: Colors.white,
                  label: "Add Member")
            ],
          ),
          body: TabBarView(
            children: [
              InProgressUser(
                channel: widget.channel,
                allUsers: allUsers,
              ),
              CompletedTaskUser(
                channel: widget.channel,
              ),
              // InProgressUser(),
            ],
          )),
    );
  }
}

class ChannelTile extends StatelessWidget {
  final ChannelModel channelModel;
  const ChannelTile({Key? key, required this.channelModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        tileColor: AppConstants.appSecondaryColor,
        title: Text(channelModel.channelName),
        leading: CircleAvatar(
          backgroundColor: Colors.black,
        ),
        trailing: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            channel: channelModel,
                          )));
            },
            icon: Icon(Icons.arrow_forward_ios)),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final int index;
  final VoidCallback onMarkDone;
  final String? markDoneText;
  final VoidCallback deleteClicked;
  final VoidCallback? taskEditCallback;
  const TaskTile(
      {Key? key,
      required this.task,
      required this.index,
      required this.onMarkDone,
      this.taskEditCallback,
      this.markDoneText = 'Mark as Done',
      required this.deleteClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
//     final Timestamp timestamp = task.completionDate;
// final DateTime date = timestamp.toDate();
// final int millis = timestamp.toMillis()
    return Container(
      padding: EdgeInsets.all(8),
      width: double.maxFinite,
      color: AppConstants.appSecondaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  "${index + 1}.",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                CustomFunctions().formatTimestamp(task.completionDate),
                style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              const Spacer(),
              InkWell(
                onTap: taskEditCallback,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
              InkWell(
                onTap: onMarkDone,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green[300],
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    child: markDoneText == 'Mark as Done'
                        ? Icon(Icons.done)
                        : Icon(Icons.undo)),
              ),
              task.assignBy == task.assignTo || GetStorage().read('isAdmin')
                  ? InkWell(
                      onTap: deleteClicked,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          const Divider(
            color: Colors.white,
            thickness: 2,
          ),
          Text(
            task.task,
            style: GoogleFonts.poppins(
                color: Colors.blue[900],
                textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
          ),
          const Divider(
            color: Colors.white,
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Assignee: ",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    textStyle: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600)),
              ),
              Text(
                task.assignBy,
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    textStyle: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                  height: 20,
                  child: VerticalDivider(
                    color: Colors.grey,
                  )),
              task.assignToName != null
                  ? Text(
                      " To: ",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          textStyle: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w600)),
                    )
                  : SizedBox(),
              Text(
                task.assignToName ?? "",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    textStyle: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
