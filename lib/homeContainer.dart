import 'package:flutter/material.dart';



class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 10),
            child: Column(
              children: [
                //Todo list builder

              ],
            ),
          )
        ],
      ),
    );
  }
}

