import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoporia_app/controllers/db_service.dart';
import 'package:shoporia_app/providers/user_provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    final user = Provider.of<UserProvider>(context, listen: false);
    nameController.text = user.name;
    emailController.text = user.email;
    addressController.text = user.address;
    phoneController.text = user.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update profile'),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formkey,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Name',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      value!.isEmpty ? 'Name cant be empty' : null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Email',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      value!.isEmpty ? 'Email cant be empty' : null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLines: 3,
                    controller: addressController,
                    decoration: InputDecoration(
                        labelText: 'Address',
                        hintText: 'Address',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      value!.isEmpty ? 'Address cant be empty' : null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(
                        labelText: 'Phone no.',
                        hintText: 'Phone no.',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      value!.isEmpty ? 'Phone no. cant be empty' : null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          var data = {
                            'name': nameController.text,
                            'email': emailController.text,
                            'address': addressController.text,
                            'phone': phoneController.text
                          };
                          await DbService().updateUserData(extraData: data);
                          Provider.of<UserProvider>(context, listen: false)
                              .loadUserData();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Profile Updated')));
                        }
                      },
                      child: Text(
                        'Update profile',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
