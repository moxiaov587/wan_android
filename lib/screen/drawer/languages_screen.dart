part of 'home_drawer.dart';

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).languages),
      ),
      body: SafeArea(
        child: ListView.separated(
          itemBuilder: (_, int index) {
            return Consumer(
              builder: (_, WidgetRef ref, __) {
                final Locale? value = LocaleNotifier.locales[index];

                final bool selected = ref.watch(
                  localeProvider.select((Locale? locale) => locale == value),
                );

                return ListTile(
                  selected: selected,
                  title: Text(
                    S.of(context).locale(value?.toString() ?? ''),
                  ),
                  trailing:
                      selected ? const Icon(IconFontIcons.checkLine) : null,
                  onTap: () {
                    ref.read(localeProvider.notifier).switchLocale(value);
                  },
                );
              },
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: LocaleNotifier.locales.length,
        ),
      ),
    );
  }
}
