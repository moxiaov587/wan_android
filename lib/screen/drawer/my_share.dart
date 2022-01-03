part of 'drawer.dart';

class MyShareScreen extends StatelessWidget {
  const MyShareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myShare),
      ),
      body: SafeArea(
        child: ColoredBox(
          color: currentTheme.backgroundColor,
        ),
      ),
    );
  }
}
