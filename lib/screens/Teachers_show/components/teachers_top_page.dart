import 'package:attendance/managers/App_State_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Show_Teachers_Top_Page extends StatelessWidget {
  const Show_Teachers_Top_Page({Key? key, required this.size})
      : super(key: key);
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false)
                  .checkteachers(false);
            },
            child:
                //  RotatedBox(
                // quarterTurns: 2,
                Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            // ),
          ),
          // Icon(
          //   Icons.menu,
          //   size: 30,
          // ),
          Row(
            children: [
              Icon(
                Icons.account_box,
                size: 30,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'المدرسين',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AraHamah1964B-Bold'),
                  ),
                ),
              ),
            ],
          ),
          Container(),
          // InkWell(
          //   onTap: () async {
          //     // await showSearch(context: context, delegate: GroupSearch());
          //   },
          //   child: Row(
          //     children: [
          //       Text(
          //         'بحث',
          //         style: TextStyle(
          //             fontFamily: 'GE-light',
          //             color: Colors.black87,
          //             fontSize: 20),
          //       ),
          //       Icon(
          //         Icons.search,
          //         size: 20,
          //         color: Colors.black87,
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
