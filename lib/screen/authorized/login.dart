import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n/generated/l10n.dart';
import '../../contacts/instances.dart';
import '../../database/hive_boxes.dart';
import '../../database/model/models.dart';
import '../../navigator/router_delegate.dart';
import '../../screen/authorized/provider/authorized_provider.dart';
import 'widget/login_text_field.dart';

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
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

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
    _passwordTextEditingController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).login),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              /// username
              SliverPadding(
                padding: _kBodyPadding,
                sliver: SliverToBoxAdapter(
                  child: LoginTextField(
                    type: LoginTextFieldType.username,
                    controller: _usernameTextEditingController,
                  ),
                ),
              ),

              /// password
              SliverPadding(
                padding: _kBodyPadding,
                sliver: SliverToBoxAdapter(
                  child: LoginTextField(
                    type: LoginTextFieldType.password,
                    controller: _passwordTextEditingController,
                  ),
                ),
              ),

              /// remember password
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: <Widget>[
                      ValueListenableBuilder<bool>(
                        valueListenable: _rememberPasswordNotifier,
                        builder: (_, bool value, __) {
                          return Checkbox(
                            value: value,
                            onChanged: (bool? value) {
                              _rememberPasswordNotifier.value = value ?? false;
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
              ),

              /// submit
              SliverPadding(
                padding: _kBodyPadding.copyWith(
                  top: 0.0,
                ),
                sliver: SliverToBoxAdapter(
                    child: Consumer(
                  builder: (_, WidgetRef ref, Widget? text) => ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final bool result = await ref
                            .read(authorizedProvider.notifier)
                            .login(
                              username: _usernameTextEditingController.text,
                              password: _passwordTextEditingController.text,
                              rememberPassword: _rememberPasswordNotifier.value,
                            );

                        if (result) {
                          AppRouterDelegate.instance.currentBeamState
                              .updateWith(isLogin: false);
                        }
                      }
                    },
                    child: text,
                  ),
                  child: Text(S.of(context).login),
                )),
              ),

              /// register
              SliverPadding(
                padding: _kBodyPadding.copyWith(
                  top: 10.0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          AppRouterDelegate.instance.currentBeamState
                              .updateWith(
                            isRegister: true,
                          );
                        },
                        child: Text(S.of(context).register),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
