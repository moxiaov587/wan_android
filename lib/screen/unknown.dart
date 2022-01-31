import 'package:flutter/material.dart';

import '../app/l10n/generated/l10n.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).unknownError),
      ),
      body: Center(
        child: Text(S.of(context).unknownErrorMsg),
      ),
    );
  }
}
