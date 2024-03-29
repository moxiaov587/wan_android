part of 'my_collections_screen.dart';

class HandleCollectedBottomSheet extends ConsumerStatefulWidget {
  const HandleCollectedBottomSheet({
    required this.type,
    required this.collectId,
    super.key,
  }) : isArticles = type == CollectionType.article;

  final CollectionType type;
  final int? collectId;

  final bool isArticles;

  @override
  ConsumerState<HandleCollectedBottomSheet> createState() =>
      _HandleCollectedBottomSheetState();
}

class _HandleCollectedBottomSheetState
    extends ConsumerState<HandleCollectedBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusScopeNode _globalFocusNode = FocusScopeNode();

  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _linkTextEditingController =
      TextEditingController();
  late final TextEditingController _authorTextEditingController;

  late final HandleCollectedProvider provider = handleCollectedProvider(
    type: widget.type,
    id: widget.collectId,
  );

  @override
  void initState() {
    super.initState();

    if (widget.isArticles) {
      _authorTextEditingController = TextEditingController();
    }

    final CollectedCommonModel? collect = ref.read(provider);
    if (collect != null) {
      _titleTextEditingController.text = collect.title;
      _linkTextEditingController.text = collect.link;

      if (widget.isArticles) {
        _authorTextEditingController.text = collect.author ?? '';
      }
    }
  }

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _linkTextEditingController.dispose();
    if (widget.isArticles) {
      _authorTextEditingController.dispose();
    }
    _globalFocusNode
      ..unfocus()
      ..dispose();
    super.dispose();
  }

  Future<void> onSubmitted({
    required bool isEdit,
    required int? collectId,
  }) async {
    if (_formKey.currentState!.validate()) {
      bool result = false;
      switch (widget.type) {
        case CollectionType.article:
          result = isEdit
              ? await ref.read(myCollectedArticleProvider().notifier).edit(
                    collectId: collectId!,
                    title: _titleTextEditingController.text,
                    author: _authorTextEditingController.text,
                    link: _linkTextEditingController.text,
                  )
              : await ref.read(myCollectedArticleProvider().notifier).add(
                    title: _titleTextEditingController.text,
                    author: _authorTextEditingController.text,
                    link: _linkTextEditingController.text,
                  );
        case CollectionType.website:
          result = isEdit
              ? await ref.read(myCollectedWebsiteProvider.notifier).edit(
                    collectId: collectId!,
                    title: _titleTextEditingController.text,
                    link: _linkTextEditingController.text,
                  )
              : await ref.read(myCollectedWebsiteProvider.notifier).add(
                        title: _titleTextEditingController.text,
                        link: _linkTextEditingController.text,
                      ) !=
                  null;
      }

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
                  Consumer(
                    builder: (_, WidgetRef ref, __) {
                      final CollectedCommonModel? collect = ref.read(provider);

                      return TextButton(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(
                            context.theme.textTheme.titleMedium!.semiBold,
                          ),
                        ),
                        onPressed: () async {
                          await onSubmitted(
                            isEdit: collect != null,
                            collectId: collect?.id,
                          );
                        },
                        child: Text(
                          collect != null
                              ? S.of(context).save
                              : S.of(context).add,
                        ),
                      );
                    },
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
                      Consumer(
                        builder: (_, WidgetRef ref, __) => Text(
                          ref.read(provider) != null
                              ? S.of(context).editCollected(
                                    S
                                        .of(context)
                                        .collectionType(widget.type.name),
                                  )
                              : S.of(context).addCollected(
                                    S
                                        .of(context)
                                        .collectionType(widget.type.name),
                                  ),
                          style: context.theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
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
                      if (widget.isArticles)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: CustomTextFormField(
                            controller: _authorTextEditingController,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: S.of(context).author,
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).authorEmptyTips;
                              }

                              return null;
                            },
                            onEditingComplete: _globalFocusNode.nextFocus,
                          ),
                        ),
                      CustomTextFormField(
                        controller: _linkTextEditingController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: S.of(context).link,
                        ),
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
