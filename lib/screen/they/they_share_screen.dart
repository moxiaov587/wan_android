part of 'they.dart';

class TheyShareScreen extends ConsumerStatefulWidget {
  const TheyShareScreen({
    super.key,
    required this.userId,
  });

  final int userId;

  @override
  ConsumerState<TheyShareScreen> createState() => _TheyShareScreenState();
}

class _TheyShareScreenState extends ConsumerState<TheyShareScreen>
    with
        AutoDisposeRefreshListViewStateMixin<
            AutoDisposeStateNotifierProvider<TheyShareNotifier,
                RefreshListViewState<ArticleModel>>,
            ArticleModel,
            TheyShareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).theyShare),
      ),
      body: SafeArea(
        child: Consumer(
          builder: (_, WidgetRef ref, __) {
            return NotificationListener<ScrollNotification>(
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
                      child: Padding(
                        padding: const EdgeInsets.all(kStyleUint4),
                        child: Consumer(
                          builder: (_, WidgetRef ref, __) {
                            final UserPointsModel? userPoints = ref
                                .watch(provider)
                                .whenOrNull<UserPointsModel?>((_, __, ___) =>
                                    ref.read(provider.notifier).userPoints);

                            return ConstrainedBox(
                              constraints: const BoxConstraints.tightFor(
                                height: 120.0,
                              ),
                              child: userPoints != null
                                  ? Stack(
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              userPoints.nickname.strictValue ??
                                                  userPoints
                                                      .username.strictValue ??
                                                  '',
                                              style: context
                                                  .theme.textTheme.titleLarge,
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
                                                    color: context
                                                        .theme
                                                        .textTheme
                                                        .labelSmall!
                                                        .color!,
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
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Shimmer.fromColors(
                                          baseColor: context.theme.focusColor,
                                          highlightColor:
                                              context.theme.hoverColor,
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
                                        Gap(),
                                        Shimmer.fromColors(
                                          baseColor: context.theme.focusColor,
                                          highlightColor:
                                              context.theme.hoverColor,
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
                                        Gap(),
                                        Shimmer.fromColors(
                                          baseColor: context.theme.focusColor,
                                          highlightColor:
                                              context.theme.hoverColor,
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
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Consumer(
                    builder: (_, WidgetRef ref, __) => ref.watch(provider).when(
                      (
                        int nextPageNum,
                        bool isLastPage,
                        List<ArticleModel> list,
                      ) {
                        if (list.isEmpty) {
                          return const SliverFillRemaining(
                            child: EmptyWidget(),
                          );
                        }

                        return LoadMoreSliverList.separator(
                          loadMoreIndicatorBuilder: loadMoreIndicatorBuilder,
                          itemBuilder: (_, int index) {
                            final ArticleModel article = list[index];

                            return ArticleTile(
                              key: Key(
                                'they_share_article_${article.id}',
                              ),
                              authorTextOrShareUserTextCanOnTap: false,
                              article: article,
                            );
                          },
                          separatorBuilder: (_, __) => const IndentDivider(),
                          itemCount: list.length,
                        );
                      },
                      loading: loadingIndicatorBuilder,
                      error: errorIndicatorBuilder,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  late final AutoDisposeStateNotifierProvider<TheyShareNotifier,
          RefreshListViewState<ArticleModel>> provider =
      theyShareProvider(widget.userId);
}
