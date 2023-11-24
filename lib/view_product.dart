import 'package:askar_task/firebase_constants.dart';
import 'package:askar_task/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class viewProduct extends StatefulWidget {
  const viewProduct({super.key});

  @override
  State<viewProduct> createState() => _viewProductState();
}

class _viewProductState extends State<viewProduct> {
  TextEditingController nameController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  TextEditingController discountController= TextEditingController();
  TextEditingController stockController= TextEditingController();
  final RegExp priceValidation=RegExp(r'[0-9]$');
  final RegExp discountValidation=RegExp(r'[0-9]$');
  final RegExp stocktValidation=RegExp(r'[0-9]$');
  getProduct(){
    return FirebaseFirestore.instance.collection(constants.product)
        .where("delete",isEqualTo: false)
        .orderBy("date",descending: true)
        .snapshots().map((event) => event.docs.map((e) => ProductList.fromJson(e.data())).toList());
  }
  @override
  void initState() {
    getProduct();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ProductList>>(
              stream: getProduct(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  print(snapshot);
                  return Center(child: CircularProgressIndicator(),);
                }
                List<ProductList> allProduct =snapshot.data!;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: allProduct.length,
                  itemBuilder: (BuildContext context, int index) {
                    ProductList product =allProduct[index];
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                              radius: w*0.15,
                              backgroundImage: NetworkImage(product.image)),
                          Column(
                            children: [
                              Text("Product Name: ${product.prdctName}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: w*0.04
                                  )),
                              Text("price :${product.price.toString()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: w*0.04
                                  )),
                              Text("discount:${product.discount.toString()}%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: w*0.04
                                  )),
                              Text("Stock:${product.stock.toString()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: w*0.04
                                  )),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              nameController.text=product.prdctName;
                              priceController.text=product.price.toString();
                              discountController.text=product.discount.toString();
                              stockController.text=product.stock.toString();
                              showDialog(context: context, builder: (context) {
                                return AlertDialog(
                                    title: Text("update"),
                                    content: Container(
                                      height: w*1.2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextFormField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                                labelText:"name",
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(w*0.03)
                                                )
                                            ),
                                          ),
                                          TextFormField(
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
                                          TextFormField(
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
                                          TextFormField(
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
                                          ElevatedButton(onPressed: () {
                                            if(nameController.text.isNotEmpty&&
                                                priceController.text.isNotEmpty&&
                                                discountController.text.isNotEmpty&&
                                                stockController.text.isNotEmpty){
                                              var a =product.copyWith(prdctName: nameController.text.trim(),
                                              price: double.tryParse(priceController.text.trim()),
                                                  discount: double.tryParse(discountController.text.trim()),
                                                stock: double.tryParse(stockController.text.trim())
                                              );
                                              FirebaseFirestore.instance.collection(constants.product).doc(product.id).update(a.toJson());
                                              Navigator.pop(context);
                                            }else{
                                              nameController.text.isEmpty?showMessage(context,text: "please enter name", color: Colors.red):
                                              priceController.text.isEmpty?showMessage(context,text: "please enter price ", color: Colors.red):
                                              discountController.text.isEmpty?showMessage(context,text: "please enter discount ", color: Colors.red):
                                              showMessage(context,text: "please enter stock", color: Colors.red);
                                            }
                                          }, child: Text("Update"))
                                        ],
                                      ),
                                    )
                                );
                              },);
                            },
                              child: Icon(Icons.edit)),
                          InkWell(
                            onTap: () {
                              showDialog(context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Do you want to delete?"),
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            var a =product.copyWith(
                                              delete: true
                                            );
                                            product.reference.update(a.toJson());
                                            // FirebaseFirestore.instance.collection(constants.product).doc(product.id).delete();
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted successfully")));
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: w*0.1,
                                            width: w*0.15,
                                            decoration: BoxDecoration(
                                              color: Colors.purple,
                                              borderRadius: BorderRadius.circular(w*0.03),
                                            ),
                                            child: Center(
                                              child: Text("Yes",style:
                                              TextStyle(
                                                  color: Colors.white
                                              )),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: w*0.1,
                                            width: w*0.15,
                                            decoration: BoxDecoration(
                                              color: Colors.purple,
                                              borderRadius: BorderRadius.circular(w*0.03),
                                            ),
                                            child: Center(
                                              child: Text("No",style:
                                              TextStyle(
                                                  color: Colors.white
                                              )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },);
                            },
                              child: Icon(Icons.delete)),
                        ],
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: w*0.03,);
                },
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
