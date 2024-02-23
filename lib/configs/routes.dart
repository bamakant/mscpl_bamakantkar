import 'package:flutter/material.dart';
import 'package:mscpl_bamakantkar/screens/login/login.dart';

class Routes {
  static const String loginRoute = '/';

  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      loginRoute: (_) => const Login(),
    };
  }
}
