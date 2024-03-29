part of 'my_share_screen.dart';

class HandleSharedBottomSheet extends ConsumerStatefulWidget {
  const HandleSharedBottomSheet({super.key});

  @override
  ConsumerState<HandleSharedBottomSheet> createState() =>
      _HandleSharedBottomSheetState();
}

class _HandleSharedBottomSheetState
    extends ConsumerState<HandleSharedBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusScopeNode _globalFocusNode = FocusScopeNode();

  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _linkTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _linkTextEditingController.dispose();
    _globalFocusNode
      ..unfocus()
      ..dispose();
    super.dispose();
  }

  Future<void> onSubmitted() async {
    if (_formKey.currentState!.validate()) {
      final bool result = await ref.read(myShareArticleProvider().notifier).add(
            title: _titleTextEditingController.text,
            link: _linkTextEditingController.text,
          );

      if (result) {
        if (mounted) {
          await Navigator.of(context).maybePop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) => Material(
        color: context.theme.listTileTheme.tileColor,
        child: Column(
          children: <Widget>[
            Padding(
              padding: AppTheme.contentPadding.copyWith(bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                        context.theme.textTheme.titleMedium,
                      ),
                    ),
                    onPressed: Navigator.of(context).maybePop,
                    child: Text(S.of(context).cancel),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                        context.theme.textTheme.titleMedium!.semiBold,
                      ),
                    ),
                    onPressed: onSubmitted,
                    child: Text(S.of(context).add),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppTheme.bodyPadding,
              child: Form(
                key: _formKey,
                child: FocusScope(
                  node: _globalFocusNode,
                  child: Column(
                    children: <Widget>[
                      Text(
                        S.of(context).addShare,
                        style: context.theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const Gap.v(value: kStyleUint3 * 2),
                      CustomTextFormField(
                        controller: _titleTextEditingController,
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        decoration:
                            InputDecoration(labelText: S.of(context).title),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).titleEmptyTips;
                          }

                          return null;
                        },
                        onEditingComplete: _globalFocusNode.nextFocus,
                      ),
                      const Gap.vb(),
                      CustomTextFormField(
                        controller: _linkTextEditingController,
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
                        onEditingComplete: _globalFocusNode.nextFocus,
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
