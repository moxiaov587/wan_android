part of 'they.dart';

class TheyShareScreen extends StatefulWidget {
  const TheyShareScreen({
    super.key,
    required this.userId,
  });

  final int userId;

  @override
  _TheyShareScreenState createState() => _TheyShareScreenState();
}

class _TheyShareScreenState extends State<TheyShareScreen> {
  late AutoDisposeStateNotifierProvider<TheyShareNotifier,
          RefreshListViewState<ArticleModel>> provider =
      theyShareProvider(widget.userId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).theyShare),
      ),
      body: SafeArea(
        child: AutoDisposeRefreshListViewWidget<
            AutoDisposeStateNotifierProvider<TheyShareNotifier,
                RefreshListViewState<ArticleModel>>,
            ArticleModel>(
          provider: provider,
          onInitState: (Reader reader) {
            reader.call(provider.notifier).initData();
          },
          builder: (_, __, List<ArticleModel> list) {
            return SliverList(
              delegate: CustomSliverChildBuilderDelegate.separated(
                itemBuilder: (_, int index) {
                  return ArticleTile(
                    key: ValueKey<String>(
                      'they_share_article_${list[index].id}',
                    ),
                    authorTextOrShareUserTextCanOnTap: false,
                    article: list[index],
                  );
                },
                itemCount: list.length,
              ),
            );
          },
          slivers: <Widget>[
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
                      final UserPointsModel? userPoints =
                          ref.watch(provider.notifier).userPoints;

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
                                            userPoints.username.strictValue ??
                                            '',
                                        style:
                                            currentTheme.textTheme.titleLarge,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style:
                                              currentTheme.textTheme.titleLarge,
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
                                        style: currentTheme
                                            .textTheme.displayLarge!
                                            .copyWith(
                                          color: currentTheme.cardColor,
                                          fontStyle: FontStyle.italic,
                                          shadows: <Shadow>[
                                            Shadow(
                                              color: currentTheme
                                                  .textTheme.labelSmall!.color!,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Shimmer.fromColors(
                                    baseColor: currentTheme.focusColor,
                                    highlightColor: currentTheme.hoverColor,
                                    child: ClipRRect(
                                      borderRadius:
                                          AppTheme.adornmentBorderRadius,
                                      child: ColoredBox(
                                        color: currentTheme.focusColor,
                                        child: const SizedBox(
                                          width: 210.0,
                                          height: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(),
                                  Shimmer.fromColors(
                                    baseColor: currentTheme.focusColor,
                                    highlightColor: currentTheme.hoverColor,
                                    child: ClipRRect(
                                      borderRadius:
                                          AppTheme.adornmentBorderRadius,
                                      child: ColoredBox(
                                        color: currentTheme.focusColor,
                                        child: const SizedBox(
                                          width: 140.0,
                                          height: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gap(),
                                  Shimmer.fromColors(
                                    baseColor: currentTheme.focusColor,
                                    highlightColor: currentTheme.hoverColor,
                                    child: ClipRRect(
                                      borderRadius:
                                          AppTheme.adornmentBorderRadius,
                                      child: ColoredBox(
                                        color: currentTheme.focusColor,
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
          ],
        ),
      ),
    );
  }
}
