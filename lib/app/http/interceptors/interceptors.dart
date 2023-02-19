import 'dart:collection' show LinkedHashMap;
import 'dart:convert' show jsonEncode, jsonDecode;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/app_database.dart';
import '../../../screen/authorized/provider/authorized_provider.dart';
import '../../../screen/provider/common_provider.dart';
import '../../../utils/log_utils.dart';
import '../../l10n/generated/l10n.dart';
import '../http.dart';

part 'cache_interceptor.dart';
part 'error_interceptor.dart';
part 'network_interceptor.dart';
