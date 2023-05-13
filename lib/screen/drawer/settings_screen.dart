part of 'home_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
                        unawaited(const LanguagesRoute().push(context));
                      },
                    ),
                    ListTile(
                      leading: const Icon(IconFontIcons.deleteLine),
                      title: Text(S.of(context).clearCache),
                      onTap: () {
                        unawaited(const StorageRoute().push(context));
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: kStyleUint4),
              sliver: SliverToBoxAdapter(
                child: Consumer(
                  builder: (BuildContext context, WidgetRef ref, _) =>
                      ref.watch(authorizedProvider).valueOrNull != null
                          ? ListTile(
                              iconColor: context.theme.colorScheme.error,
                              textColor: context.theme.colorScheme.error,
                              leading: const Icon(IconFontIcons.shutDownLine),
                              title: Text(S.of(context).logout),
                              onTap:
                                  ref.read(authorizedProvider.notifier).logout,
                            )
                          : nil,
                ),
              ),
            ),
          ],
        ),
      );
}
