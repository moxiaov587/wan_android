part of 'drawer.dart';

class MyCollectionsScreen extends StatelessWidget {
  const MyCollectionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myCollections),
      ),
      body: SafeArea(
        child: ColoredBox(
          color: currentTheme.backgroundColor,
        ),
      ),
    );
  }
}
