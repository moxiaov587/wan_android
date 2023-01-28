part of 'home_drawer.dart';

class StorageScreen extends ConsumerStatefulWidget {
  const StorageScreen({super.key});

  @override
  ConsumerState<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends ConsumerState<StorageScreen> {
  @override
  void initState() {
    super.initState();

    _initData();
  }

  void _initData() {
    ref.read(otherCacheSizeProvider.notifier).initData();
    ref.read(responseDataCacheSizeProvider.notifier).initData();
    ref.read(preferencesCacheSizeProvider.notifier).initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    CupertinoListTile(
                      padding: AppTheme.bodyPadding,
                      backgroundColor: context.theme.cardColor,
                      backgroundColorActivated: context
                          .theme.scaffoldBackgroundColor
                          .withOpacity(0.5),
                      leading: Consumer(
                        builder: (_, WidgetRef ref, __) {
                          final bool selected =
                              ref.watch(checkOtherCachesProvider);
                          final bool disabled =
                              ref.watch(disableCheckOtherCachesProvider);

                          return Opacity(
                            opacity: disabled ? 0.5 : 1.0,
                            child: Checkbox(
                              value: selected,
                              onChanged: (bool? result) {
                                ref.read(otherCacheSizeProvider).when(
                                      (int? value) {
                                        if ((value ?? 0) > 0) {
                                          ref
                                              .read(
                                                checkOtherCachesProvider
                                                    .notifier,
                                              )
                                              .state = result ?? false;
                                        }
                                      },
                                      loading: () {},
                                      error: (_, __, ___) {
                                        ref
                                            .read(
                                              otherCacheSizeProvider.notifier,
                                            )
                                            .initData();
                                      },
                                    );
                              },
                            ),
                          );
                        },
                      ),
                      title: Text(S.of(context).otherCache),
                      subtitle: Text(S.of(context).otherCacheTips),
                      trailing: Consumer(
                        builder: (_, WidgetRef ref, __) => ref
                            .watch(otherCacheSizeProvider)
                            .when(
                              (int? value) => Text(value.fileSize),
                              loading: () => const CupertinoActivityIndicator(),
                              error: (_, __, ___) =>
                                  const Icon(IconFontIcons.refreshLine),
                            ),
                      ),
                      onTap: () {
                        ref.read(otherCacheSizeProvider).when(
                              (int? value) {
                                if ((value ?? 0) > 0) {
                                  ref
                                          .read(
                                            checkOtherCachesProvider.notifier,
                                          )
                                          .state =
                                      !ref.read(checkOtherCachesProvider);
                                }
                              },
                              loading: () {},
                              error: (_, __, ___) {
                                ref
                                    .read(otherCacheSizeProvider.notifier)
                                    .initData();
                              },
                            );
                      },
                    ),
                    CupertinoListTile(
                      padding: AppTheme.bodyPadding,
                      backgroundColor: context.theme.cardColor,
                      backgroundColorActivated: context
                          .theme.scaffoldBackgroundColor
                          .withOpacity(0.5),
                      leading: Consumer(
                        builder: (_, WidgetRef ref, __) {
                          final bool selected =
                              ref.watch(checkResponseDataCachesProvider);
                          final bool disabled =
                              ref.watch(disableCheckResponseDataCachesProvider);

                          return Opacity(
                            opacity: disabled ? 0.5 : 1.0,
                            child: Checkbox(
                              value: selected,
                              onChanged: (bool? result) {
                                ref.read(responseDataCacheSizeProvider).when(
                                      (int? value) {
                                        if ((value ?? 0) > 0) {
                                          ref
                                              .read(
                                                checkResponseDataCachesProvider
                                                    .notifier,
                                              )
                                              .state = result ?? false;
                                        }
                                      },
                                      loading: () {},
                                      error: (_, __, ___) {
                                        ref
                                            .read(responseDataCacheSizeProvider
                                                .notifier)
                                            .initData();
                                      },
                                    );
                              },
                            ),
                          );
                        },
                      ),
                      title: Text(S.of(context).responseDataCache),
                      subtitle: Text(S.of(context).responseDataCacheTips),
                      trailing: Consumer(
                        builder: (_, WidgetRef ref, __) => ref
                            .watch(responseDataCacheSizeProvider)
                            .when(
                              (int? value) => Text(value.fileSize),
                              loading: () => const CupertinoActivityIndicator(),
                              error: (_, __, ___) =>
                                  const Icon(IconFontIcons.refreshLine),
                            ),
                      ),
                      onTap: () {
                        ref.read(responseDataCacheSizeProvider).when(
                              (int? value) {
                                if ((value ?? 0) > 0) {
                                  ref
                                      .read(
                                        checkResponseDataCachesProvider
                                            .notifier,
                                      )
                                      .state = !ref.read(
                                    checkResponseDataCachesProvider,
                                  );
                                }
                              },
                              loading: () {},
                              error: (_, __, ___) {
                                ref
                                    .read(
                                      responseDataCacheSizeProvider.notifier,
                                    )
                                    .initData();
                              },
                            );
                      },
                    ),
                    CupertinoListTile(
                      padding: AppTheme.bodyPadding,
                      backgroundColor: context.theme.cardColor,
                      backgroundColorActivated: context
                          .theme.scaffoldBackgroundColor
                          .withOpacity(0.5),
                      leading: Consumer(
                        builder: (_, WidgetRef ref, __) {
                          final bool selected =
                              ref.watch(checkPreferencesCachesProvider);
                          final bool disabled =
                              ref.watch(disableCheckPreferencesCachesProvider);

                          return Opacity(
                            opacity: disabled ? 0.5 : 1.0,
                            child: Checkbox(
                              value: selected,
                              onChanged: (bool? result) {
                                ref.read(preferencesCacheSizeProvider).when(
                                      (int? value) {
                                        if ((value ?? 0) > 0) {
                                          ref
                                              .read(
                                                checkPreferencesCachesProvider
                                                    .notifier,
                                              )
                                              .state = result ?? false;
                                        }
                                      },
                                      loading: () {},
                                      error: (_, __, ___) {
                                        ref
                                            .read(preferencesCacheSizeProvider
                                                .notifier)
                                            .initData();
                                      },
                                    );
                              },
                            ),
                          );
                        },
                      ),
                      title: Text(S.of(context).preferencesCache),
                      subtitle: Text(S.of(context).preferencesCacheTips),
                      trailing: Consumer(
                        builder: (_, WidgetRef ref, __) => ref
                            .watch(preferencesCacheSizeProvider)
                            .when(
                              (int? value) => Text(value.fileSize),
                              loading: () => const CupertinoActivityIndicator(),
                              error: (_, __, ___) =>
                                  const Icon(IconFontIcons.refreshLine),
                            ),
                      ),
                      onTap: () {
                        ref.read(preferencesCacheSizeProvider).when(
                              (int? value) {
                                if ((value ?? 0) > 0) {
                                  ref
                                          .read(
                                            checkPreferencesCachesProvider
                                                .notifier,
                                          )
                                          .state =
                                      !ref.read(checkPreferencesCachesProvider);
                                }
                              },
                              loading: () {},
                              error: (_, __, ___) {
                                ref
                                    .read(preferencesCacheSizeProvider.notifier)
                                    .initData();
                              },
                            );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: ColoredBox(
              color: context.theme.cardColor,
              child: Padding(
                padding: AppTheme.contentPadding.copyWith(
                  bottom: AppTheme.contentPadding.bottom +
                      ScreenUtils.bottomSafeHeight,
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
                                  .state = !checkAll;
                            }
                            if (!ref.read(
                              disableCheckResponseDataCachesProvider,
                            )) {
                              ref
                                  .read(
                                    checkResponseDataCachesProvider.notifier,
                                  )
                                  .state = !checkAll;
                            }

                            if (!ref.read(
                              disableCheckPreferencesCachesProvider,
                            )) {
                              ref
                                  .read(
                                    checkPreferencesCachesProvider.notifier,
                                  )
                                  .state = !checkAll;
                            }
                          },
                          child: Text(checkAll
                              ? S.of(context).deselectAll
                              : S.of(context).selectAll),
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

                            final int otherCacheSize = ref
                                    .watch(otherCacheSizeProvider)
                                    .whenOrNull((int? value) => value) ??
                                0;
                            final int responseDataCacheSize = ref
                                    .watch(responseDataCacheSizeProvider)
                                    .whenOrNull((int? value) => value) ??
                                0;
                            final int preferencesCacheSize = ref
                                    .watch(preferencesCacheSizeProvider)
                                    .whenOrNull((int? value) => value) ??
                                0;

                            final int total = <int>[
                              0, // Prevent empty arrays from performing reduce
                              if (checkOther) otherCacheSize,
                              if (checkResponseData) responseDataCacheSize,
                              if (checkPreferences) preferencesCacheSize,
                            ].reduce((
                              int total,
                              int size,
                            ) =>
                                total += size);

                            if (total == 0) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                              S.of(context).occupies(total.fileSize),
                            );
                          },
                        ),
                        Gap(direction: GapDirection.horizontal),
                        Consumer(
                          builder: (_, WidgetRef ref, __) {
                            final bool cleanable = ref.watch(cleanableProvider);

                            return ElevatedButton(
                              onPressed: cleanable
                                  ? () {
                                      DialogUtils.confirm<void>(
                                        isDanger: true,
                                        builder: (BuildContext context) => Text(
                                          S.of(context).clearCacheWarning,
                                        ),
                                        confirmText: S.of(context).clear,
                                        confirmCallback: () async {
                                          await DatabaseManager.isar.writeTxn(
                                            () => Future.wait<void>(
                                              <Future<void>>[
                                                if (ref.read(
                                                  cleanableOtherCachesProvider,
                                                ))
                                                  ...ref
                                                      .read(
                                                        otherCacheSizeProvider
                                                            .notifier,
                                                      )
                                                      .clearTask,
                                                if (ref.read(
                                                  cleanableResponseDataCachesProvider,
                                                ))
                                                  ...ref
                                                      .read(
                                                        responseDataCacheSizeProvider
                                                            .notifier,
                                                      )
                                                      .clearTask,
                                                if (ref.read(
                                                  cleanablePreferencesCachesProvider,
                                                ))
                                                  ...ref
                                                      .read(
                                                        preferencesCacheSizeProvider
                                                            .notifier,
                                                      )
                                                      .clearTask,
                                              ],
                                            ),
                                          );

                                          _initData();
                                        },
                                      );
                                    }
                                  : null,
                              child: Text(S.of(context).clear),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
