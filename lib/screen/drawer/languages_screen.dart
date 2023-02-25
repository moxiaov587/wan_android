part of 'home_drawer.dart';

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).languages),
      ),
      body: ListView.separated(
        itemBuilder: (_, int index) {
          return Consumer(
            builder: (_, WidgetRef ref, __) {
              final Language? value = AppLanguage.languages[index];

              final bool selected = ref.watch(
                appLanguageProvider
                    .select((Language? language) => language == value),
              );

              return ListTile(
                selected: selected,
                title: Text(S.of(context).locale(value?.name ?? '')),
                trailing: selected ? const Icon(IconFontIcons.checkLine) : null,
                onTap: () {
                  ref.read(appLanguageProvider.notifier).switchLocale(value);
                },
              );
            },
          );
        },
        separatorBuilder: (_, __) => const IndentDivider.listTile(),
        itemCount: AppLanguage.languages.length,
      ),
    );
  }
}
