part of 'home_drawer.dart';

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({super.key});

  String translate(BuildContext context, {required Locale? value}) {
    if (value == const Locale('en')) {
      return S.of(context).english;
    } else if (value == const Locale('zh', 'CN')) {
      return S.of(context).chinese;
    } else {
      return S.of(context).auto;
    }
  }

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
                    translate(
                      context,
                      value: value,
                    ),
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
