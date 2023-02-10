import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/l10n/generated/l10n.dart';
import '../app/theme/app_theme.dart';
import '../contacts/assets.dart';
import '../extensions/extensions.dart';
import '../router/data/app_routes.dart';
import '../widget/gap.dart';
import 'home/home_screen.dart';

class UnknownScreen extends StatefulWidget {
  const UnknownScreen({super.key, required this.state});

  final GoRouterState state;

  @override
  State<UnknownScreen> createState() => _UnknownScreenState();
}

class _UnknownScreenState extends State<UnknownScreen> {
  final ValueNotifier<bool> _isExpandedValueNotifier =
      ValueNotifier<bool>(false);

  @override
  void dispose() {
    super.dispose();

    _isExpandedValueNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).unknownPath),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kStyleUint4,
                  vertical: kStyleUint4 * 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      Assets.ASSETS_IMAGES_UNKNOWN_PATH_PNG,
                      width: 120,
                    ),
                    Text(
                      S.of(context).unknownPath,
                      style: context.theme.textTheme.titleSmall,
                    ),
                    Gap(
                      size: GapSize.small,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text(S.of(context).unknownPathMsg),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: _isExpandedValueNotifier,
                          builder: (BuildContext context, bool isExpanded, _) =>
                              ExpandIcon(
                            isExpanded: isExpanded,
                            onPressed: (bool value) {
                              _isExpandedValueNotifier.value = !value;
                            },
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isExpandedValueNotifier,
                      builder: (_, bool isExpanded, __) {
                        if (isExpanded) {
                          return Text(
                            widget.state.error.toString(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    Gap(
                      size: GapSize.big,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        const HomeRoute(path: HomePath.home).go(context);
                      },
                      child: Text(S.of(context).backHome),
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
