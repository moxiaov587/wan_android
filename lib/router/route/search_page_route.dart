part of '../../widget/custom_search_delegate.dart';

const double kToolbarPadding = 8.0;
const double kSearchTextFieldHeight = kToolbarHeight - kToolbarPadding * 2;

class SearchPageRoute<T> extends PageRoute<T> {
  SearchPageRoute({
    required this.delegate,
    super.settings,
  }) {
    assert(
      delegate._route == null,
      'The ${delegate.runtimeType} instance is currently used by another '
      'active search. Please close that search by calling close() on the '
      'SearchDelegate before opening another search with the same '
      'delegate instance.',
    );
    delegate
      .._route = this
      .._currentBody = _SearchBody.suggestions;
  }

  final CustomSearchDelegate<T> delegate;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) =>
      FadeTransition(
        opacity: animation,
        child: child,
      );

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
  ) =>
      _SearchPage<T>(
        delegate: delegate,
        animation: animation,
      );

  @override
  void didComplete(T? result) {
    super.didComplete(result);
    assert(delegate._route == this, '');
    delegate
      .._route = null
      .._currentBody = null;
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

  final ValueNotifier<bool> _showClearButtonNotifier =
      ValueNotifier<bool>(false);

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
    _showClearButtonNotifier.dispose();
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
    if (widget.delegate.query.isEmpty && _showClearButtonNotifier.value) {
      _showClearButtonNotifier.value = false;
    } else if (widget.delegate.query.isNotEmpty &&
        !_showClearButtonNotifier.value) {
      _showClearButtonNotifier.value = true;
    }
  }

  void _onSearchBodyChanged() {
    setState(() {
      // rebuild ourselves because search body changed.
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context), '');
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

    return Semantics(
      explicitChildNodes: true,
      scopesRoute: true,
      namesRoute: true,
      label: routeName,
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: widget.delegate.buildLeading(context),
            leadingWidth:
                widget.delegate.buildLeading(context) == null ? 0.0 : null,
            titleSpacing: 0.0,
            title: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextField(
                controller: widget.delegate._queryTextController,
                focusNode: focusNode,
                style: theme.textTheme.titleSmall,
                textInputAction: widget.delegate.textInputAction,
                keyboardType: widget.delegate.keyboardType,
                onSubmitted: (String _) {
                  widget.delegate.showResults(context);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    maxHeight: kSearchTextFieldHeight,
                  ),
                  hintText: searchFieldLabel,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 36.0,
                    minHeight: kSearchTextFieldHeight,
                  ),
                  prefixIcon: const Icon(
                    IconFontIcons.searchLine,
                    size: 20.0,
                  ),
                  suffixIcon: ValueListenableBuilder<bool>(
                    valueListenable: _showClearButtonNotifier,
                    builder: (_, bool value, __) => value
                        ? IconButton(
                            icon: const Icon(
                              IconFontIcons.closeCircleLine,
                              size: 18.0,
                            ),
                            onPressed: () {
                              widget.delegate.query = '';
                            },
                          )
                        : nil,
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
