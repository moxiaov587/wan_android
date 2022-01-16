part of 'drawer.dart';

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  String translate(BuildContext context, {required String value}) {
    switch (value) {
      case 'en':
        return S.of(context).english;
      case 'zh_CN':
        return S.of(context).chinese;
      default:
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
                final String value = LocaleNotifier.localeList[index];

                final bool selected = ref.watch(
                  localeProvider.select((Locale? locale) {
                    final String languages =
                        locale != null ? locale.languageCode : '';

                    if (languages.isEmpty) {
                      return value == languages;
                    }

                    return value.contains(languages);
                  }),
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
          itemCount: LocaleNotifier.localeList.length,
        ),
      ),
    );
  }
}
