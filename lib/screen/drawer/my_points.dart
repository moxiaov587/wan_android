part of 'drawer.dart';

class MyPointsScreen extends StatelessWidget {
  const MyPointsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myPoints),
      ),
      body: SafeArea(
        child: ColoredBox(
          color: currentTheme.backgroundColor,
        ),
      ),
    );
  }
}
