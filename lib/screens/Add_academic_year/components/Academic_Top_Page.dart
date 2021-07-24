import 'package:attendance/managers/App_State_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Academic_Top_Page extends StatelessWidget {
  const Academic_Top_Page({Key? key, required this.size}) : super(key: key);
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: size.height * .1,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.menu,
            size: 30,
          ),
          Text(
            'السنوات الدراسية',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: 'AraHamah1964B-Bold'),
          ),
          InkWell(
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false).go_to_Home();
            },
            child: RotatedBox(
              quarterTurns: 2,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
