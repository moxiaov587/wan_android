part of 'drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).about),
      ),
      body: SafeArea(
        child: ColoredBox(
          color: currentTheme.backgroundColor,
        ),
      ),
    );
  }
}
