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

    return SafeArea(
      child: ListViewWidget<
          StateNotifierProvider<ProjectTypeNotifier,
              ListViewState<ProjectTypeModel>>,
          ProjectTypeModel>(
        provider: projectTypesProvider,
        onInitState: (Reader reader) {
          reader.call(projectTypesProvider.notifier).initData();
        },
        builder: (_, __, List<ProjectTypeModel> list) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                return ListTile(
                  title: Text(list[index].name),
                );
              },
              childCount: list.length,
            ),
          );
        },
      ),
    );
  }
}
