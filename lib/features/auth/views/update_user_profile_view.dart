import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';
import '../controllers/auth_controller.dart';

class UpdateUserProfileView extends ConsumerStatefulWidget {
  const UpdateUserProfileView({
    super.key,
  });

  @override
  ConsumerState<UpdateUserProfileView> createState() =>
      _UpdateUserProfileViewState();
}

class _UpdateUserProfileViewState extends ConsumerState<UpdateUserProfileView> {
  final _formKey = GlobalKey<FormState>();
  File? _userImage;
  String _userName = '';

  void _pickImage() async {
    final pickedImage = await pickImage();
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _userImage = pickedImage;
    });
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (_userImage == null) {
      showSnackbar(context, 'Must add an image');
      return;
    }
    if (!isValid) {
      return;
    }
    if (_userName == '') {
      return;
    }
    // -------------------------------------------------------------------------
    _formKey.currentState!.save();
    // -------------------------------------------------------------------------
    ref.read(authControllerProvider.notifier).updateCurrentUserProfile(
          context: context,
          userName: _userName,
          imagePath: _userImage!.path,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            _userImage != null ? FileImage(_userImage!) : null,
                        child: _userImage == null
                            ? const Icon(
                                Icons.person,
                                size: 80,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 25,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _userName = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name cannot be empty';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(),
                      labelText: 'Enter Your Name',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size.fromHeight(45),
                    ),
                    onPressed: _submit,
                    child: const Text(
                      'Update',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
