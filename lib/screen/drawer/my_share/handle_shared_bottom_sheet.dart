part of 'my_share_screen.dart';

class HandleSharedBottomSheet extends ConsumerStatefulWidget {
  const HandleSharedBottomSheet({super.key});

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
        if (mounted) {
          Navigator.of(context).maybePop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.listTileTheme.tileColor,
      child: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: AppTheme.contentPadding.copyWith(bottom: 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          context.theme.textTheme.titleMedium,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).maybePop();
                      },
                      child: Text(S.of(context).cancel),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          context.theme.textTheme.titleMedium!.semiBold,
                        ),
                      ),
                      onPressed: () {
                        onSubmitted();
                      },
                      child: Text(S.of(context).add),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: AppTheme.bodyPadding,
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Text(
                      S.of(context).addShare,
                      style: context.theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const Gap.v(value: kStyleUint3 * 2),
                    CustomTextFormField(
                      controller: _titleTextEditingController,
                      focusNode: _titleFocusNode,
                      textInputAction: TextInputAction.next,
                      decoration:
                          InputDecoration(labelText: S.of(context).title),
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
                    const Gap.vb(),
                    CustomTextFormField(
                      controller: _linkTextEditingController,
                      focusNode: _linkFocusNode,
                      textInputAction: TextInputAction.done,
                      decoration:
                          InputDecoration(labelText: S.of(context).link),
                      validator: (String? value) {
                        if (value.strictValue == null) {
                          return S.of(context).linkEmptyTips;
                        }

                        return RegExp(
                          r'^(((ht|f)tps?):\/\/)?[\w-]+(\.[\w-]+)+([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?$',
                        ).hasMatch(value!)
                            ? null
                            : S.of(context).linkFormatTips;
                      },
                      onEditingComplete: () {
                        _linkFocusNode.unfocus();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
