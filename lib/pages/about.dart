import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spotsong/pages/navigation_bar.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
          style: TextStyle(fontSize: 20.0),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const NewNavBar(),
      body: const Center(
        child: Text(" hi from PlayerOne"),
      ),
    );
  }
}
