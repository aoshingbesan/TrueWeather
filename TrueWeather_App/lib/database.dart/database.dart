import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUser(String userId, Map<String, dynamic> userInfoMap){

    return FirebaseFirestore. instance.collection("User").doc(userId).set(userInfoMap);
  }
}

class DataGeoMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("location")
        .doc()
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getthisUserInfo(String location) async {
    return await FirebaseFirestore.instance
        .collection("location")
        .where("Location", isEqualTo: location)
        .get();
  }

  Future UpdateUserData(String timezone, String id) async {
    return await FirebaseFirestore.instance
        .collection("location")
        .doc(id)
        .update({"Time Zone": timezone});
  }

  Future DeleteUserData(String id) async {
    return await FirebaseFirestore.instance
        .collection("location")
        .doc(id)
        .delete();
  }
}

class DataFeedMethods {
  Future addFeedDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("feedback")
        .doc()
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getthisUserInfo(String email) async {
    return await FirebaseFirestore.instance
        .collection("feedback")
        .where("Email", isEqualTo: email)
        .get();
  }

  Future UpdateFeedData(String bugtype, String id) async {
    return await FirebaseFirestore.instance
        .collection("feedback")
        .doc(id)
        .update({"Bug Type": bugtype});
  }

Future DeleteFeedData(String id) async {
    return await FirebaseFirestore.instance
        .collection("feedback")
        .doc(id)
        .delete();
  }
}