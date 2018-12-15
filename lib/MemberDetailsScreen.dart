import 'package:flutter/material.dart';
import 'package:flutter_app/Member.dart';

class MemberDetails extends StatelessWidget {
  final Member member;

  const MemberDetails({Key key, this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details for " + member.name),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: InkWell(
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/loading.gif',
                  image: member.picUrl,
                ),
                onDoubleTap: () {
                  _download(context);
                },
              ),
            ),
            Text(
              member.name,
              style: TextStyle(fontSize: 48, color: member.teamColor),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 20,
                bottom: 60,
              ),
              child: Text(
                '${member.group}48 Team ${member.team}',
                style: TextStyle(fontSize: 24, color: member.teamColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _download(context) {
    print("Double clicked on the pic");
  }
}
