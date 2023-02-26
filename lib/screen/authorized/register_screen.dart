part of 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.fromLogin});

  final bool fromLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _repasswordTextEditingController =
      TextEditingController();
  final FocusNode _repasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameTextEditingController.dispose();
    _usernameFocusNode.unfocus();
    _usernameFocusNode.dispose();
    _passwordTextEditingController.dispose();
    _passwordFocusNode.unfocus();
    _passwordFocusNode.dispose();
    _repasswordTextEditingController.dispose();
    _repasswordFocusNode.unfocus();
    _repasswordFocusNode.dispose();
    super.dispose();
  }

  void toLogin() {
    if (widget.fromLogin) {
      GoRouter.of(context).pop();
    } else {
      GoRouter.of(context).pushReplacement(const LoginRoute().location);
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
        toLogin();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).register),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          Form(
            key: _formKey,
            child: SliverPadding(
              padding: _kBodyPadding,
              sliver: SliverList(
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
                        prefixIcon: const Icon(IconFontIcons.accountCircleLine),
                        hintText: S.of(context).username,
                      ),
                      onEditingComplete: () {
                        _passwordFocusNode.requestFocus();
                      },
                    ),
                    Gap.v(value: _kBodyPadding.top),
                    CustomTextFormField(
                      controller: _passwordTextEditingController,
                      focusNode: _passwordFocusNode,
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
                      onEditingComplete: () {
                        _repasswordFocusNode.requestFocus();
                      },
                    ),
                    Gap.v(value: _kBodyPadding.top),
                    Consumer(
                      builder: (_, WidgetRef ref, __) => CustomTextFormField(
                        controller: _repasswordTextEditingController,
                        focusNode: _repasswordFocusNode,
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
                        onEditingComplete: () {
                          _repasswordFocusNode.unfocus();
                        },
                      ),
                    ),
                    Gap.v(value: _kBodyPadding.top),
                    Consumer(
                      builder: (_, WidgetRef ref, Widget? text) =>
                          ElevatedButton(
                        onPressed: () {
                          onSubmitted(ref: ref);
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
        ],
      ),
    );
  }
}
