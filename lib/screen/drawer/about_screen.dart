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
                Padding(
                  padding: const EdgeInsets.only(top: kStyleUint4 * 5),
                  child: Image.asset(
                    Assets.ASSETS_SPLASH_PNG,
                    width: 60.0,
                    height: 60.0,
                  ),
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
