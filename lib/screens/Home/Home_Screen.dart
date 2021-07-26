import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/Auth_manager.dart';
import 'package:attendance/managers/Student_manager.dart';
import 'package:attendance/models/student.dart';
import 'package:attendance/navigation/screens.dart';
import 'package:attendance/screens/Students/components/Students_Top_Page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'components/choices.dart';
import 'components/options_widget.dart';

class Home_Screen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: Attendance_Screens.homepath,
      key: ValueKey(Attendance_Screens.homepath),
      child: const Home_Screen(),
    );
  }

  const Home_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kbackgroundColor2,
        body: (Column(
          children: [
            HomeTopPage(
              size: size,
            ),
            // Student_Top_Page(
            //   size: size,
            //   arrowback: false,
            // ),
            Options(size: size),
            Container(
              height: size.height * .7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Choices(size: size),
                    // build_chip_container_down(null, 'مجموعه الحضور'),
                    SizedBox(
                      height: 10,
                    ),
                    Consumer<AppStateManager>(
                      builder: (context, appstatemanager, child) =>
                          GestureDetector(
                        onTap: appstatemanager.homeOptions ? () {} : null,
                        child: Scan_button(
                          active: appstatemanager.homeOptions,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

class Scan_button extends StatelessWidget {
  const Scan_button({Key? key, required this.active}) : super(key: key);
  final bool active;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all()),
      child: Container(
        alignment: Alignment.center,
        height: 70,
        width: 70,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? Colors.black54 : Colors.black26),
        child: Text(
          'Scan',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}

class HomeTopPage extends StatelessWidget {
  const HomeTopPage({Key? key, required this.size}) : super(key: key);
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
          InkWell(
            onTap: () {
              Provider.of<Auth_manager>(context, listen: false).logout();
            },
            child: Icon(
              Icons.menu,
              size: 30,
            ),
          ),
          Text(
            'الصفحه الرئيسيه',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                fontFamily: 'AraHamah1964B-Bold'),
          ),
          InkWell(
            onTap: () async {
              showSearch(context: context, delegate: StudentSearch());
            },
            child: Row(
              children: [
                Text(
                  'بحث',
                  style:
                      TextStyle(fontFamily: 'GE-medium', color: Colors.black87),
                ),
                Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.black87,
                ),
              ],
            ),
          )
          // InkWell(
          //   onTap: () {
          //     Provider.of<AppStateManager>(context, listen: false).go_to_Home();
          //   },
          //   child: RotatedBox(
          //     quarterTurns: 2,
          //     child: Icon(
          //       Icons.arrow_back,
          //       color: Colors.black,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class StudentSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) =>
      FutureBuilder<List<StudentModel>>(
        future: Provider.of<StudentManager>(context, listen: false)
            .searchStudent(query),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                // print(snapshot.error);
                return Container(
                  // color: Colors.black,
                  alignment: Alignment.center,
                  child: Text(
                    'يوجد خطأ',
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                );
              } else {
                return buildResultSuccess(snapshot.data![0]);
              }
          }
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) => Container(
        // color: Colors.black,
        child: FutureBuilder<List<StudentModel>>(
          future: Provider.of<StudentManager>(context, listen: false)
              .searchStudent(query),
          builder: (context, snapshot) {
            print(snapshot.error);
            if (query.isEmpty) return buildNoSuggestions();

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return buildNoSuggestions();
                } else {
                  return buildSuggestionsSuccess(snapshot.data);
                }
            }
          },
        ),
      );

  Widget buildNoSuggestions() => Center(
        child: Text(
          'لا يوجد اقتراحات',
          style: TextStyle(fontSize: 28, color: Colors.black),
        ),
      );

  Widget buildSuggestionsSuccess(List<StudentModel>? suggestions) =>
      ListView.builder(
        itemCount: suggestions!.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index].name;
          final queryText = suggestion!.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              // query = suggestion;

              // 1. Show Results
              // showResults(context);
              // close(context, '');
              Provider.of<AppStateManager>(context, listen: false)
                  .goToSingleStudentfromHome(
                      true, suggestions[index].id.toString());
              // print( Provider.of<AppStateManager>(context, listen: false).studentRegister)
              // .g(
              //     true, suggestions[index].id.toString());

              // 2. Close Search & Return Result
              // close(context, suggestion);

              // 3. Navigate to Result Page
              //  Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => ResultPage(suggestion),
              //   ),
              // );
            },
            leading: Icon(Icons.person),
            // title: Text(suggestion),
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget buildResultSuccess(StudentModel student) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3279e2), Colors.purple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(64),
          children: [
            Text(
              student.name!,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 72),
            const SizedBox(height: 32),
          ],
        ),
      );

  // Widget buildDegrees(Weather weather) {
  //   final style = TextStyle(
  //     fontSize: 100,
  //     fontWeight: FontWeight.bold,
  //     color: Colors.white,
  //   );

  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Opacity(
  //         opacity: 0,
  //         child: Text('°', style: style),
  //       ),
  //       Text('${weather.degrees}°', style: style),
  //     ],
  //   );
  // }
}
