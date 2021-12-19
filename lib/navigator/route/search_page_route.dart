part of '../../widget/custom_search_delegate.dart';

class SearchPageRoute<T> extends PageRoute<T> {
  SearchPageRoute({
    required this.delegate,
    RouteSettings? settings,
  })  : assert(delegate != null),
        super(settings: settings) {
    assert(
      delegate._route == null,
      'The ${delegate.runtimeType} instance is currently used by another active '
      'search. Please close that search by calling close() on the SearchDelegate '
      'before opening another search with the same delegate instance.',
    );
    delegate._route = this;

    /// initial currentBody
    delegate._currentBody = _SearchBody.suggestions;
  }

  final CustomSearchDelegate<T> delegate;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Animation<double> createAnimation() {
    final Animation<double> animation = super.createAnimation();
    delegate._proxyAnimation.parent = animation;
    return animation;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _SearchPage<T>(
      delegate: delegate,
      animation: animation,
    );
  }

  @override
  void didComplete(T? result) {
    super.didComplete(result);
    assert(delegate._route == this);
    delegate._route = null;
    delegate._currentBody = null;
  }
}

class _SearchPage<T> extends StatefulWidget {
  const _SearchPage({
    required this.delegate,
    required this.animation,
  });

  final CustomSearchDelegate<T> delegate;
  final Animation<double> animation;

  @override
  State<StatefulWidget> createState() => _SearchPageState<T>();
}

class _SearchPageState<T> extends State<_SearchPage<T>> {
  // This node is owned, but not hosted by, the search page. Hosting is done by
  // the text field.
  FocusNode focusNode = FocusNode();

  final ValueNotifier<bool> _showCleanQuery = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    widget.delegate._queryTextController.addListener(_onQueryChanged);
    widget.animation.addStatusListener(_onAnimationStatusChanged);
    widget.delegate._currentBodyNotifier.addListener(_onSearchBodyChanged);
    focusNode.addListener(_onFocusChanged);
    widget.delegate._focusNode = focusNode;
  }

  @override
  void dispose() {
    _showCleanQuery.dispose();
    widget.delegate._queryTextController.removeListener(_onQueryChanged);
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    widget.delegate._currentBodyNotifier.removeListener(_onSearchBodyChanged);
    widget.delegate._focusNode = null;
    focusNode.dispose();
    super.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    widget.animation.removeStatusListener(_onAnimationStatusChanged);
    if (widget.delegate._currentBody == _SearchBody.suggestions) {
      focusNode.requestFocus();
    }
  }

  @override
  void didUpdateWidget(_SearchPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delegate != oldWidget.delegate) {
      oldWidget.delegate._queryTextController.removeListener(_onQueryChanged);
      widget.delegate._queryTextController.addListener(_onQueryChanged);
      oldWidget.delegate._currentBodyNotifier
          .removeListener(_onSearchBodyChanged);
      widget.delegate._currentBodyNotifier.addListener(_onSearchBodyChanged);
      oldWidget.delegate._focusNode = null;
      widget.delegate._focusNode = focusNode;
    }
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus &&
        widget.delegate._currentBody != _SearchBody.suggestions) {
      widget.delegate.showSuggestions(context);
    }
  }

  void _onQueryChanged() {
    if (widget.delegate.query.isEmpty && _showCleanQuery.value) {
      _showCleanQuery.value = false;
    } else if (widget.delegate.query.isNotEmpty && !_showCleanQuery.value) {
      _showCleanQuery.value = true;
    }
    // setState(() {
    //   // rebuild ourselves because query changed.
    // });
  }

  void _onSearchBodyChanged() {
    setState(() {
      // rebuild ourselves because search body changed.
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = widget.delegate.appBarTheme(context);
    final String searchFieldLabel = widget.delegate.searchFieldLabel ??
        MaterialLocalizations.of(context).searchFieldLabel;
    Widget? body;
    switch (widget.delegate._currentBody) {
      case _SearchBody.suggestions:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.suggestions),
          child: widget.delegate.buildSuggestions(context),
        );
        break;
      case _SearchBody.results:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.results),
          child: widget.delegate.buildResults(context),
        );
        break;
      case null:
        break;
    }

    late final String routeName;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        routeName = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        routeName = searchFieldLabel;
    }

    late final Offset offset;
    if (kIsWeb || Platform.isIOS) {
      offset = const Offset(-12.0, 0);
    } else {
      offset = Offset.zero;
    }

    final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(
        context,
        width: 1.0,
        color: theme.primaryColor,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(6.0),
      ),
    );

    return Semantics(
      explicitChildNodes: true,
      scopesRoute: true,
      namesRoute: true,
      label: routeName,
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(
            leading: widget.delegate.buildLeading(context) ??
                const SizedBox.shrink(),
            leadingWidth:
                widget.delegate.buildLeading(context) == null ? 0.0 : null,
            title: Transform.translate(
              offset: offset,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 36.0,
                ),
                child: TextField(
                  controller: widget.delegate._queryTextController,
                  focusNode: focusNode,
                  style: theme.textTheme.subtitle1,
                  textInputAction: widget.delegate.textInputAction,
                  keyboardType: widget.delegate.keyboardType,
                  onSubmitted: (String _) {
                    widget.delegate.showResults(context);
                  },
                  decoration: InputDecoration(
                    hintText: searchFieldLabel,
                    hintStyle: theme.textTheme.subtitle2,
                    contentPadding: EdgeInsets.zero,
                    prefixIconConstraints: const BoxConstraints.tightFor(
                      width: 34.0,
                      height: 30.0,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(
                        left: 4,
                      ),
                      child: Icon(
                        Icons.search,
                        size: 22,
                        color: theme.textTheme.bodyText2?.color,
                      ),
                    ),
                    suffixIcon: ValueListenableBuilder<bool>(
                      valueListenable: _showCleanQuery,
                      builder: (_, bool value, Widget? child) {
                        return value
                            ? IconButton(
                                hoverColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: Icon(
                                  Icons.cancel,
                                  size: 18,
                                  color: theme.textTheme.bodyText2?.color,
                                ),
                                onPressed: () {
                                  widget.delegate.query = '';
                                },
                              )
                            : child!;
                      },
                      child: const SizedBox.shrink(),
                    ),
                    filled: true,
                    fillColor: theme.dialogBackgroundColor,
                    border: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                  ),
                ),
              ),
            ),
            actions: widget.delegate.buildActions(context),
            bottom: widget.delegate.buildBottom(context),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: body,
          ),
        ),
      ),
    );
  }
}
