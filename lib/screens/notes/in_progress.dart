import 'package:did/custom_functions/custom_timestamp.dart';
import 'package:did/models/channel_model.dart';
import 'package:did/models/task_model.dart';
import 'package:did/models/user_model.dart';
import 'package:did/screens/apis/firebaseapi.dart';
import 'package:did/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_storage/get_storage.dart';

import '../../bottomsheets/addTaskBottomsheet.dart';

class InProgressUser extends StatefulWidget {
  final ChannelModel channel;
  final List<UserModel> allUsers;
  const InProgressUser(
      {Key? key, required this.channel, required this.allUsers})
      : super(key: key);

  @override
  State<InProgressUser> createState() => _InProgressUserState();
}

class _InProgressUserState extends State<InProgressUser> {
  @override
  Widget build(BuildContext context) {
    final bool isAdmin = GetStorage().read('isAdmin') ?? false;
    print("in the progress $isAdmin");
    return StreamBuilder<List<TaskModel>>(
        stream: isAdmin
            ? FirebaseApi.getTasksAdmin(widget.channel, 'process')
            : FirebaseApi.getTasks(widget.channel, 'process'),
        builder:
            (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey,
                        thickness: 6,
                        height: 6,
                      ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return TaskTile(
                      task: snapshot.data![index],
                      index: index,
                      taskEditCallback: () {
                        showEditSheet(isAdmin, snapshot.data![index]);
                      },
                      deleteClicked: () {
                        CustomFunctions()
                            .deletetask(widget.channel, snapshot.data![index]);
                      },
                      onMarkDone: () {
                        CustomFunctions()
                            .markDone(widget.channel, snapshot.data![index]);
                      },
                    );
                  });
            // final titre= snapshot.data![index].title ;  // for example
          }
        });
  }

  showEditSheet(bool isAdmin, TaskModel taskModel) async {
    showModalBottomSheet(
      isScrollControlled: true,
      // isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return AddTaskBottomSheet(
          taskModel: taskModel,
          channel: widget.channel,
          allUsers: widget.allUsers,
        );
      },
    );
  }
}
