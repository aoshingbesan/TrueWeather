import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final _firestore = FirebaseFirestore.instance;
  final userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load user data when the screen is first loaded
    loadUserData();
  }

  void loadUserData() async {
    final userData = await userRef.get();
    if (userData.exists) {
      final data = userData.data() as Map<String, dynamic>;
      firstNameController.text = data['firstName'] ?? '';
      lastNameController.text = data['lastName'] ?? '';
      locationController.text = data['location'] ?? '';
    }
  }

  void uploadUserData() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String location = locationController.text;

    Map<String, dynamic> userData = {
      "firstName": firstName,
      "lastName": lastName,
      "location": location,
    };

    await userRef.set(userData, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('User data updated.'),
    ));
  }

  void deleteUserData() async {
    await userRef.delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('User data deleted.'),
    ));

    // Clear the text fields
    firstNameController.text = '';
    lastNameController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E213A),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                uploadUserData();
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteUserData();
              },
              child: const Text('Delete'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/third');
              },
              child: const Text('Checkout The Weather'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 0) {
              // Navigate to home screen
              Navigator.pushNamed(context, '/home');
            } else if (_currentIndex == 1) {
              // Log out
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/login');
            }
          });
        },
      ),
    );
  }
}
