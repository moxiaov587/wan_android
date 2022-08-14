part of 'home_drawer.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(applicationCacheSizeProvider.notifier).initData();
  }

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
                      AppRouterDelegate.instance.currentBeamState.updateWith(
                        isLanguages: true,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(IconFontIcons.deleteLine),
                    title: Text(S.of(context).clearCache),
                    trailing: ref.watch(applicationCacheSizeProvider).when(
                          (int? value) => Text(value.fileSize),
                          loading: () => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              LoadingWidget(
                                radius: 8.0,
                              ),
                            ],
                          ),
                          error: (_, __, ___) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                IconFontIcons.refreshLine,
                                size: 14.0,
                              ),
                              Gap(
                                direction: GapDirection.horizontal,
                                size: GapSize.small,
                              ),
                              Text(S.of(context).retry),
                            ],
                          ),
                        ),
                    onTap: () {
                      ref.read(applicationCacheSizeProvider).when(
                            (_) {
                              DialogUtils.confirm<void>(
                                isDanger: true,
                                builder: (BuildContext context) =>
                                    Text(S.of(context).clearCacheWarning),
                                confirmCallback: ref
                                    .read(applicationCacheSizeProvider.notifier)
                                    .clear,
                              );
                            },
                            loading: () {},
                            error: (_, __, ___) {
                              ref
                                  .read(applicationCacheSizeProvider.notifier)
                                  .initData();
                            },
                          );
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
                      iconColor: context.theme.errorColor,
                      textColor: context.theme.errorColor,
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
