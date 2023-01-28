part of 'home_drawer.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.only(top: kStyleUint4),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  ListTile(
                    leading: const Icon(IconFontIcons.globalLine),
                    title: Text(S.of(context).languages),
                    onTap: () {
                      const LanguagesRoute().push(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(IconFontIcons.deleteLine),
                    title: Text(S.of(context).clearCache),
                    onTap: () {
                      const StorageRoute().push(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: kStyleUint4),
            sliver: SliverToBoxAdapter(
              child: ref.watch(authorizedProvider) == null
                  ? nil
                  : ListTile(
                      iconColor: context.theme.colorScheme.error,
                      textColor: context.theme.colorScheme.error,
                      leading: const Icon(IconFontIcons.shutDownLine),
                      title: Text(S.of(context).logout),
                      onTap: () {
                        ref.read(authorizedProvider.notifier).logout();
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
