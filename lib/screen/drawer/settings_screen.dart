part of 'home_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ListTileConfig> settings = <ListTileConfig>[
      ListTileConfig(
        iconData: IconFontIcons.globalLine,
        title: S.of(context).languages,
        onTap: () {
          AppRouterDelegate.instance.currentBeamState.updateWith(
            isLanguages: true,
          );
        },
      ),
      ListTileConfig(
        iconData: IconFontIcons.deleteLine,
        title: S.of(context).clearCache,
        onTap: () {
          DialogUtils.confirm(
            isDanger: true,
            content: Text(S.of(context).clearCacheWarning),
            confirmCallback: () {
              HiveBoxes.clearCache();
            },
          );
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.only(top: kStyleUint4),
            sliver: SliverList(
              delegate: CustomSliverChildBuilderDelegate.separated(
                itemBuilder: (_, int index) {
                  final ListTileConfig config = settings[index];

                  return ListTile(
                    leading: Icon(config.iconData),
                    title: Text(config.title),
                    onTap: config.onTap,
                  );
                },
                itemCount: settings.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: kStyleUint4),
            sliver: SliverToBoxAdapter(
              child: Consumer(
                builder: (_, WidgetRef ref, Widget? title) =>
                    ref.watch(authorizedProvider) == null
                        ? nil
                        : ListTile(
                            iconColor: currentTheme.errorColor,
                            textColor: currentTheme.errorColor,
                            leading: const Icon(IconFontIcons.shutDownLine),
                            title: title,
                            onTap: () {
                              ref.read(authorizedProvider.notifier).logout();
                            },
                          ),
                child: Text(S.of(context).logout),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
