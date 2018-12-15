import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_app/Storage.dart';

class Member {
  final String sid;
  final String name;
  final String team;
  final String group;
  final String tcolor;

  Color color = Colors.black;

  Color get teamColor {
    if (tcolor == null) {
      return Colors.black;
    }
    return Color(int.parse(tcolor, radix: 16)).withOpacity(1.0);
  }

  String get picUrl {
    switch (this.group) {
      case "CKG":
//        picUrl = 'http://www.ckg48.com/images/members/zp_${this.sid}.jpg';
        return 'http://www.ckg48.com/images/members/gs4_${this.sid}_1.jpg';
        break;
      default:
        return 'http://www.${this.group.toLowerCase()}48.com/images/member/gs4_${this.sid}_2.jpg';
        break;
    }
  }

  Member({this.sid, this.name, this.team, this.group, this.tcolor});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      sid: json['sid'],
      name: json['pinyin'],
      team: json['tname'],
      group: json['gname'],
      tcolor: json['tcolor'],
    );
  }

  static Future<List<Member>> fetchMembers(DeviceStorage storage) async {
    // try to load from local storage first:
    return storage.readJson().then((content) {
      if (content != null) {
        return content;
      } else {
        // fetch from internet:
        return _downloadJson(saveTo: storage);
      }
    }).then((content) {
      // parse json:
      final memberJson = json.decode(content);
      return memberJson.map<Member>((it) => Member.fromJson(it)).toList();
    });
  }

  static Future<String> _downloadJson({@required DeviceStorage saveTo}) async {
    var responses = (await Future.wait([
      'http://h5.snh48.com/resource/jsonp/members.php?gid=10',
      'http://h5.snh48.com/resource/jsonp/members.php?gid=20',
      'http://h5.snh48.com/resource/jsonp/members.php?gid=30',
      'http://h5.snh48.com/resource/jsonp/members.php?gid=40',
      'http://h5.snh48.com/resource/jsonp/members.php?gid=50',
    ].map((url) {
      // get json from api endpoint:
      return http.get(url);
    })));

    var totalRows = responses.map((response) {
      if (response.statusCode == 200) {
        return json.decode(response.body)['rows'];
      } else {
        throw Exception('Failed to load members from Internet.');
      }
    }).reduce((total, rows) {
      total.addAll(rows);
      return total;
    });

    String encoded = json.encode(totalRows);
    saveTo.writeJson(encoded);
    return encoded;
  }
}
