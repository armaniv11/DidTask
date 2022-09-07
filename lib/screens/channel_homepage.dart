import 'package:did/appConstants.dart';
import 'package:did/screens/auth/register_page_phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../bottomsheets/addChannelBottomsheet.dart';
import '../models/channel_model.dart';
import 'apis/firebaseapi.dart';
import 'homepage.dart';

class ChannelHomePage extends StatefulWidget {
  const ChannelHomePage({Key? key}) : super(key: key); 

  @override
  State<ChannelHomePage> createState() => _ChannelHomePageState();
}

class _ChannelHomePageState extends State<ChannelHomePage> {
  List<ChannelModel> channels = [];
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });

    // channels = await FirebaseApi().getChannels();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstants.appBackGroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/mainlogo.png',
                height: 50,
                width: 50,
              ),
              // Text("DiD Task"),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPagePhone()));
                  });
                },
                icon: const Icon(
                  Icons.power_settings_new,
                  color: AppConstants.appSecondaryColor,
                ))
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.blueGrey[800],
            elevation: 10,
            foregroundColor: Colors.green[50],
            splashColor: Colors.yellow,
            focusColor: Colors.blue,
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                // isDismissible: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return const AddChannelBottomSheet();
                },
              );
            },
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New Channel"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add),
                )
              ],
            )),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            :
            // StreamBuilder<List<ChannelModel>>(
            //               stream:
            //                   FirebaseApi().getChannels(),
            //               builder: (BuildContext context,
            //                   AsyncSnapshot<ChannelModel> snapshot) {
            //                 if (snapshot.hasError) {
            //                   return Text('Error: ${snapshot.error}');
            //                 }
            //                 // else {
            //                 //   isOnlineReceiver = snapshot.data!.isOnline;
            //                 //   fckTokenReceiver = snapshot.data!.fcmToken;
            //                 // }
            //                 switch (snapshot.connectionState) {
            //                   case ConnectionState.waiting:
            //                     return const Center(
            //                         child: CircularProgressIndicator());
            //                   default:

            //                     return ListView.separated(
            //           separatorBuilder: (context, index) =>
            //               const Divider(color: Colors.blue),
            //           itemCount: channels.length,
            //           itemBuilder: (BuildContext ctx, int index) {
            //             print("index is $index");
            //             return ChannelTile(
            //               channelModel: snapshot.data,

            //             );
            //           });
            //                 }
            //               }),);
            StreamBuilder<List<ChannelModel>>(
                stream: FirebaseApi().getChannels(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ChannelModel>> snapshot) {
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      return ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                                color: Colors.grey,
                                thickness: 4,
                                height: 4,
                              ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            print("index is $index");
                            return ChannelTile(
                              channelModel: snapshot.data![index],
                              // task: snapshot.data![index],
                              // index: index,
                              // taskEditCallback: () {
                              //   showEditSheet(isAdmin, snapshot.data![index]);
                              // },
                              // deleteClicked: () {
                              //   CustomFunctions().deletetask(snapshot.data![index]);
                              // },
                              // onMarkDone: () {
                              //   CustomFunctions().markDone(snapshot.data![index]);
                              // },
                            );
                          });
                    // final titre= snapshot.data![index].title ;  // for example
                  }
                }));
  }

  // showEditSheet(bool isAdmin, TaskModel taskModel) async {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     // isDismissible: true,
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (context) {
  //       return AddTaskBottomSheet(
  //         isAdmin: isAdmin,
  //         taskModel: taskModel,
  //       );
  //     },
  //   );
  // }
}
