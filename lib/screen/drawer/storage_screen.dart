part of 'home_drawer.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).clearCache),
        ),
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: CupertinoListSection.insetGrouped(
                    backgroundColor: context.theme.scaffoldBackgroundColor,
                    children: <Widget>[
                      _StorageListTile(
                        disableProvider: disableCheckOtherCachesProvider,
                        checkProvider: checkOtherCachesProvider,
                        sizeProvider: otherCacheSizeProvider,
                        title: S.of(context).otherCache,
                        subtitle: S.of(context).otherCacheTips,
                        onChanged: (WidgetRef ref) {
                          ref
                              .read(checkOtherCachesProvider.notifier)
                              .update((bool state) => !state);
                        },
                      ),
                      _StorageListTile(
                        disableProvider: disableCheckResponseDataCachesProvider,
                        checkProvider: checkResponseDataCachesProvider,
                        sizeProvider: responseDataCacheSizeProvider,
                        title: S.of(context).responseDataCache,
                        subtitle: S.of(context).responseDataCacheTips,
                        onChanged: (WidgetRef ref) {
                          ref
                              .read(checkResponseDataCachesProvider.notifier)
                              .update((bool state) => !state);
                        },
                      ),
                      _StorageListTile(
                        disableProvider: disableCheckPreferencesCachesProvider,
                        checkProvider: checkPreferencesCachesProvider,
                        sizeProvider: preferencesCacheSizeProvider,
                        title: S.of(context).preferencesCache,
                        subtitle: S.of(context).preferencesCacheTips,
                        onChanged: (WidgetRef ref) {
                          ref
                              .read(checkPreferencesCachesProvider.notifier)
                              .update((bool state) => !state);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: _BottomActionBar(),
            ),
          ],
        ),
      );
}

class _StorageListTile extends ConsumerWidget {
  const _StorageListTile({
    required this.disableProvider,
    required this.checkProvider,
    required this.sizeProvider,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  final AutoDisposeProvider<bool> disableProvider;
  final AutoDisposeNotifierProvider<AutoDisposeNotifier<bool>, bool>
      checkProvider;
  final AutoDisposeNotifierProvider<AutoDisposeNotifier<int>, int> sizeProvider;
  final String title;
  final String subtitle;
  final void Function(WidgetRef) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) => CupertinoListTile(
        padding: AppTheme.bodyPadding,
        backgroundColor: context.theme.cardColor,
        backgroundColorActivated:
            context.theme.scaffoldBackgroundColor.withOpacity(0.5),
        leading: Consumer(
          builder: (_, WidgetRef ref, Widget? child) {
            final bool disabled = ref.watch(disableProvider);

            return Opacity(
              opacity: disabled ? 0.5 : 1.0,
              child: child,
            );
          },
          child: Consumer(
            builder: (_, WidgetRef ref, __) {
              final bool selected = ref.watch(checkProvider);

              return CupertinoCheckbox(
                value: selected,
                activeColor: context.theme.primaryColor,
                checkColor: context.theme.colorScheme.background,
                onChanged: (_) {
                  if (ref.read(sizeProvider) > 0) {
                    onChanged.call(ref);
                  }
                },
              );
            },
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: context.theme.textTheme.displayMedium!.color,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: context.theme.textTheme.bodyMedium!.color,
          ),
        ),
        trailing: Consumer(
          builder: (_, WidgetRef ref, __) =>
              Text(ref.watch(sizeProvider).fileSize),
        ),
        onTap: () {
          if (ref.read(sizeProvider) > 0) {
            onChanged.call(ref);
          }
        },
      );
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar();

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: context.theme.cardColor,
        child: Padding(
          padding: AppTheme.contentPadding.copyWith(
            bottom: AppTheme.contentPadding.bottom + context.mqPadding.bottom,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Consumer(
                builder: (_, WidgetRef ref, __) {
                  final bool checkAll = ref.watch(checkAllCachesProvider);

                  return TextButton(
                    onPressed: () {
                      if (!ref.read(disableCheckOtherCachesProvider)) {
                        ref
                            .read(checkOtherCachesProvider.notifier)
                            .update((_) => !checkAll);
                      }
                      if (!ref.read(disableCheckResponseDataCachesProvider)) {
                        ref
                            .read(
                              checkResponseDataCachesProvider.notifier,
                            )
                            .update((_) => !checkAll);
                      }

                      if (!ref.read(disableCheckPreferencesCachesProvider)) {
                        ref
                            .read(
                              checkPreferencesCachesProvider.notifier,
                            )
                            .update((_) => !checkAll);
                      }
                    },
                    child: Text(
                      checkAll
                          ? S.of(context).deselectAll
                          : S.of(context).selectAll,
                    ),
                  );
                },
              ),
              Row(
                children: <Widget>[
                  Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final bool checkOther =
                          ref.watch(checkOtherCachesProvider);
                      final bool checkResponseData =
                          ref.watch(checkResponseDataCachesProvider);
                      final bool checkPreferences =
                          ref.watch(checkPreferencesCachesProvider);

                      final int otherCacheSize =
                          ref.watch(otherCacheSizeProvider);
                      final int responseDataCacheSize =
                          ref.watch(responseDataCacheSizeProvider);
                      final int preferencesCacheSize =
                          ref.watch(preferencesCacheSizeProvider);

                      final int total = <int>[
                        if (checkOther) otherCacheSize,
                        if (checkResponseData) responseDataCacheSize,
                        if (checkPreferences) preferencesCacheSize,
                      ].fold(
                        0,
                        (
                          int total,
                          int size,
                        ) =>
                            total += size,
                      );

                      if (total == 0) {
                        return const SizedBox.shrink();
                      }

                      return Text(S.of(context).occupies(total.fileSize));
                    },
                  ),
                  const Gap.hn(),
                  Consumer(
                    builder: (_, WidgetRef ref, __) => ElevatedButton(
                      onPressed: ref.watch(cleanableProvider)
                          ? () async {
                              final bool? result =
                                  await DialogUtils.confirm<bool>(
                                isDanger: true,
                                builder: (BuildContext context) => Text(
                                  S.of(context).clearCacheWarning,
                                ),
                                confirmText: S.of(context).clear,
                                confirmCallback: () => Future<bool>.value(true),
                              );

                              if (result ?? false) {
                                final List<VoidCallback> task =
                                    <VoidCallback>[];

                                if (ref.read(cleanableOtherCachesProvider)) {
                                  task.addAll(
                                    ref
                                        .read(otherCacheSizeProvider.notifier)
                                        .getClearTxn(),
                                  );
                                }

                                if (ref.read(
                                  cleanableResponseDataCachesProvider,
                                )) {
                                  task.addAll(
                                    ref
                                        .read(
                                          responseDataCacheSizeProvider
                                              .notifier,
                                        )
                                        .getClearTxn(),
                                  );
                                }
                                if (ref.read(
                                  cleanablePreferencesCachesProvider,
                                )) {
                                  task.addAll(
                                    ref
                                        .read(
                                          preferencesCacheSizeProvider.notifier,
                                        )
                                        .getClearTxn(),
                                  );
                                }
                                await ref.read(appDatabaseProvider).writeAsync(
                                  (Isar isar) {
                                    for (final VoidCallback t in task) {
                                      t();
                                    }
                                  },
                                );

                                ref
                                  ..invalidate(otherCacheSizeProvider)
                                  ..invalidate(responseDataCacheSizeProvider)
                                  ..invalidate(preferencesCacheSizeProvider);
                              }
                            }
                          : null,
                      child: Text(S.of(context).clear),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
