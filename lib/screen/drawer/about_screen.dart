part of 'home_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).about),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: kStyleUint4 * 5),
                  child: FlutterLogo(size: kStyleUint4 * 4),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: kStyleUint4,
                    bottom: kStyleUint2,
                  ),
                  child: Text(
                    S.of(context).appName,
                    style: context.theme.textTheme.bodyLarge!.copyWith(
                      color: context.theme.textTheme.displayLarge!.color,
                      fontWeight: AppTextTheme.semiBold,
                    ),
                  ),
                ),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<PackageInfo> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      final PackageInfo packageInfo = snapshot.data!;

                      return Text(
                        '${packageInfo.version}(${packageInfo.buildNumber})',
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
