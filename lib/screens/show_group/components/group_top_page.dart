import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/group_manager.dart';
import 'package:attendance/models/groupmodelsimple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Show_Group_Top_Page extends StatelessWidget {
  const Show_Group_Top_Page({Key? key, required this.size}) : super(key: key);
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
                  .gotocheckgroups(false);
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
              Icon(Icons.table_view_sharp),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'المجموعات',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AraHamah1964B-Bold'),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              await showSearch(context: context, delegate: GroupSearch());
            },
            child: Row(
              children: [
                Text(
                  'بحث',
                  style: TextStyle(
                      fontFamily: 'GE-light',
                      color: Colors.black87,
                      fontSize: 20),
                ),
                Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.black87,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GroupSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) => [
        Row(
          children: [
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
            ),
            // IconButton(
            //   icon: Icon(Icons.clear),
            //   onPressed: () {
            //     if (query.isEmpty) {
            //       close(context, '');
            //     } else {
            //       query = '';
            //       showSuggestions(context);
            //     }
            //   },
            // ),
          ],
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) =>
      FutureBuilder<List<GroupModelSimple>>(
        future: Provider.of<GroupManager>(context, listen: false)
            .searchgroups(query),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Container(
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
        child: FutureBuilder<List<GroupModelSimple>>(
          future: Provider.of<GroupManager>(context, listen: false)
              .searchgroups(query),
          builder: (context, snapshot) {
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

  Widget buildSuggestionsSuccess(List<GroupModelSimple>? suggestions) {
    return ListView.builder(
        itemCount: suggestions!.length,
        itemBuilder: (context, index) {
          final name_suggestion = suggestions[index].name;
          final name_queryText = name_suggestion!.substring(0, query.length);
          final name_remainingText = name_suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false)
                  .goToSinglegroup(true, suggestions[index].id.toString(),
                      suggestions[index]);
            },
            leading: Icon(Icons.person),
            title: RichText(
              text: TextSpan(
                text: name_queryText,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: name_remainingText,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildResultSuccess(GroupModelSimple student) => Container(
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
}
