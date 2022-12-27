part of 'home_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).about),
      ),
      body: SafeArea(
        child: ColoredBox(
          color: context.theme.colorScheme.background,
        ),
      ),
    );
  }
}
