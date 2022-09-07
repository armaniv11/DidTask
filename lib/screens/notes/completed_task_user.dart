import 'package:did/custom_functions/custom_timestamp.dart';
import 'package:did/models/channel_model.dart';
import 'package:did/models/task_model.dart';
import 'package:did/screens/apis/firebaseapi.dart';
import 'package:did/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_storage/get_storage.dart';

class CompletedTaskUser extends StatefulWidget {
  final ChannelModel channel;
  const CompletedTaskUser({Key? key, required this.channel}) : super(key: key);

  @override
  State<CompletedTaskUser> createState() => _CompletedTaskUserState();
}

class _CompletedTaskUserState extends State<CompletedTaskUser> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
        stream: GetStorage().read('isAdmin') ?? false
            ? FirebaseApi.getTasksAdmin(widget.channel, 'done')
            : FirebaseApi.getTasks(widget.channel, 'done'),
        builder:
            (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return ListView.builder(
                  // separatorBuilder: (context, index) =>
                  //     const Divider(color: Colors.black),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return TaskTile(
                      markDoneText: "Mark as UnDone",
                      task: snapshot.data![index],
                      index: index,
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
}
