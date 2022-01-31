import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n/generated/l10n.dart';
import '../../contacts/icon_font_icons.dart';
import '../../contacts/instances.dart';
import '../../database/hive_boxes.dart';
import '../../database/model/models.dart';
import '../../navigator/router_delegate.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import '../../widget/custom_text_form_field.dart';
import '../../widget/gap.dart';

part 'register.dart';

const EdgeInsets _kBodyPadding = EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 0.0);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with RouteAware {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  late final ValueNotifier<bool> _rememberPasswordNotifier =
      ValueNotifier<bool>(rememberPassword);

  bool get rememberPassword =>
      HiveBoxes.uniqueUserSettings?.rememberPassword ?? false;

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
    try {
      final AuthorizedCache authorizedCache =
          HiveBoxes.authorizedCacheBox.values.first;

      _usernameTextEditingController.text = authorizedCache.username;

      if (rememberPassword) {
        _passwordTextEditingController.text = authorizedCache.password!;
      }
    } catch (_) {}
  }

  Future<void> onSubmitted({
    required Reader reader,
  }) async {
    if (_formKey.currentState!.validate()) {
      final bool result = await reader.call(authorizedProvider.notifier).login(
            username: _usernameTextEditingController.text,
            password: _passwordTextEditingController.text,
            rememberPassword: _rememberPasswordNotifier.value,
          );

      if (result) {
        AppRouterDelegate.instance.currentBeamState.updateWith(isLogin: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: _kBodyPadding,
              sliver: Form(
                key: _formKey,
                child: SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      CustomTextFormField(
                        controller: _usernameTextEditingController,
                        focusNode: _usernameFocusNode,
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
                            onSubmitted(reader: ref.read);
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
                              style: currentTheme.textTheme.bodyLarge,
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
                            onSubmitted(reader: ref.read);
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
                            AppRouterDelegate.instance.currentBeamState
                                .updateWith(
                              isRegister: true,
                            );
                          },
                          child: Text(S.of(context).register),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
