import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Utiletis/reUseAble/HomePageCardWidget.dart';
import "package:get/get.dart";

class WednesdayWeekClass extends StatefulWidget {
  const WednesdayWeekClass({Key? key}) : super(key: key);

  @override
  State<WednesdayWeekClass> createState() => _WednesdayWeekClassState();
}

class _WednesdayWeekClassState extends State<WednesdayWeekClass> {
  late Future<QuerySnapshot<Map<String, dynamic>>> wednesdayData;
  final _formKey = GlobalKey<FormState>();


  String collectionName = "Wednesday";

  TextEditingController AddNameController = TextEditingController();
  TextEditingController AddRoomController = TextEditingController();
  TextEditingController AddStartTimeController = TextEditingController();
  TextEditingController AddEndTimeController = TextEditingController();


  @override
  void initState() {
    super.initState();
    wednesdayData = FirebaseFirestore.instance.collection(collectionName).orderBy("StartTime").get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Details'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 150,
            child: Lottie.asset('images/animation_lki1kf82.json', fit: BoxFit.cover,),
          ),
          const SizedBox(height: 80,),
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: wednesdayData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data == null) {
                return const Text('No data available');
              }

              final documents = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final data = documents[index].data();

                    TextEditingController nameController = TextEditingController(text: data['Name']);
                    TextEditingController roomController = TextEditingController(text: data['Room']);
                    TextEditingController startTimeController = TextEditingController(text: data['StartTime']);
                    TextEditingController endTimeController = TextEditingController(text: data['EndTime']);

                    return GestureDetector(
                      onLongPress: (){

                        Get.defaultDialog(


                          titlePadding: const EdgeInsets.all(8.0),
                          titleStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.red),
                          title: "Class Details",
                          content: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.drive_file_rename_outline),
                                    prefixIconColor: Colors.red,
                                    labelText: "Name",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),


                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Course Name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10,),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.room),
                                    prefixIconColor: Colors.red,
                                    labelText: "Room",
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: roomController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Room Number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10,),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.timer,),
                                    prefixIconColor: Colors.red,
                                    labelText: "Start Time",
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: startTimeController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Start Time';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10,),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.timelapse_outlined),
                                    prefixIconColor: Colors.red,
                                    labelText: "End Time",
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: endTimeController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter End Time';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          textConfirm: "Update",
                          textCancel: "Cancel",
                          buttonColor: Colors.redAccent,
                          confirmTextColor: Colors.white,
                          cancelTextColor: Colors.redAccent,
                          onCancel: (){
                            Get.back();
                          },
                          onConfirm: () async {
                            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                              await FirebaseFirestore.instance.collection(collectionName).doc(documents[index].id).update({
                                'Name': nameController.text,
                                'Room': roomController.text,
                                'StartTime': startTimeController.text,
                                'EndTime': endTimeController.text,
                              });

                              setState(() {
                                wednesdayData = FirebaseFirestore.instance.collection(collectionName).orderBy("StartTime").get();
                              });
                              Get.back();

                              Get.snackbar("Update", "Class Details Updated Successfully",backgroundColor: Colors.green,colorText: Colors.white,snackPosition: SnackPosition.TOP);

                            }
                          },



                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25,right: 20,left: 20),
                              child: IconButton(onPressed: (){

                                FirebaseFirestore.instance.collection(collectionName).doc(documents[index].id).delete();

                                setState(() {
                                  wednesdayData = FirebaseFirestore.instance.collection(collectionName).orderBy("StartTime").get();
                                });
                                Get.back();
                                Get.snackbar("Delete", "Class Details Deleted Successfully",backgroundColor: Colors.redAccent,colorText: Colors.white,snackPosition: SnackPosition.TOP);
                              }, icon: const Icon(Icons.delete,color: Colors.red,),),
                            ),
                          ],
                        );
                      },
                      child: HomePageCardWidget(
                        const Icon(Icons.add_box, color: Colors.red),
                        data['Name'],
                        data['Room'],
                        data['StartTime'],
                        data['EndTime'],
                      ),
                    );



                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Add New Class', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(),
                            ),
                            controller: AddNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Room No",
                              border: OutlineInputBorder(),
                            ),
                            controller: AddRoomController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Room No';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Start Time",
                              border: OutlineInputBorder(),
                            ),
                            controller: AddStartTimeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Start Time';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "End Time",
                              border: OutlineInputBorder(),
                            ),
                            controller: AddEndTimeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a End Time';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          // Add more TextFormField widgets for other inputs
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          // Replace with your Firestore logic to add the new class
                          // Example:
                          await FirebaseFirestore.instance.collection(collectionName).add({
                            'Name': AddNameController.text,
                            'Room': AddRoomController.text,
                            'StartTime': AddStartTimeController.text,
                            'EndTime': AddEndTimeController.text,
                          });
                          // Refresh the FutureBuilder data or trigger a refresh
                          // Close the modal bottom sheet
                          Get.back();

                          setState(() {
                            wednesdayData = FirebaseFirestore.instance.collection(collectionName).orderBy("StartTime").get();
                          });
                          Get.snackbar("Added", "Class Added Successfully",backgroundColor: Colors.green,colorText: Colors.white,snackPosition: SnackPosition.TOP);

                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
