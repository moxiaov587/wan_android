part of 'they.dart';

class TheyShareScreen extends ConsumerStatefulWidget {
  const TheyShareScreen({
    required this.userId,
    super.key,
  });

  final int userId;

  @override
  ConsumerState<TheyShareScreen> createState() => _TheyShareScreenState();
}

class _TheyShareScreenState extends ConsumerState<TheyShareScreen>
    with
        RefreshListViewStateMixin<TheyShareProvider, ArticleModel,
            TheyShareScreen> {
  late final TheyPointsProvider pointsProvider =
      theyPointsProvider(widget.userId);

  @override
  late final TheyShareProvider provider = theyShareProvider(widget.userId);

  @override
  PaginationDataRefreshable<ArticleModel> get refreshable => provider.future;

  @override
  Future<LoadingMoreStatus?> loadMore() =>
      ref.read(provider.notifier).loadMore();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).theyShare),
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: onScrollNotification,
          child: CustomScrollView(
            slivers: <Widget>[
              pullDownIndicator,
              SliverToBoxAdapter(
                child: Card(
                  margin: AppTheme.bodyPadding,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.borderRadius,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(height: 152.0),
                    child: Consumer(
                      builder: (_, WidgetRef ref, __) => ref
                          .watch(pointsProvider)
                          .when(
                            skipLoadingOnRefresh: false,
                            data: (UserPointsModel userPoints) => Padding(
                              padding: const EdgeInsets.all(kStyleUint4),
                              child: Stack(
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        userPoints.nickname.strictValue ??
                                            userPoints.username.strictValue ??
                                            '',
                                        style:
                                            context.theme.textTheme.titleLarge,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: context
                                              .theme.textTheme.titleLarge,
                                          children: <InlineSpan>[
                                            const TextSpan(
                                              text: 'No.',
                                            ),
                                            TextSpan(
                                              text: userPoints.rank ?? '',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        'Lv${userPoints.level}',
                                        style: context
                                            .theme.textTheme.displayLarge!
                                            .copyWith(
                                          color: context.theme.cardColor,
                                          fontStyle: FontStyle.italic,
                                          shadows: <Shadow>[
                                            Shadow(
                                              color: context.theme.textTheme
                                                  .labelSmall!.color!,
                                              offset: const Offset(
                                                5.0,
                                                5.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            error: (Object e, StackTrace s) {
                              final AppException error =
                                  AppException.create(e, s);

                              return Ink(
                                width: context.mqSize.width,
                                child: InkWell(
                                  onTap: () {
                                    ref.invalidate(pointsProvider);
                                  },
                                  child: Padding(
                                    padding: AppTheme.bodyPaddingOnlyHorizontal,
                                    child: Column(
                                      children: <Widget>[
                                        const Gap.v(value: kStyleUint4 * 2),
                                        Icon(
                                          IconFontIcons.refreshLine,
                                          color: context
                                              .theme.textTheme.bodySmall!.color,
                                          size: 36.0,
                                        ),
                                        const Gap.vn(),
                                        Text(
                                          // ignore: lines_longer_than_80_chars
                                          '${error.message ?? error.detail ?? S.of(context).unknownError}(${error.statusCode ?? -1})',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Gap.vs(),
                                        Text(S.of(context).tapToRetry),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            loading: () => Padding(
                              padding: const EdgeInsets.all(kStyleUint4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Shimmer.fromColors(
                                    baseColor: context.theme.focusColor,
                                    highlightColor: context.theme.hoverColor,
                                    child: ClipRRect(
                                      borderRadius:
                                          AppTheme.adornmentBorderRadius,
                                      child: ColoredBox(
                                        color: context.theme.focusColor,
                                        child: const SizedBox(
                                          width: 210.0,
                                          height: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap.vn(),
                                  Shimmer.fromColors(
                                    baseColor: context.theme.focusColor,
                                    highlightColor: context.theme.hoverColor,
                                    child: ClipRRect(
                                      borderRadius:
                                          AppTheme.adornmentBorderRadius,
                                      child: ColoredBox(
                                        color: context.theme.focusColor,
                                        child: const SizedBox(
                                          width: 140.0,
                                          height: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap.vn(),
                                  Shimmer.fromColors(
                                    baseColor: context.theme.focusColor,
                                    highlightColor: context.theme.hoverColor,
                                    child: ClipRRect(
                                      borderRadius:
                                          AppTheme.adornmentBorderRadius,
                                      child: ColoredBox(
                                        color: context.theme.focusColor,
                                        child: const SizedBox(
                                          width: 70.0,
                                          height: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
              Consumer(
                builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                      data: (PaginationData<ArticleModel> data) {
                        final List<ArticleModel> list = data.datas;

                        if (list.isEmpty) {
                          return const SliverFillRemaining(
                            child: EmptyWidget(),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, int index) {
                              final ArticleModel article = list[index];

                              return ArticleTile(
                                key: Key('they_share_article_${article.id}'),
                                authorTextOrShareUserTextCanOnTap: false,
                                article: article,
                              );
                            },
                            childCount: list.length,
                          ),
                        );
                      },
                      loading: loadingIndicatorBuilder,
                      error: errorIndicatorBuilder,
                    ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(bottom: context.mqPadding.bottom),
                sliver: loadMoreIndicator,
              ),
            ],
          ),
        ),
      );
}
