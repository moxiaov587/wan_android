import 'dart:collection' show LinkedHashMap;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io';
import 'dart:math' show Random;

import 'package:connectivity_plus/connectivity_plus.dart'
    show ConnectivityResult;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../database/app_database.dart';
import '../../../screen/authorized/provider/authorized_provider.dart';
import '../../../screen/provider/common_provider.dart';
import '../../../utils/log_utils.dart';
import '../../l10n/generated/l10n.dart';
import '../../provider/provider.dart';
import '../http.dart';

part 'cache_interceptor.dart';
part 'error_interceptor.dart';
part 'network_interceptor.dart';

part 'interceptors.freezed.dart';
part 'interceptors.g.dart';
