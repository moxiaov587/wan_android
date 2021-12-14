part of 'home.dart';

class _Project extends StatefulWidget {
  const _Project({Key? key}) : super(key: key);

  @override
  State<_Project> createState() => _ProjectState();
}

class _ProjectState extends State<_Project> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshListViewWidget<
        StateNotifierProvider<ProjectNotifier,
            RefreshListViewState<ArticleModel>>,
        ArticleModel>(
      onInitState: (Reader reader) {
        reader.call(projectTypesProvider.notifier).initData();
      },
      provider: projectArticleProvider,
      builder: (_, __, List<ArticleModel> list) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, int index) {
              return ListTile(
                title: Text(list[index].title),
              );
            },
            childCount: list.length,
          ),
        );
      },
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: _ProjectTypeSwitchDelegate(),
        ),
      ],
    );
  }
}

class _ProjectTypeSwitchDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: currentTheme.scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Ink(
              decoration: BoxDecoration(
                color: currentTheme.cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const _ProjectTypeSwitch(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 57.0;

  @override
  double get minExtent => 57.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _ProjectTypeSwitch extends ConsumerWidget {
  const _ProjectTypeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ViewState<ProjectTypeModel> state =
        ref.watch(currentProjectTypeProvider);

    return state.when(
      (ProjectTypeModel? value) => _ProjectTypeSwitchContainer(
        onTap: () {
          showModalBottomSheet<void>(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (_) => const _ProjectTypeBottomSheet(),
          );
        },
        child: Text(value!.name),
      ),
      loading: () => const _ProjectTypeSwitchContainer(
        child: LoadingWidget(
          radius: 5.0,
        ),
      ),
      error: (_, __, ___) => _ProjectTypeSwitchContainer(
        onTap: () {
          ref.read(projectTypesProvider.notifier).refresh();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[
            Icon(Icons.refresh),
            SizedBox(
              width: 5,
            ),
            Text('refresh'),
          ],
        ),
      ),
    );
  }
}

class _ProjectTypeSwitchContainer extends StatelessWidget {
  const _ProjectTypeSwitchContainer({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: child,
      ),
      onTap: onTap,
    );
  }
}

class _ProjectTypeBottomSheet extends StatefulWidget {
  const _ProjectTypeBottomSheet({Key? key}) : super(key: key);

  @override
  __ProjectTypeBottomSheetState createState() =>
      __ProjectTypeBottomSheetState();
}

class __ProjectTypeBottomSheetState extends State<_ProjectTypeBottomSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      animationController: _animationController,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onClosing: () {},
      builder: (_) {
        return SafeArea(
          child: ListViewWidget<
              StateNotifierProvider<ProjectTypeNotifier,
                  ListViewState<ProjectTypeModel>>,
              ProjectTypeModel>(
            enablePullDown: true,
            provider: projectTypesProvider,
            builder: (_, __, List<ProjectTypeModel> list) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    return Consumer(
                      builder: (_, WidgetRef ref, __) {
                        final bool selected =
                            ref.watch(projectTypeIsSelectedProvider(index));

                        return ListTile(
                          selected: selected,
                          title: Text(list[index].name),
                          onTap: () {
                            ref
                                .read(projectTypesProvider.notifier)
                                .selected(index);

                            Beamer.of(context).popRoute();
                          },
                        );
                      },
                    );
                  },
                  childCount: list.length,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
