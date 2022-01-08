part of 'extensions.dart';

extension StringExtension on String? {
  bool get mustNotEmpty => this != null && this!.trim().isNotEmpty;

  String? get strictValue => mustNotEmpty ? this : null;
}
