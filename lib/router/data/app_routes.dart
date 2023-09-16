import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../extensions/extensions.dart';
import '../../screen/article/article_screen.dart';
import '../../screen/authorized/login_screen.dart';
import '../../screen/drawer/home_drawer.dart';
import '../../screen/home/home_screen.dart';
import '../../screen/they/they.dart';
import '../../screen/unknown_screen.dart';

import '../../widget/custom_search_delegate.dart' show SearchPageRoute;
import '../app_router.dart';

part 'home/home_route.dart';
part 'home/project_type_route.dart';
part 'drawer/my_collections_route.dart';
part 'drawer/my_points_route.dart';
part 'drawer/my_share_route.dart';
part 'drawer/settings/languages_route.dart';
part 'drawer/settings/settings_route.dart';
part 'drawer/settings/storage_route.dart';
part 'drawer/about_route.dart';
part 'app_routes.g.dart';
part 'article_route.dart';
part 'authorized/login_route.dart';
part 'drawer/rank_route.dart';
part 'authorized/register_route.dart';
part 'search_route.dart';
part 'unknown_route.dart';
part 'they/they_articles_route.dart';
part 'they/they_share_route.dart';
