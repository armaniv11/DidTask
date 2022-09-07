import 'package:contacts_service/contacts_service.dart';
import 'package:did/custom_classes/custom_dropdown.dart';
import 'package:did/custom_classes/custom_textfield.dart';
import 'package:did/custom_functions/custom_timestamp.dart';
import 'package:did/models/task_model.dart';
import 'package:did/models/user_model.dart';
import 'package:did/screens/apis/firebaseapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';

import '../models/channel_model.dart';

class AddMemberBottomsheet extends StatefulWidget {
  final ChannelModel? channelModel;
  const AddMemberBottomsheet({Key? key, this.channelModel}) : super(key: key);

  @override
  State<AddMemberBottomsheet> createState() => _AddMemberBottomsheetState();
}

class _AddMemberBottomsheetState extends State<AddMemberBottomsheet> {
  final TextEditingController searchController = TextEditingController();

  bool isPrivate = false;

  bool isLoading = true;

  bool addingMember = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.taskModel!.assignTo);
    loadContacts();
  }

  List<Contact> contacts = [];
  List<Contact> selectedContacts = [];

  Future loadContacts() async {
    setState(() {
      isLoading = true;
    });

    if (await Permission.contacts.request().isGranted) {
      contacts = await ContactsService.getContacts(withThumbnails: false);
      contacts.removeWhere((element) => element.phones!.isEmpty);
      contacts
          .removeWhere((element) => element.phones!.first.value!.length < 10);

      allContacts = contacts;

      setState(() {
        isLoading = false;
        // isLocalContactLoading = false;
      });
      for (final contact in contacts) {
        ContactsService.getAvatar(contact).then((avatar) {
          try {
            if (avatar == null) return; // Don't redraw if no change.
            setState(() => contact.avatar = avatar);
          } catch (e) {
            setState(() => contact.avatar = null);
          }
        });
      }

      // print(numbersOnly);
    } else {
      Fluttertoast.showToast(
          msg: "Contanct permission is required for functioning of this App!!");
    }
  }

  List<Contact> allContacts = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: size.height - 40,
        padding: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24), topLeft: Radius.circular(24))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                "Select Members (${selectedContacts.length})",
                style: GoogleFonts.poppins(
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 6, bottom: 4),
              child: Container(
                color: Colors.white,
                child: TextField(
                  onChanged: (val) {
                    searchContact(val);
                  },
                  controller: searchController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: "Search Here!!"),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                height: size.height * 0.65,
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    // physics: BouncingScrollPhysics(),
                    // shrinkWrap: true,
                    itemCount: contacts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        dense: true,
                        leading: contacts[index].avatar != null
                            ? contacts[index].avatar!.isEmpty
                                ? CircleAvatar(
                                    child: Text(contacts[index].initials()))
                                : CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contacts[index].avatar!))
                            : CircleAvatar(
                                child: Text(contacts[index].initials())),
                        title: Text(
                          contacts[index].displayName!,
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: Checkbox(
                            value: selectedContacts.contains(contacts[index])
                                ? true
                                : false,
                            onChanged: (val) {
                              setState(() {
                                if (selectedContacts
                                    .contains(contacts[index])) {
                                  selectedContacts.remove(contacts[index]);
                                  print("selected contacts true");
                                  selectedContacts.forEach((element) {
                                    print(element.displayName);
                                  });
                                } else {
                                  selectedContacts.add(contacts[index]);
                                  print("selected contacts false");
                                  selectedContacts.forEach((element) {
                                    print(element.displayName);
                                  });
                                }
                              });
                            }),
                      );
                    }),
              ),
            ),
            InkWell(
              onTap: addingMember ? null : addMembers,
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
                        child: addingMember
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Adding  ",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  CircularProgressIndicator()
                                ],
                              )
                            : Text("Add Members",
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
    );
  }

  void searchContact(String searchParam) async {
    contacts = await ContactsService.getContacts(
        withThumbnails: false, query: searchParam);
    contacts.removeWhere((element) => element.phones!.isEmpty);
    contacts.removeWhere((element) => element.phones!.first.value!.length < 10);

    setState(() {
      isLoading = false;
      // isLocalContactLoading = false;
    });
    for (final contact in contacts) {
      ContactsService.getAvatar(contact).then((avatar) {
        try {
          if (avatar == null) return; // Don't redraw if no change.
          setState(() => contact.avatar = avatar);
        } catch (e) {
          setState(() => contact.avatar = null);
        }
      });
    }
  }

  List<UserModel> profilesAll = [];

  void addMembers() async {
    if (selectedContacts.length == 0) {
      Fluttertoast.showToast(
          msg: "Please add members!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
      return;
    }
    selectedContacts.forEach((val) {
      print(val.displayName);
    });
    // return;
    setState(() {
      isLoading = true;
      addingMember = true;
    });
    for (int i = 0; i < selectedContacts.length; i = i + 10) {
      List<Contact> b = [];
      List<String> searchNumberstenDigits = [];

      if (i == 0) {
        b = selectedContacts.take(10).toList();
      } else {
        b = selectedContacts.skip(i).take(10).toList();
      }
      b.forEach((element) {
        if (element.phones!.first.value!.length == 13) {
          print("$element element");
          searchNumberstenDigits
              .add(element.phones!.first.value!.substring(3, 13));
        } else {
          searchNumberstenDigits.add(element.phones!.first.value!);
        }
      });
      print("searchnumber $searchNumberstenDigits");

      List<UserModel> profiles =
          await FirebaseApi().getProfiles(searchNumberstenDigits);
      profilesAll.addAll(profiles);
      // print(i);
    }
    // return;

    // DateTime asd = DateTime(taskCompletionDate).t;
    // final selectedNUmber = membersMap[_selectedMember!];
    await FirebaseApi()
        .upsertMembers(profilesAll, widget.channelModel!)
        .then((value) {
      if (value) {
        Navigator.of(context).pop(profilesAll);
        // await CustomFunctions().sendFCM(
        //     title: "New Task",
        //     body: taskController.text.toString(),
        //     fcmToken: tokensMap[selectedNUmber]);

        return Fluttertoast.showToast(
            msg: "Members has been added to channel successfully!!",
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

class CallTile extends StatelessWidget {
  final Contact contact;
  const CallTile({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("${contact.avatar} avatar");
    return ListTile(
      // backgroundColor: Colors.yellow,

      textColor: Colors.black,
      iconColor: Colors.black,

      leading: contact.avatar != null
          ? contact.avatar!.isEmpty
              ? CircleAvatar(child: Text(contact.initials()))
              : CircleAvatar(backgroundImage: MemoryImage(contact.avatar!))
          : CircleAvatar(child: Text(contact.initials())),

      title: Text(
        contact.displayName!,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
