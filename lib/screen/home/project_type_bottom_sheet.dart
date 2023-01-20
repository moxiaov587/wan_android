part of 'home_screen.dart';

class ProjectTypeBottomSheet extends ConsumerStatefulWidget {
  const ProjectTypeBottomSheet({super.key});

  @override
  ConsumerState<ProjectTypeBottomSheet> createState() =>
      _ProjectTypeBottomSheetState();
}

class _ProjectTypeBottomSheetState extends ConsumerState<ProjectTypeBottomSheet>
    with
        ListViewStateMixin<
            StateNotifierProvider<ProjectTypeNotifier,
                ListViewState<ProjectTypeModel>>,
            ProjectTypeModel,
            ProjectTypeBottomSheet> {
  @override
  final bool autoInitData = false;

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
          const Divider(),
          Expanded(
            child: Consumer(
              builder: (_, WidgetRef ref, __) {
                return ref.watch(provider).when(
                      (List<ProjectTypeModel> list) => ListView.builder(
                        prototypeItem: const ListTile(),
                        itemBuilder: (_, int index) {
                          final ProjectTypeModel projectType = list[index];

                          return Consumer(
                            builder: (_, WidgetRef ref, Widget? title) {
                              final bool selected = ref.watch(
                                currentProjectTypeProvider.select(
                                  (ViewState<ProjectTypeModel> value) =>
                                      value.whenOrNull(
                                        (ProjectTypeModel?
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
                                      .read(
                                        currentProjectTypeProvider.notifier,
                                      )
                                      .selected(projectType);

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
                      loading: loadingIndicatorBuilder,
                      error: errorIndicatorBuilder,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  StateNotifierProvider<ProjectTypeNotifier, ListViewState<ProjectTypeModel>>
      get provider => projectTypesProvider;
}
