import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/Auth_manager.dart';
import 'package:attendance/managers/Student_manager.dart';
import 'package:attendance/managers/stage_manager.dart';
import 'package:attendance/managers/year_manager.dart';
import 'package:attendance/models/student.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Student_Top_Page extends StatelessWidget {
  const Student_Top_Page({Key? key, required this.size, this.arrowback = true})
      : super(key: key);
  final Size size;
  final bool arrowback;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: size.height * .12,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              //test
              InkWell(
                onTap: () {
                  Provider.of<Auth_manager>(context, listen: false).logout();
                },
                child: Icon(
                  Icons.menu,
                  size: 30,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: size.height * .05,
                  // width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: (1),
                        color: Colors.grey,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            hintText: "بحث",
                            hintStyle: TextStyle(fontFamily: 'GE-light'),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                          ),
                        ),
                      ), //test
                      InkWell(
                          // onTap: () async {
                          //   showSearch(
                          //       context: context, delegate: StudentSearch());
                          // },
                          child: Icon(Icons.search))
                    ],
                  ),
                ),
              ),
              SizedBox(width: 5),
              arrowback
                  ? InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: Icon(
                          Icons.arrow_back,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
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
