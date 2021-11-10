import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? _reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    return _reverseMap??= map.map((k, v) => MapEntry(v, k));
  }
}

class Pair<T,K> {
  late T item1;
  late K item2;
  Pair({required this.item1, required this.item2});
}

String convert2StringDate(DateTime date, [String format = "yyyy-MM-ddTHH:mm:ss.mszz"]){
  int year = date.year;
  int month = date.month;
  int day = date.day;
  int hour = date.hour;
  int minute = date.minute;
  int second = date.second;
  int millisecond = date.millisecond;
  int timeZone = date.timeZoneOffset.inHours;
  return format
      .replaceFirst(RegExp(r'yyyy'), year.toString())
      .replaceFirst(RegExp(r'MM'), "00$month".slice(-2))
      .replaceFirst(RegExp(r'dd'), "00$day".slice(-2))
      .replaceFirst(RegExp(r'HH'), "00$hour".slice(-2))
      .replaceFirst(RegExp(r'hh'), "00${hour>12?hour-12:(hour!=0?hour:12)}".slice(-2))
      .replaceFirst(RegExp(r'mm'), "00$minute".slice(-2))
      .replaceFirst(RegExp(r'ss'), "00$second".slice(-2))
      .replaceFirst(RegExp(r'ms'), millisecond.toString())
      .replaceFirst(RegExp(r'tt'), hour<12?"a.m.":"p.m.")
      .replaceFirst(RegExp(r'zz'), "${timeZone}00".insert(1,abs(timeZone)<10?"0":""));
}

extension DurationHelper on Duration{
  String get inStringMicroseconds => "$inMicroseconds ${inMicroseconds>1||inMicroseconds==0?"microsegundos":"microsegundo"}";
  String get inStringSeconds => "$inSeconds ${inSeconds>1||inSeconds==0?"segundos":"segundo"}";
  String get inStringMinutes => "$inMinutes ${inMinutes>1||inMinutes==0?"minutos":"minuto"}";
  String get inStringHours => "$inHours ${inHours>1||inHours==0?"horas":"hora"}";
  String get inStringDays => "$inDays ${inDays>1||inDays==0?"días":"día"}";
  String get inStringMonths => "$inMonths ${inMonths>1||inMonths==0?"meses":"mes"}";
  String get inStringYears => "$inYears ${inYears>1||inYears==0?"años":"año"}";
  int get inMonths => inDays ~/ 30;
  int get inYears => inDays ~/ 365;
}

String getShortDurationString(Duration diff) => diff.inYears > 0? diff.inStringYears : (diff.inMonths > 0? diff.inStringMonths : (diff.inDays > 0? diff.inStringDays : (diff.inHours > 0? diff.inStringHours : (diff.inMinutes > 0? diff.inStringMonths : diff.inStringSeconds))));

num abs(num value) => value < 0? value * -1 : value;

extension StringHelper on String{
  String slice([int start = 0, int? end]) {
    int _realEnd;
    int _realStart = start < 0 ? length + start : start;
    if (end is! int) {
      _realEnd = length;
    } else {
      _realEnd = end < 0 ? length + end : end;
    }
    return substring(_realStart, _realEnd);
  }
  String insert(int index, String str){
    String _tempPrev = substring(0,index);
    String _tempNext = slice(index);
    return _tempPrev+str+_tempNext;
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({required Color color, required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;
  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
    ..color = color
    ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}

extension GlobalKeyHelper on GlobalKey {
  void updateState<T extends State>(
      {void Function(T currentState)? onUpdate}) {
    currentState!.setState(() {
      if (onUpdate != null) {
        onUpdate(currentState! as T);
      }
    });
  }
}

bool validateMail(String mail){
  return RegExp(r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$").hasMatch(mail);
}

String generateRandomCode(int digits){
  Random rnd = Random();
  String code = "";
  for(int i = 0; i < digits; i++){
    code += rnd.nextInt(10).toString();
  }
  return code;
}

List<int> _shadeIndex = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

Map<int, Color> buildMapColor(int color) => {
  for (int i = 0; i < _shadeIndex.length; i++)
    _shadeIndex[i]: Color(color).withOpacity((i + 1) / 10)
};

extension PositionHelper on Position{
  LatLng toLatLng() => LatLng(latitude, longitude);
}