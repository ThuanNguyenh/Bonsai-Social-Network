import 'package:bonsai_shop/screens/introls/splash_services.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static void isLogin(BuildContext context) {}
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SplashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
