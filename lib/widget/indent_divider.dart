import 'package:flutter/material.dart';

import '../extensions/extensions.dart' show BuildContextExtension;

class IndentDivider extends StatelessWidget {
  const IndentDivider({
    super.key,
    this.type,
    this.backgroundColor,
  });

  const IndentDivider.listTile({
    super.key,
  })  : type = IndentDividerType.listTile,
        backgroundColor = null;

  const IndentDivider.canvas({
    super.key,
  })  : type = IndentDividerType.canvas,
        backgroundColor = null;

  final IndentDividerType? type;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    late Color color;

    if (backgroundColor == null) {
      switch (type) {
        case null || IndentDividerType.canvas:
          color = context.theme.canvasColor;
        case IndentDividerType.listTile:
          color = context.theme.listTileTheme.tileColor!;
      }
    }

    return ColoredBox(
      color: backgroundColor ?? color,
      child: const Divider(),
    );
  }
}

enum IndentDividerType {
  listTile,
  canvas,
}
