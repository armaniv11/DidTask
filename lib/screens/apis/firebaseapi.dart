import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:did/models/channel_model.dart';
import 'package:did/models/task_model.dart';
import 'package:did/models/user_model.dart';
import 'package:get_storage/get_storage.dart';

class FirebaseApi {
  static FirebaseFirestore firebase = FirebaseFirestore.instance;
  static String selfMobile = GetStorage().read('mob');

  static Future<bool> upsertUser(UserModel user) async {
    try {
      return await firebase
          .collection('Users')
          .doc(user.mob)
          .set(user.toJson(), SetOptions(merge: true))
          .then((value) {
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  static Future<bool> upsertTask(TaskModel task, ChannelModel channel) async {
    try {
      return await firebase
          .collection('Channels')
          .doc(channel.channelId)
          .collection('Tasks')
          .doc(task.taskId)
          .set(task.toJson(), SetOptions(merge: true))
          .then((value) {
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> upsertChannel(ChannelModel channel) async {
    try {
      await firebase
          .collection('Channels')
          .doc(channel.channelId)
          .set(channel.toJson(), SetOptions(merge: true))
          .then((value) async {
        await addChannelToSelfUser(channel);
        return true;
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> upsertMembers(
      List<UserModel> users, ChannelModel channel) async {
    for (var element in users) {
      try {
        Future.wait([
          firebase
              .collection('Channels')
              .doc(channel.channelId)
              .collection("members")
              .doc(element.mob)
              .set(element.toJson(), SetOptions(merge: true)),
        ]);
      } catch (e) {
        print(e.toString());
        return false;
      }
    }
    return true;
  }

  Future<bool> addChannelToSelfUser(ChannelModel channel) async {
    try {
      await firebase
          .collection('Users')
          .doc(selfMobile)
          .collection("Channels")
          .doc(channel.channelId)
          .set(channel.toJson(), SetOptions(merge: true))
          .then((value) {
        return true;
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<UserModel>> getProfiles(List<String> contacts) {
    return firebase
        .collection('Users')
        .where('mob', whereIn: contacts)
        .get()
        .then((value) =>
            value.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  Future<bool> addChannelToOtherUser(
      ChannelModel channel, String mobile) async {
    try {
      await firebase
          .collection('Users')
          .doc(mobile)
          .collection("Channels")
          .doc(channel.channelId)
          .set(channel.toJson(), SetOptions(merge: true))
          .then((value) {
        return true;
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> checkAdmin() async {
    try {
      return await firebase
          .collection('Settings')
          .doc('admins')
          .get()
          .then((value) {
        final List alladmins = value.data()!['alladmins'];
        if (alladmins.contains(GetStorage().read('mob'))) {
          print("contains");
          return true;
        }
        print("notcontains");

        return false;
      });
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> taskToggle(ChannelModel channel, TaskModel task) async {
    final taskStatus =
        task.taskStatus == TaskStatus.process ? 'done' : 'process';
    print("$taskStatus Current Status task");
    try {
      return await firebase
          .collection('Channels')
          .doc(channel.channelId)
          .collection('Tasks')
          .doc(task.taskId)
          .update({'taskStatus': taskStatus}).then((value) {
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDoc(String collectionName, String id) async {
    try {
      firebase.collection(collectionName).doc(id).delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteSubDoc(String collectionName, String id,
      String subcollection, String subid) async {
    try {
      await firebase.collection(collectionName).doc(id).get().then((value) {
        if (value.exists) {
          firebase
              .collection(collectionName)
              .doc(id)
              .collection(subcollection)
              .doc(subid)
              .delete();

          return true;
        } else {
          return false;
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteSubCollection(String collectionName, String id,
      String subcollection, String subid) async {
    try {
      firebase
          .collection(collectionName)
          .doc(id)
          .collection(subcollection)
          .doc(subid)
          .delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteTask(ChannelModel channel, TaskModel task) async {
    try {
      return await firebase
          .collection('Channels')
          .doc(channel.channelId)
          .collection('Tasks')
          .doc(task.taskId)
          .delete()
          .then((value) {
        return true;
      });
      // return false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<UserModel>> getusersFromChannel(
      ChannelModel channelModel) {
    return firebase
        .collection('Channels')
        .doc(channelModel.channelId)
        .collection('members')
        .get()
        .then((value) =>
            value.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  static Future<List<UserModel>> getusersFromProfile() {
    return firebase
        .collection('Users')
        // .doc(channelModel.channelId)
        // .collection('members')
        .get()
        .then((value) =>
            value.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  static Stream<List<TaskModel>> getTasks(
      ChannelModel channel, String taskStatus) {
    return firebase
        .collection('Channels')
        .doc(channel.channelId)
        .collection('Tasks')
        // .where('receiver', isEqualTo: receiver)
        .where('assignTo', isEqualTo: GetStorage().read('mob'))
        .where('taskStatus', isEqualTo: taskStatus)
        .orderBy('completionDate', descending: true)
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) => TaskModel.fromJson(document.data()))
            .toList());
    // }
  }

  static Stream<List<TaskModel>> getTasksAdmin(
      ChannelModel channel, String taskStatus) {
    return firebase
        .collection('Channels')
        .doc(channel.channelId)
        .collection('Tasks')
        .where('taskStatus', isEqualTo: taskStatus)
        .orderBy('completionDate', descending: true)
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((document) => TaskModel.fromJson(document.data()))
            .toList());
    // }
  }

  Stream<List<ChannelModel>> getChannels() {
    return firebase
        .collection('Users')
        .doc(selfMobile)
        .collection('Channels')
        .snapshots()
        .map((value) =>
            value.docs.map((e) => ChannelModel.fromJson(e.data())).toList());
    // return await firebase
    //     .collection("Channels")
    //     // .where('channelId', whereIn: channelIds.data()['channelIds'])
    //     .get()
    //     .then((value) =>
    //         value.docs.map((e) => ChannelModel.fromJson(e.data())).toList());

    // print(channelIds.channelIds);

    //     .where(
    //       'chan',
    //       whereIn: [GetStorage().read('mob')],
    //     )
    //     .snapshots()
    //     .map((snapShot) => snapShot.docs
    //         .map((document) => ChannelModel.fromJson(document.data()))
    //         .toList());
    // asd.listen((event) {
    //   print(event.length);
    // });
    // return asd;
    // }
  }
}
