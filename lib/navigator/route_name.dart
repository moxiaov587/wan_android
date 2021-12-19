class RouteName {
  const RouteName({
    required String title,
    String? location,
  })  : _title = title,
        _location = location ?? '/$title';

  final String _title;

  String get title => _title;

  final String _location;

  String get location => _location.toLowerCase();
}

class RouterName {
  RouterName._();

  static RouteName home = const RouteName(
    title: 'Home',
    location: '/',
  );

  static RouteName square = const RouteName(title: 'Square');

  static RouteName qa = const RouteName(
    title: 'QA',
  );

  static RouteName project = const RouteName(title: 'Project');

  static RouteName projectType = RouteName(
    title: 'ProjectType',
    location: '${project.location}/type',
  );

  static RouteName search = const RouteName(title: 'Search');

  static List<String> homeTabsPath = <String>[
    home.location,
    square.location,
    qa.location,
    project.location,
  ];

  static List<String> homePath = <String>[
    projectType.location,
    search.location,
  ];

  static RouteName article = const RouteName(title: 'Article');

  static RouteName login = const RouteName(
    title: 'Login',
  );

  static RouteName register = const RouteName(
    title: 'Register',
  );

  static RouteName setting = const RouteName(
    title: 'Setting',
  );

  static RouteName rank = const RouteName(
    title: 'Rank',
  );

  static RouteName about = const RouteName(
    title: 'About',
  );

  static RouteName unknown = const RouteName(
    title: 'Unknown',
  );
}
