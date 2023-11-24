import 'package:askar_task/add_product.dart';
import 'package:askar_task/view_product.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class tabBar extends StatefulWidget {
  const tabBar({super.key});

  @override
  State<tabBar> createState() => _tabBarState();
}

class _tabBarState extends State<tabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text("Crud"),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: "add",
              ),
              Tab(
                text: "view",
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                  children: [
                    addProduct(),
                    viewProduct()

                  ]),
            )
          ],
        ),
      ),

    );
  }
}
