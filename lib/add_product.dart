import 'package:askar_task/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'firebase_constants.dart';
import 'main.dart';

class addProduct extends StatefulWidget {
  const addProduct({super.key});
  @override
  State<addProduct> createState() => _addProductState();
}

class _addProductState extends State<addProduct> {
  TextEditingController nameController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  TextEditingController discountController= TextEditingController();
  TextEditingController stockController= TextEditingController();
  final RegExp priceValidation=RegExp(r'[0-9]$');
  final RegExp discountValidation=RegExp(r'[0-9]$');
  final RegExp stocktValidation=RegExp(r'[0-9]$');
  String imgurl ='';

  var file;
  pickFile() async {
    final imagefile=await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    file=File(imagefile!.path);
    if(mounted){
      setState(() {
        file=File(imagefile!.path);
      });
    }
    // var uploadFile =await FirebaseStorage.instance.ref().child('userPic/${DateTime.now()}').putFile(file!);
    // var geturl = await uploadFile.ref.getDownloadURL();
    // imgurl= geturl;
    setState(() {

    });


  }
  productAdd()async{
    QuerySnapshot snap = await FirebaseFirestore.instance.collection(constants.product)
    .where("prdctName",isEqualTo: nameController.text.trim())
    .get();
    if(snap.docs.isEmpty){
      var uploadFile =await FirebaseStorage.instance.ref().child('userPic/${DateTime.now()}').putFile(file!);
      var geturl = await uploadFile.ref.getDownloadURL();
      imgurl= geturl;
      int id=Timestamp.now().seconds;
      DocumentReference ref =FirebaseFirestore.instance.collection(constants.product).doc("jalal$id");
      final product= ProductList(
        prdctName: nameController.text.trim(),
        price:double.tryParse(priceController.text.trim())??0 ,
        discount: double.tryParse(discountController.text.trim())??0,
        delete: false,
        image: imgurl??"",
        id: ref.id,
        date: DateTime.now(),
        reference: ref,
        stock:  double.tryParse(stockController.text.trim())??0,);
      ref.set(product.toJson());
      nameController.clear();
      priceController.clear();
      discountController.clear();
      stockController.clear();
      showMessage(context, text: "product Added...", color: Colors.green);
    }else{
      showMessage(context, text: "product Existe.....", color: Colors.red);

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(w*0.03),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                children: [
                  file!=null?
                  CircleAvatar(
                    radius: w*0.2,
                    backgroundImage: FileImage(file),
                  ):
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: w*0.2,),
                  Positioned(
                    top: w*0.25,
                    left: w*0.25,
                    child: InkWell(
                      onTap: () {
                        pickFile();
                      },
                      child: CircleAvatar(
                        radius: w*0.07,
                        backgroundColor: Colors.purple,
                        child: Icon(Icons.camera_alt_outlined),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: w*0.05,),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText:"name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w*0.03)
                  )
                ),
              ),
              SizedBox(height: w*0.05,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                controller: priceController,
                validator: (value) {
                  if(!priceValidation.hasMatch(value!)){
                    return "Enter valid price";
                  }
                },
                decoration: InputDecoration(
                  labelText:"price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w*0.03)
                  )
                ),
              ),
              SizedBox(height: w*0.05,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(!discountValidation.hasMatch(value!)){
                    return "Enter valid discount";
                  }
                },
                controller: discountController,
                decoration: InputDecoration(
                  labelText:"discount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w*0.03)
                  )
                ),
              ),
              SizedBox(height: w*0.05,),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(!stocktValidation.hasMatch(value!)){
                    return "Enter valid stock";
                  }
                },
                controller: stockController,
                decoration: InputDecoration(
                  labelText:"stock",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(w*0.03)
                  )
                ),
              ),
              SizedBox(height: w*0.05,),
              ElevatedButton(onPressed: () {
                  if(file!=null&& nameController.text.isNotEmpty&&
                      priceController.text.isNotEmpty&&
                      discountController.text.isNotEmpty&&
                      stockController.text.isNotEmpty){
                      productAdd();
                  }else{
                    file==null?showMessage(context,text: "please upload image", color: Colors.red):
                    nameController.text.isEmpty?showMessage(context,text: "please enter name", color: Colors.red):
                    priceController.text.isEmpty?showMessage(context,text: "please enter price ", color: Colors.red):
                    discountController.text.isEmpty?showMessage(context,text: "please enter discount ", color: Colors.red):
                    showMessage(context,text: "please enter stock", color: Colors.red);
                  }
              }, child: Text("Add"))
            ],
          ),
        ),
      ),
    );
  }
}
