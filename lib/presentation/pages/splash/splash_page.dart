import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:king_investor/presentation/controllers/splash_controller.dart';
import 'package:king_investor/presentation/static/app_images.dart';
import 'package:king_investor/presentation/widgets/load_indicator_widget.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  final controller = SplashController();

  @override
  void initState() {
    super.initState();
    controller.control = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    controller.curve = CurvedAnimation(
        parent: controller.control, curve: Curves.easeInOutExpo);
    controller.initialConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double width =
        0.4 * (size.width < size.height ? size.width : size.height);
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        child: AnimatedBuilder(
          animation: controller.control,
          builder: (context, child) {
            final control = controller.control;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    decoration:
                        BoxDecoration(color: theme.scaffoldBackgroundColor),
                    width: width * control.value,
                    child: Image(
                        image: AssetImage(AppImages.transparentLogo),
                        fit: BoxFit.fill),
                  ),
                ),
                Container(
                  height: 25 * control.value,
                  child: Text('KING INVESTOR',
                      style: TextStyle(color: theme.hintColor, fontSize: 26)),
                ),
                SizedBox(height: 50),
                Obx(() {
                  if (controller.error.isEmpty)
                    return _loadingWidget(control.value, theme.hintColor);
                  return _errorWidget(theme, controller.error);
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _loadingWidget(double value, Color color) {
    return Container(
      height: 50,
      child: value != 1.0 ? Container() : LoadIndicatorWidget(color: color),
    );
  }

  Widget _errorWidget(ThemeData theme, String errorMessage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Icon(Icons.sync_problem, color: theme.errorColor, size: 80),
          ),
          SizedBox(height: 10),
          Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            child: Text(
              'NÃO TEM JEITO FÁCIL DE DIZER ISSO...',
              style: TextStyle(
                  color: theme.errorColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Tivemos um probleminha ao tentar recuperar informações do servidor. Por favor, verifique' +
                ' sua conexão com a internet e tente novamente.',
            style: TextStyle(color: theme.errorColor, fontSize: 17),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 25),
          Text(
            'MAIS INFORMAÇÕES DO PROBLEMA:',
            style: TextStyle(color: theme.errorColor, fontSize: 18),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 5),
          Text(
            '"$errorMessage"',
            style: TextStyle(color: theme.errorColor, fontSize: 17),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
