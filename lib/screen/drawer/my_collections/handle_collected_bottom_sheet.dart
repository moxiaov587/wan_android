part of 'my_collections_screen.dart';

class HandleCollectedBottomSheet extends ConsumerStatefulWidget {
  const HandleCollectedBottomSheet({
    super.key,
    required this.type,
    required this.collectId,
  }) : isArticles = type == CollectionType.article;

  final CollectionType type;
  final int? collectId;

  final bool isArticles;

  @override
  _HandleCollectedBottomSheetState createState() =>
      _HandleCollectedBottomSheetState();
}

class _HandleCollectedBottomSheetState
    extends ConsumerState<HandleCollectedBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextEditingController =
      TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();

  final TextEditingController _linkTextEditingController =
      TextEditingController();

  final FocusNode _linkFocusNode = FocusNode();

  late final TextEditingController _authorTextEditingController;

  late final FocusNode _authorFocusNode;

  late AutoDisposeStateNotifierProvider<CollectedNotifier,
      ViewState<CollectedCommonModel>> provider = collectedModelProvider(
    CollectionTypeModel(
      type: widget.type,
      id: widget.collectId,
    ),
  );

  @override
  void initState() {
    super.initState();

    if (widget.isArticles) {
      _authorTextEditingController = TextEditingController();
      _authorFocusNode = FocusNode();
    }

    initData();
  }

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _titleFocusNode.unfocus();
    _titleFocusNode.dispose();
    _linkTextEditingController.dispose();
    _linkFocusNode.unfocus();
    _linkFocusNode.dispose();
    if (widget.isArticles) {
      _authorTextEditingController.dispose();
      _authorFocusNode.unfocus();
      _authorFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> initData() async {
    await ref.read(provider.notifier).initData();

    ref.read(provider).whenOrNull((CollectedCommonModel? collect) {
      if (collect != null) {
        _titleTextEditingController.text = collect.title;
        _linkTextEditingController.text = collect.link;

        if (widget.isArticles) {
          _authorTextEditingController.text = collect.author ?? '';
        }
      }
    });

    _titleFocusNode.requestFocus();
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
              ? await ref.read(myCollectedArticleProvider.notifier).update(
                    collectId: collectId!,
                    title: _titleTextEditingController.text,
                    author: _authorTextEditingController.text,
                    link: _linkTextEditingController.text,
                  )
              : await ref.read(myCollectedArticleProvider.notifier).add(
                    title: _titleTextEditingController.text,
                    author: _authorTextEditingController.text,
                    link: _linkTextEditingController.text,
                  );
          break;
        case CollectionType.website:
          result = isEdit
              ? await ref.read(myCollectedWebsiteProvider.notifier).update(
                    collectId: collectId!,
                    title: _titleTextEditingController.text,
                    link: _linkTextEditingController.text,
                  )
              : await ref.read(myCollectedWebsiteProvider.notifier).add(
                        title: _titleTextEditingController.text,
                        link: _linkTextEditingController.text,
                      ) !=
                  null;
          break;
      }

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
      child: SafeArea(
        child: ref.watch(provider).when(
              (CollectedCommonModel? collect) => Form(
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
                              textStyle: MaterialStateProperty.all(context
                                  .theme.textTheme.titleMedium!.semiBoldWeight),
                            ),
                            onPressed: () {
                              onSubmitted(
                                isEdit: collect != null,
                                collectId: collect?.id,
                              );
                            },
                            child: Text(collect != null
                                ? S.of(context).save
                                : S.of(context).add),
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
                              collect != null
                                  ? S.of(context).editCollected(S
                                      .of(context)
                                      .myCollectionsTabs(widget.type.name))
                                  : S.of(context).addCollected(S
                                      .of(context)
                                      .myCollectionsTabs(widget.type.name)),
                              style: context.theme.textTheme.titleLarge,
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
                                if (widget.isArticles) {
                                  _authorFocusNode.requestFocus();
                                } else {
                                  _linkFocusNode.requestFocus();
                                }
                              },
                            ),
                            Gap(
                              size: GapSize.big,
                            ),
                            if (widget.isArticles)
                              CustomTextFormField(
                                controller: _authorTextEditingController,
                                focusNode: _authorFocusNode,
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
                                onEditingComplete: () {
                                  _linkFocusNode.requestFocus();
                                },
                              ),
                            if (widget.isArticles)
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
              loading: () => const LoadingWidget(),
              error: (int? statusCode, String? message, String? detail) =>
                  CustomErrorWidget(
                statusCode: statusCode,
                message: message,
                detail: detail,
              ),
            ),
      ),
    );
  }
}
