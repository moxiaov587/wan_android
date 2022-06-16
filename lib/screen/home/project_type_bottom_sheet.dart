part of 'home_screen.dart';

class ProjectTypeBottomSheet extends StatelessWidget {
  const ProjectTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: currentTheme.cardColor,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                S.of(context).projectType,
                textAlign: TextAlign.center,
                style: currentTheme.textTheme.titleLarge,
              ),
            ),
            const Divider(),
            Expanded(
              child: ListViewWidget<
                  StateNotifierProvider<ProjectTypeNotifier,
                      ListViewState<ProjectTypeModel>>,
                  ProjectTypeModel>(
                provider: projectTypesProvider,
                builder: (_, __, List<ProjectTypeModel> list) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, int index) {
                        return Consumer(
                          builder: (_, WidgetRef ref, __) {
                            final bool selected = ref.watch(
                              projectTypesProvider.select(
                                (ListViewState<ProjectTypeModel> value) =>
                                    value.whenOrNull(
                                      (List<ProjectTypeModel> list) =>
                                          list[index].isSelected,
                                    ) ??
                                    false,
                              ),
                            );

                            return ListTile(
                              selected: selected,
                              title: Text(
                                HTMLParseUtils.parseArticleTitle(
                                      title: list[index].name,
                                    ) ??
                                    S.of(context).unknown,
                              ),
                              onTap: () {
                                ref
                                    .read(projectTypesProvider.notifier)
                                    .selected(index);

                                Navigator.of(context).maybePop();
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
            ),
          ],
        ),
      ),
    );
  }
}
