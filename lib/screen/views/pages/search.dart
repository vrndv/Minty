import 'package:flutter/material.dart';
import 'package:popapp/dataNotifiers/notifier.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                isSearch.value = false;
              },
              child: Text("data"),
            ),
            SearchBar(onTap: () {
              
            },hintText: "Search",leading: Icon(Icons.search),onChanged: (value) => print(value),)
          ],
        ),
      ),
    );
  }
}
