part of 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  final TextEditingController _rePasswordTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _usernameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _rePasswordTextEditingController.dispose();
    super.dispose();
  }

  void toLogin() {
    if (!AppRouterDelegate.instance.currentBeamState.isLogin) {
      AppRouterDelegate.instance.currentBeamState.updateWith(
        isLogin: true,
      );
    }

    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).register),
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

              /// password
              SliverPadding(
                padding: _kBodyPadding,
                sliver: SliverToBoxAdapter(
                  child: LoginTextField(
                    type: LoginTextFieldType.rePassword,
                    controller: _rePasswordTextEditingController,
                  ),
                ),
              ),

              /// submit
              SliverPadding(
                padding: _kBodyPadding,
                sliver: SliverToBoxAdapter(
                    child: Consumer(
                  builder: (_, WidgetRef ref, Widget? text) => ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final bool result = await ref
                            .read(authorizedProvider.notifier)
                            .register(
                              username: _usernameTextEditingController.text,
                              password: _passwordTextEditingController.text,
                              rePassword: _rePasswordTextEditingController.text,
                            );

                        if (result) {
                          toLogin();
                        }
                      }
                    },
                    child: text,
                  ),
                  child: Text(S.of(context).register),
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
                        onPressed: toLogin,
                        child: Text(S.of(context).login),
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
