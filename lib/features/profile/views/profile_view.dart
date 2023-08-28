import 'dart:io';

import 'package:biskychat_aug23/core/utils.dart';
import 'package:biskychat_aug23/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final _key = GlobalKey<FormState>();
  File? _userImage;
  String _userName = '';
  String _userImageUrl = '';

  void _pickImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        _userImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(profileControllerProvider);
    if (userData != null) {
      setState(() {
        _userName = userData.name;
        _userImageUrl = userData.imageUrl;
      });
    }
    return Scaffold(
      body: Form(
        key: _key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    backgroundImage: _userImage == null
                        ? NetworkImage(_userImageUrl) as ImageProvider
                        : FileImage(_userImage!),
                    child: Center(
                      child: _userImageUrl == ''
                          ? const Icon(
                              Icons.person,
                              size: 80,
                            )
                          : null,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 20,
                      child: IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _userName,
                onChanged: (value) {
                  setState(() {
                    _userName = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                if (_userName.isEmpty || _userImage == null) {
                  showSnackbar(
                      context, 'Must upload a new image and name to continue');
                  return;
                }
                ref.read(profileControllerProvider.notifier).updateUserProfile(
                      context,
                      UserModel(
                        id: userData!.id,
                        name: _userName,
                        phone: userData.id.substring(1),
                        imageUrl: _userImage!.path,
                      ),
                    );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
