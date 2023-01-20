import 'dart:math' as math;

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';

import '../../extensions/extensions.dart' show BuildContextExtension;
import '../app/theme/app_theme.dart';
import '../widget/gap.dart';

class PopupMenu extends StatefulWidget {
  const PopupMenu({
    super.key,
    required this.iconData,
    required this.children,
  });

  final IconData iconData;
  final List<PopupMenuItemConfig> children;

  @override
  _PopupMenuState createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int childCount = math.max(
      0,
      widget.children.length * 2 - 1,
    );

    return CustomPopupMenu(
      controller: _controller,
      verticalMargin: 0.0,
      arrowColor: context.theme.cardColor,
      barrierColor: context.theme.colorScheme.scrim,
      pressType: PressType.singleClick,
      menuBuilder: () => ClipRRect(
        borderRadius: AppTheme.adornmentBorderRadius,
        child: Material(
          color: context.theme.cardColor,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int index = 0; index < childCount; index++)
                  if (index.isEven)
                    _PopupMenuItem(
                      config: widget.children[index ~/ 2],
                      hideMenu: () {
                        _controller.hideMenu();
                      },
                    )
                  else
                    const Divider(),
              ],
            ),
          ),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          width: 48.0,
          height: 48.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(widget.iconData),
        ),
      ),
    );
  }
}

class PopupMenuItemConfig {
  const PopupMenuItemConfig({
    required this.iconData,
    required this.label,
    required this.onTap,
  });

  final IconData iconData;
  final String label;
  final VoidCallback onTap;
}

class _PopupMenuItem extends StatelessWidget {
  const _PopupMenuItem({
    required this.config,
    required this.hideMenu,
  });

  final PopupMenuItemConfig config;
  final VoidCallback hideMenu;

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: () {
          hideMenu();
          config.onTap();
        },
        child: Padding(
          padding: AppTheme.bodyPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(config.iconData),
              Gap(
                direction: GapDirection.horizontal,
                value: 8.0,
              ),
              Expanded(
                child: Text(
                  config.label,
                  style: TextStyle(
                    color: context.theme.iconTheme.color,
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
