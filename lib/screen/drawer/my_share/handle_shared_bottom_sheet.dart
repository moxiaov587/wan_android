part of 'my_share.dart';

class HandleSharedBottomSheet extends ConsumerStatefulWidget {
  const HandleSharedBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  _HandleSharedBottomSheetState createState() =>
      _HandleSharedBottomSheetState();
}

class _HandleSharedBottomSheetState
    extends ConsumerState<HandleSharedBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextEditingController =
      TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();

  final TextEditingController _linkTextEditingController =
      TextEditingController();

  final FocusNode _linkFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _titleFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _titleFocusNode.unfocus();
    _titleFocusNode.dispose();
    _linkTextEditingController.dispose();
    _linkFocusNode.unfocus();
    _linkFocusNode.dispose();
    super.dispose();
  }

  Future<void> onSubmitted() async {
    if (_formKey.currentState!.validate()) {
      final bool result = await ref.read(myShareArticlesProvider.notifier).add(
            title: _titleTextEditingController.text,
            link: _linkTextEditingController.text,
          );

      if (result) {
        Navigator.of(context).maybePop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: currentTheme.listTileTheme.tileColor,
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            currentTheme.textTheme.titleMedium),
                      ),
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                      child: Text(S.of(context).cancel),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            currentTheme.textTheme.titleMedium!.semiBoldWeight),
                      ),
                      onPressed: () {
                        onSubmitted();
                      },
                      child: Text(S.of(context).add),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: AppTheme.bodyPadding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Text(
                        S.of(context).addShare,
                        style: currentTheme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Gap(
                        value: 24.0,
                      ),
                      CustomTextFormField(
                        controller: _titleTextEditingController,
                        focusNode: _titleFocusNode,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: S.of(context).title,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).titleEmptyTips;
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          _linkFocusNode.requestFocus();
                        },
                      ),
                      Gap(
                        size: GapSize.big,
                      ),
                      CustomTextFormField(
                        controller: _linkTextEditingController,
                        focusNode: _linkFocusNode,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: S.of(context).link,
                        ),
                        validator: (String? value) {
                          if (value.strictValue == null) {
                            return S.of(context).linkEmptyTips;
                          }
                          if (RegExp(
                                  r'^(((ht|f)tps?):\/\/)?[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?$')
                              .hasMatch(value!)) {
                            return null;
                          } else {
                            return S.of(context).linkFormatTips;
                          }
                        },
                        onEditingComplete: () {
                          onSubmitted();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
