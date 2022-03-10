import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/l10n/generated/l10n.dart';
import '../app/theme/app_theme.dart';
import '../contacts/assets.dart';
import '../contacts/instances.dart';
import '../screen/provider/connectivity_provider.dart';
import 'gap.dart';

part 'loading_widget.dart';
part 'empty_widget.dart';
part 'custom_error_widget.dart';

const Size _kRetryButtonSize = Size(64.0, 36.0);
