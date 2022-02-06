import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/http/wan_android_api.dart';
import '../../../app/l10n/generated/l10n.dart';
import '../../../app/provider/provider.dart';
import '../../../app/provider/view_state.dart';
import '../../../model/models.dart';
import '../../../utils/dialog.dart';
import '../my_collections/my_collections.dart' show CollectionType;

part 'my_collections_provider.dart';
part 'my_points_provider.dart';
part 'my_share_provider.dart';
part 'points_rank_provider.dart';
