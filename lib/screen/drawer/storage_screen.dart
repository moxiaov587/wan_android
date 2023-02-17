part of 'home_drawer.dart';

class StorageScreen extends ConsumerStatefulWidget {
  const StorageScreen({super.key});

  @override
  ConsumerState<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends ConsumerState<StorageScreen> {
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
                        builder: (_, WidgetRef ref, Widget? child) {
                          final bool disabled =
                              ref.watch(disableCheckOtherCachesProvider);

                          return Opacity(
                            opacity: disabled ? 0.5 : 1.0,
                            child: child,
                          );
                        },
                        child: Consumer(builder: (_, WidgetRef ref, __) {
                          final bool selected =
                              ref.watch(checkOtherCachesProvider);

                          return Checkbox(
                            value: selected,
                            onChanged: (bool? result) {
                              ref.read(otherCacheSizeProvider).when(
                                    data: (int data) {
                                      if (data > 0) {
                                        ref
                                            .read(
                                              checkOtherCachesProvider.notifier,
                                            )
                                            .update((_) => result ?? false);
                                      }
                                    },
                                    loading: () {},
                                    error: (_, __) {
                                      ref.invalidate(
                                        otherCacheSizeProvider,
                                      );
                                    },
                                  );
                            },
                          );
                        }),
                      ),
                      title: Text(S.of(context).otherCache),
                      subtitle: Text(S.of(context).otherCacheTips),
                      trailing: Consumer(
                        builder: (_, WidgetRef ref, __) => ref
                            .watch(otherCacheSizeProvider)
                            .when(
                              data: (int data) => Text(data.fileSize),
                              loading: () => const CupertinoActivityIndicator(),
                              error: (_, __) =>
                                  const Icon(IconFontIcons.refreshLine),
                            ),
                      ),
                      onTap: () {
                        ref.read(otherCacheSizeProvider).when(
                              data: (int data) {
                                if (data > 0) {
                                  ref
                                      .read(
                                        checkOtherCachesProvider.notifier,
                                      )
                                      .update((bool state) => !state);
                                }
                              },
                              loading: () {},
                              error: (_, __) {
                                ref.invalidate(otherCacheSizeProvider);
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
                        builder: (_, WidgetRef ref, Widget? child) {
                          final bool disabled =
                              ref.watch(disableCheckResponseDataCachesProvider);

                          return Opacity(
                            opacity: disabled ? 0.5 : 1.0,
                            child: child,
                          );
                        },
                        child: Consumer(builder: (_, WidgetRef ref, __) {
                          final bool selected =
                              ref.watch(checkResponseDataCachesProvider);

                          return Checkbox(
                            value: selected,
                            onChanged: (bool? result) {
                              ref.read(responseDataCacheSizeProvider).when(
                                    data: (int data) {
                                      if (data > 0) {
                                        ref
                                            .read(
                                              checkResponseDataCachesProvider
                                                  .notifier,
                                            )
                                            .update((_) => result ?? false);
                                      }
                                    },
                                    loading: () {},
                                    error: (_, __) {
                                      ref.invalidate(
                                        responseDataCacheSizeProvider,
                                      );
                                    },
                                  );
                            },
                          );
                        }),
                      ),
                      title: Text(S.of(context).responseDataCache),
                      subtitle: Text(S.of(context).responseDataCacheTips),
                      trailing: Consumer(
                        builder: (_, WidgetRef ref, __) => ref
                            .watch(responseDataCacheSizeProvider)
                            .when(
                              data: (int? value) => Text(value.fileSize),
                              loading: () => const CupertinoActivityIndicator(),
                              error: (_, __) =>
                                  const Icon(IconFontIcons.refreshLine),
                            ),
                      ),
                      onTap: () {
                        ref.read(responseDataCacheSizeProvider).when(
                              data: (int data) {
                                if (data > 0) {
                                  ref
                                      .read(
                                        checkResponseDataCachesProvider
                                            .notifier,
                                      )
                                      .update((bool state) => !state);
                                }
                              },
                              loading: () {},
                              error: (_, __) {
                                ref.invalidate(responseDataCacheSizeProvider);
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
                        builder: (_, WidgetRef ref, Widget? child) {
                          final bool disabled =
                              ref.watch(disableCheckPreferencesCachesProvider);

                          return Opacity(
                            opacity: disabled ? 0.5 : 1.0,
                            child: child,
                          );
                        },
                        child: Consumer(
                          builder: (_, WidgetRef ref, __) {
                            final bool selected =
                                ref.watch(checkPreferencesCachesProvider);

                            return Checkbox(
                              value: selected,
                              onChanged: (bool? result) {
                                ref.read(preferencesCacheSizeProvider).when(
                                      data: (int data) {
                                        if (data > 0) {
                                          ref
                                              .read(
                                                checkPreferencesCachesProvider
                                                    .notifier,
                                              )
                                              .update((_) => result ?? false);
                                        }
                                      },
                                      loading: () {},
                                      error: (_, __) {
                                        ref.invalidate(
                                          preferencesCacheSizeProvider,
                                        );
                                      },
                                    );
                              },
                            );
                          },
                        ),
                      ),
                      title: Text(S.of(context).preferencesCache),
                      subtitle: Text(S.of(context).preferencesCacheTips),
                      trailing: Consumer(
                        builder: (_, WidgetRef ref, __) => ref
                            .watch(preferencesCacheSizeProvider)
                            .when(
                              data: (int data) => Text(data.fileSize),
                              loading: () => const CupertinoActivityIndicator(),
                              error: (_, __) =>
                                  const Icon(IconFontIcons.refreshLine),
                            ),
                      ),
                      onTap: () {
                        ref.read(preferencesCacheSizeProvider).when(
                              data: (int data) {
                                if (data > 0) {
                                  ref
                                      .read(
                                        checkPreferencesCachesProvider.notifier,
                                      )
                                      .update((bool state) => !state);
                                }
                              },
                              loading: () {},
                              error: (_, __) {
                                ref.invalidate(preferencesCacheSizeProvider);
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
                                  .update((_) => !checkAll);
                            }
                            if (!ref.read(
                              disableCheckResponseDataCachesProvider,
                            )) {
                              ref
                                  .read(
                                    checkResponseDataCachesProvider.notifier,
                                  )
                                  .update((_) => !checkAll);
                            }

                            if (!ref.read(
                              disableCheckPreferencesCachesProvider,
                            )) {
                              ref
                                  .read(
                                    checkPreferencesCachesProvider.notifier,
                                  )
                                  .update((_) => !checkAll);
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
                                    .whenOrNull(data: (int data) => data) ??
                                0;
                            final int responseDataCacheSize = ref
                                    .watch(responseDataCacheSizeProvider)
                                    .whenOrNull(data: (int data) => data) ??
                                0;
                            final int preferencesCacheSize = ref
                                    .watch(preferencesCacheSizeProvider)
                                    .whenOrNull(data: (int data) => data) ??
                                0;

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
                                          await ref
                                              .read(appDatabaseProvider)
                                              .writeTxn(
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

                                          ref.invalidate(
                                            otherCacheSizeProvider,
                                          );
                                          ref.invalidate(
                                            responseDataCacheSizeProvider,
                                          );
                                          ref.invalidate(
                                            preferencesCacheSizeProvider,
                                          );
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
