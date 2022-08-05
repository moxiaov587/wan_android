part of 'home_screen.dart';

class ProjectTypeBottomSheet extends StatelessWidget {
  const ProjectTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
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
              child: ListViewWidget<
                  StateNotifierProvider<ProjectTypeNotifier,
                      ListViewState<ProjectTypeModel>>,
                  ProjectTypeModel>(
                provider: projectTypesProvider,
                itemBuilder: (_, __, int index, ProjectTypeModel projectType) {
                  return Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final bool selected = ref.watch(
                        currentProjectTypeProvider.select(
                          (ViewState<ProjectTypeModel> value) =>
                              value.whenOrNull(
                                (ProjectTypeModel? currentProjectType) =>
                                    currentProjectType == projectType,
                              ) ??
                              false,
                        ),
                      );

                      return ListTile(
                        selected: selected,
                        title: Text(
                          HTMLParseUtils.unescapeHTML(projectType.name) ??
                              S.of(context).unknown,
                        ),
                        onTap: () {
                          ref
                              .read(currentProjectTypeProvider.notifier)
                              .selected(projectType);

                          Navigator.of(context).maybePop();
                        },
                      );
                    },
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
