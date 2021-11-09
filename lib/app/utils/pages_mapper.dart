import 'package:flutter/material.dart';
import 'package:flutter_codigo3_maps/app/pages/access_gps_page.dart';
import 'package:flutter_codigo3_maps/app/pages/home_page.dart';
import 'package:flutter_codigo3_maps/app/utils/my_utils.dart';

enum PagesMapper {
  homePage,
  accessGPS,
}

extension PageHelper on PagesMapper {
  String get name {
    return toString().split(".")[1];
  }

  Widget Function(BuildContext) get builderRoutePage {
    switch (this) {
      case PagesMapper.accessGPS: return (BuildContext context) => const AccessGPSPage();
      default:
        return (BuildContext context) => const HomePage();
    }
  }

  void push(BuildContext context, {Function(dynamic value)? then, Object? arguments}) {
    if(then != null){
      Navigator.pushNamed(
        context,
        name,
        arguments: arguments,
      ).then((value) => then(value));
    }else{
      Navigator.pushNamed(
        context,
        name,
        arguments: arguments,
      );
    }
  }

  void pushReplacement(BuildContext context,
      {Function(dynamic value)? then, Object? arguments}) {
    if (then != null) {
      Navigator.pushReplacementNamed(
        context,
        name,
        arguments: arguments,
      ).then((value) => then(value));
    } else {
      Navigator.pushReplacementNamed(
        context,
        name,
        arguments: arguments,
      );
    }
  }

  void popAndPushNamed(BuildContext context,
      {Function(dynamic)? then, Object? arguments}) {
    if (then != null) {
      Navigator.popAndPushNamed(
        context,
        name,

        arguments: arguments,
      ).then((value) => then(value));
    } else {
      Navigator.popAndPushNamed(
        context,
        name,

        arguments: arguments,
      );
    }
  }

  void pushNamedAndRemoveUntil(BuildContext context,
      {Function(dynamic value)? then, Object? arguments}) {
    if (then != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        name,
        (Route<dynamic> route) => false,
        arguments: arguments,
      ).then((value) => then(value));
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        name,
        (Route<dynamic> route) => false,
        arguments: arguments,
      );
    }
  }
}

Map<String, Widget Function(BuildContext)> buildMapRouter(){
  return PagesMapper.values.fold({}, (previousValue, element) {
    previousValue[element.name] = element.builderRoutePage;
    return previousValue;
  });
}

final originalPagesMapperValues = EnumValues(
  PagesMapper.values.fold<Map<String, PagesMapper>>(
    {},
        (previousValue, element) {
      previousValue[element.name] = element;
      return previousValue;
    },
  ),
);

mixin PagesArgumentsMixin {
  T getPageArguments<T>(BuildContext context){
    return ModalRoute.of(context)!.settings.arguments as T;
  }

  Future<T> getFuturePageArguments<T>(BuildContext context) {
    return Future.delayed(Duration.zero,()=>getPageArguments<T>(context));
  }

  FutureBuilder buildFutureWidgetWithArguments<T>({
    required BuildContext context,
    required Widget Function(BuildContext context, T arguments) builder,
    Widget Function(BuildContext context)? buildProgressWidget,
  }) {
    return FutureBuilder<T>(
      future: getFuturePageArguments<T>(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return buildProgressWidget != null
              ? buildProgressWidget(context)
              : Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
        }
        return builder(context, snapshot.data!);
      },
    );
  }
}