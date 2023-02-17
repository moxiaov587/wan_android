import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';

import '../../extensions/extensions.dart' show BuildContextExtension;
import '../app/l10n/generated/l10n.dart';
import '../app/provider/provider.dart';
import '../app/theme/app_theme.dart';
import '../contacts/assets.dart';
import 'gap.dart';

part 'custom_error_widget.dart';
part 'empty_widget.dart';
part 'loading_widget.dart';

const Size _kRetryButtonSize = Size(64.0, 36.0);
