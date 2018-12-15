import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/Member.dart';
import 'package:flutter_app/MemberDetailsScreen.dart';
import 'package:flutter_app/Storage.dart';

class ListOfMembers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListOfMembersState();
}

class ListOfMembersState extends State<ListOfMembers> {
  final Future<List<Member>> members = Member.fetchMembers(DeviceStorage());
  String filterText = "";
  var _context;

  @override
  void initState() {
    super.initState();
    members.then((value) {
      Scaffold.of(_context).showSnackBar(
          SnackBar(content: Text("We found ${value.length} members.")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Members"),
      ),
      body: Center(
        child: FutureBuilder<List<Member>>(
          future: members,
          builder: (context, snapshot) {
            _context = context;
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(14),
                    child: TextField(
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 2),
                      onChanged: (value) {
                        setState(() {
                          filterText = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildListView(snapshot.data),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error);
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<Member> list) {
    list = list
        .where((member) => member.name.toLowerCase().contains(filterText))
        .toList();
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        return _buildItem(list[i]);
      },
    );
  }

  Widget _buildItem(Member member) {
    return Card(
      child: ListTile(
        title: Text(
          member.name,
          style: TextStyle(
            fontSize: 28.0,
            color: member.color,
          ),
        ),
        onTap: () {
          setState(() {
            member.color = Colors.grey;
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MemberDetails(member: member)));
        },
      ),
    );
  }
}
