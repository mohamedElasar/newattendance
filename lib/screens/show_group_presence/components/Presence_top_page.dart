import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/models/appointment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Show_Presence_Top_Page extends StatelessWidget {
  const Show_Presence_Top_Page({Key? key, required this.size})
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
                  .goToSinglelessonattend(false, '', AppointmentModel());
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              Icon(Icons.table_view_sharp),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'حضور الحصه',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AraHamah1964B-Bold'),
                  ),
                ),
              ),
            ],
          ),
          Container()
        ],
      ),
    );
  }
}
