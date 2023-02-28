part of 'home_screen.dart';

class ProjectTypeBottomSheet extends ConsumerStatefulWidget {
  const ProjectTypeBottomSheet({super.key});

  @override
  ConsumerState<ProjectTypeBottomSheet> createState() =>
      _ProjectTypeBottomSheetState();
}

class _ProjectTypeBottomSheetState
    extends ConsumerState<ProjectTypeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.cardColor,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              S.of(context).projectType,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.titleLarge,
            ),
          ),
          const IndentDivider.listTile(),
          Expanded(
            child: Consumer(
              builder: (_, WidgetRef ref, __) => ref
                  .watch(projectTypeProvider)
                  .when(
                    skipLoadingOnRefresh: false,
                    data: (List<ProjectTypeModel> list) => ListView.builder(
                      prototypeItem: const ListTile(),
                      itemBuilder: (_, int index) {
                        final ProjectTypeModel projectType = list[index];

                        return Consumer(
                          builder: (_, WidgetRef ref, Widget? title) {
                            final bool selected = ref.watch(
                              currentProjectTypeProvider.select(
                                (AsyncValue<ProjectTypeModel> value) =>
                                    value.whenOrNull(
                                      data: (ProjectTypeModel
                                              currentProjectType) =>
                                          currentProjectType == projectType,
                                    ) ??
                                    false,
                              ),
                            );

                            return ListTile(
                              selected: selected,
                              title: title,
                              onTap: () {
                                ref
                                    .read(currentProjectTypeProvider.notifier)
                                    .update((_) =>
                                        AsyncValue<ProjectTypeModel>.data(
                                          projectType,
                                        ));

                                Navigator.of(context).maybePop();
                              },
                            );
                          },
                          child: Text(
                            HTMLParseUtils.unescapeHTML(projectType.name) ??
                                S.of(context).unknown,
                          ),
                        );
                      },
                      itemCount: list.length,
                    ),
                    loading: () => const LoadingWidget.listView(),
                    error: (Object e, StackTrace s) =>
                        CustomErrorWidget.withViewError(
                      ViewError.create(e, s),
                      onRetry: () {
                        ref.invalidate(projectTypeProvider);
                      },
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
