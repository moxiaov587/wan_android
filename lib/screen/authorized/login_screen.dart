import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n/generated/l10n.dart';
import '../../app/theme/app_theme.dart';
import '../../contacts/icon_font_icons.dart';
import '../../contacts/instances.dart';
import '../../database/app_database.dart';
import '../../extensions/extensions.dart' show BuildContextExtension;
import '../../router/data/app_routes.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import '../../widget/custom_text_form_field.dart';
import '../../widget/gap.dart';

part 'register_screen.dart';

const EdgeInsets _kBodyPadding = EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 0.0);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with RouteAware {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  AccountCache? _lastLoginAccountCache;

  late final ValueNotifier<bool> _rememberPasswordNotifier =
      ValueNotifier<bool>(rememberPassword);

  Isar get isar => ref.read(appDatabaseProvider);

  bool get rememberPassword =>
      isar.uniqueUserSettings?.rememberPassword ?? false;

  @override
  void initState() {
    super.initState();

    initTextEditingDefaultValue();
  }

  @override
  void didPopNext() {
    super.didPopNext();

    initTextEditingDefaultValue();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Instances.routeObserver.subscribe(this, ModalRoute.of<dynamic>(context)!);
  }

  @override
  void dispose() {
    _usernameTextEditingController.dispose();
    _usernameFocusNode.unfocus();
    _usernameFocusNode.dispose();
    _passwordTextEditingController.dispose();
    _passwordFocusNode.unfocus();
    _passwordFocusNode.dispose();
    _rememberPasswordNotifier.dispose();
    Instances.routeObserver.unsubscribe(this);

    super.dispose();
  }

  void initTextEditingDefaultValue() {
    _lastLoginAccountCache =
        isar.accountCaches.where().sortByUpdateTimeDesc().findFirstSync();

    if (_lastLoginAccountCache != null) {
      _usernameTextEditingController.text = _lastLoginAccountCache!.username;

      if (rememberPassword && _lastLoginAccountCache!.password != null) {
        _passwordTextEditingController.text = ref
            .read(authorizedProvider.notifier)
            .decryptString(_lastLoginAccountCache!.password!);
      }
    }
  }

  Future<void> onSubmitted({
    required WidgetRef ref,
  }) async {
    final GoRouter goRouter = GoRouter.of(context);

    if (_formKey.currentState!.validate()) {
      final bool result = await ref.read(authorizedProvider.notifier).login(
            username: _usernameTextEditingController.text,
            password: _passwordTextEditingController.text,
            rememberPassword: _rememberPasswordNotifier.value,
          );

      if (result) {
        goRouter.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: _kBodyPadding,
            sliver: Form(
              key: _formKey,
              child: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    RawAutocomplete<AccountCache>(
                      textEditingController: _usernameTextEditingController,
                      focusNode: _usernameFocusNode,
                      displayStringForOption: (AccountCache option) =>
                          option.username,
                      onSelected: (AccountCache option) {
                        if (option.password != null) {
                          _passwordTextEditingController.text = ref
                              .read(authorizedProvider.notifier)
                              .decryptString(option.password!);
                        }
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) =>
                          isar.accountCaches
                              .filter()
                              .usernameStartsWith(textEditingValue.text)
                              .sortByUpdateTimeDesc()
                              .findAll(),
                      optionsViewBuilder: (
                        BuildContext context,
                        void Function(AccountCache) onSelected,
                        Iterable<AccountCache> options,
                      ) =>
                          _AccountOptionsView(
                        onSelected: onSelected,
                        options: options,
                        lastLoginAccount: _lastLoginAccountCache,
                      ),
                      fieldViewBuilder: (
                        _,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        __,
                      ) =>
                          CustomTextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).usernameEmptyTips;
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(IconFontIcons.accountCircleLine),
                          hintText: S.of(context).username,
                        ),
                        onEditingComplete: () {
                          _passwordFocusNode.requestFocus();
                        },
                      ),
                    ),
                    Gap(
                      value: _kBodyPadding.top,
                    ),
                    Consumer(
                      builder: (_, WidgetRef ref, __) => CustomTextFormField(
                        controller: _passwordTextEditingController,
                        focusNode: _passwordFocusNode,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).passwordEmptyTips;
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(IconFontIcons.lockLine),
                          hintText: S.of(context).password,
                        ),
                        onEditingComplete: () {
                          _passwordFocusNode.unfocus();
                        },
                      ),
                    ),
                    Gap(
                      value: _kBodyPadding.top / 4,
                    ),
                    Transform.translate(
                      offset: const Offset(-10.0, 0.0),
                      child: Row(
                        children: <Widget>[
                          ValueListenableBuilder<bool>(
                            valueListenable: _rememberPasswordNotifier,
                            builder: (_, bool value, __) {
                              return Checkbox(
                                value: value,
                                onChanged: (bool? value) {
                                  _rememberPasswordNotifier.value =
                                      value ?? false;
                                },
                              );
                            },
                          ),
                          Text(
                            S.of(context).rememberPassword,
                            style: context.theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Gap(
                      value: _kBodyPadding.top / 4,
                    ),
                    Consumer(
                      builder: (_, WidgetRef ref, Widget? text) =>
                          ElevatedButton(
                        onPressed: () async {
                          onSubmitted(ref: ref);
                        },
                        child: text,
                      ),
                      child: Text(S.of(context).login),
                    ),
                    Gap(
                      value: _kBodyPadding.top / 4,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          const RegisterRoute(fromLogin: true).push(context);
                        },
                        child: Text(
                          S.of(context).register,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountOptionsView extends StatelessWidget {
  const _AccountOptionsView({
    required this.onSelected,
    required this.options,
    required this.lastLoginAccount,
  });

  final void Function(AccountCache) onSelected;
  final Iterable<AccountCache> options;
  final AccountCache? lastLoginAccount;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: kStyleUint,
          right: _kBodyPadding.horizontal,
        ),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.adornmentBorderRadius,
          ),
          color: context.theme.dialogBackgroundColor,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200,
            ),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (_, int index) {
                final AccountCache option = options.elementAt(index);

                final Widget child = Padding(
                  padding: AppTheme.bodyPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          option.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lastLoginAccount?.username != null &&
                          option.username == lastLoginAccount!.username)
                        Padding(
                          padding: EdgeInsets.only(
                            left: AppTheme.bodyPadding.left,
                          ),
                          child: Text(
                            S.of(context).lastLogin,
                            style: context.theme.textTheme.labelMedium,
                          ),
                        ),
                    ],
                  ),
                );

                switch (context.theme.platform) {
                  case TargetPlatform.android:
                  case TargetPlatform.iOS:
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: DefaultTextStyle(
                        style: context.theme.textTheme.titleSmall!,
                        child: child,
                      ),
                    );
                  case TargetPlatform.fuchsia:
                  case TargetPlatform.linux:
                  case TargetPlatform.macOS:
                  case TargetPlatform.windows:
                    return InkWell(
                      onTap: () {
                        onSelected(option);
                      },
                      child: Builder(
                        builder: (BuildContext context) {
                          final bool highlight =
                              AutocompleteHighlightedOption.of(
                                    context,
                                  ) ==
                                  index;
                          if (highlight) {
                            SchedulerBinding.instance.addPostFrameCallback(
                              (Duration timeStamp) {
                                Scrollable.ensureVisible(
                                  context,
                                  alignment: 0.5,
                                );
                              },
                            );
                          }

                          return DefaultTextStyle(
                            style: context.theme.textTheme.titleSmall!.copyWith(
                              color:
                                  highlight ? context.theme.primaryColor : null,
                            ),
                            child: child,
                          );
                        },
                      ),
                    );
                }
              },
              separatorBuilder: (_, __) => const Divider(),
            ),
          ),
        ),
      ),
    );
  }
}
