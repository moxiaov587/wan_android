part of 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({required this.fromLogin, super.key});

  final bool fromLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusScopeNode _globalFocusNode = FocusScopeNode();

  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _repasswordTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _usernameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _repasswordTextEditingController.dispose();
    _globalFocusNode
      ..unfocus()
      ..dispose();
    super.dispose();
  }

  void toLogin({bool result = false}) {
    if (widget.fromLogin) {
      GoRouter.of(context).pop<bool>(result);
    } else {
      unawaited(
        GoRouter.of(context).pushReplacement(const LoginRoute().location),
      );
    }
  }

  Future<void> onSubmitted({
    required WidgetRef ref,
  }) async {
    if (_formKey.currentState!.validate()) {
      final bool result = await ref.read(authorizedProvider.notifier).register(
            username: _usernameTextEditingController.text,
            password: _passwordTextEditingController.text,
            repassword: _repasswordTextEditingController.text,
          );

      if (result) {
        toLogin(result: result);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).register),
        ),
        body: SizedBox.expand(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: _kBodyPadding,
              child: Form(
                key: _formKey,
                child: FocusScope(
                  node: _globalFocusNode,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CustomTextFormField(
                        controller: _usernameTextEditingController,
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
                        onEditingComplete: _globalFocusNode.nextFocus,
                      ),
                      Gap.v(value: _kBodyPadding.top),
                      CustomTextFormField(
                        controller: _passwordTextEditingController,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
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
                        onEditingComplete: _globalFocusNode.nextFocus,
                      ),
                      Gap.v(value: _kBodyPadding.top),
                      Consumer(
                        builder: (_, WidgetRef ref, __) => CustomTextFormField(
                          controller: _repasswordTextEditingController,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).repasswordEmptyTips;
                            } else if (value !=
                                _passwordTextEditingController.text) {
                              return S
                                  .of(context)
                                  .passwordAndRepasswordNotTheSameTips;
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(IconFontIcons.lockLine),
                            hintText: S.of(context).repassword,
                          ),
                          onEditingComplete: _globalFocusNode.nextFocus,
                        ),
                      ),
                      Gap.v(value: _kBodyPadding.top),
                      Consumer(
                        builder: (_, WidgetRef ref, Widget? text) =>
                            ElevatedButton(
                          onPressed: () async {
                            await onSubmitted(ref: ref);
                          },
                          child: text,
                        ),
                        child: Text(S.of(context).register),
                      ),
                      Gap.v(value: _kBodyPadding.top / 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: toLogin,
                          child: Text(S.of(context).login),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
