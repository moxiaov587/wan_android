import 'package:flutter/material.dart';

import '../../../app/l10n/generated/l10n.dart';
import '../../../contacts/icon_font_icons.dart';
import '../../../contacts/instances.dart';

enum LoginTextFieldType {
  username,
  password,
  rePassword,
}

class LoginTextField extends StatefulWidget {
  const LoginTextField({
    Key? key,
    required this.type,
    required this.controller,
  }) : super(key: key);

  final LoginTextFieldType type;
  final TextEditingController controller;

  @override
  _LoginTextFieldState createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  final ValueNotifier<bool> _showClean = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onQueryChanged);
    _showClean.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    if (widget.controller.text.isEmpty && _showClean.value) {
      _showClean.value = false;
    } else if (widget.controller.text.isNotEmpty && !_showClean.value) {
      _showClean.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color materialStateColor =
        MaterialStateColor.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.error)) {
        return currentTheme.errorColor;
      }

      if (states.contains(MaterialState.focused)) {
        return currentTheme.primaryColor;
      }

      return currentTheme.iconTheme.color!;
    });

    const BorderRadius inputBorderRadius = BorderRadius.all(
      Radius.circular(6.0),
    );

    final InputDecoration inputDecoration = InputDecoration(
      hintStyle: currentTheme.textTheme.bodyLarge,
      contentPadding: EdgeInsets.zero,
      prefixIconConstraints: const BoxConstraints.tightFor(
        width: 34.0,
        height: 30.0,
      ),
      prefixIconColor: materialStateColor,
      suffixIconColor: materialStateColor,
      filled: true,
      fillColor: currentTheme.dialogBackgroundColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: Divider.createBorderSide(
          context,
          color: Colors.transparent,
          width: 0.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: Divider.createBorderSide(
          context,
          color: currentTheme.primaryColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: Divider.createBorderSide(
          context,
          color: currentTheme.errorColor,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: inputBorderRadius,
        borderSide: Divider.createBorderSide(
          context,
          color: currentTheme.errorColor,
        ),
      ),
    );

    late String hintText;

    switch (widget.type) {
      case LoginTextFieldType.username:
        hintText = S.of(context).username;
        break;
      case LoginTextFieldType.password:
        hintText = S.of(context).password;
        break;
      default:
        hintText = S.of(context).rePassword;
    }

    final bool isPasswordType = widget.type != LoginTextFieldType.username;

    final IconData prefixIconData = isPasswordType
        ? IconFontIcons.lockLine
        : IconFontIcons.accountCircleLine;

    return TextFormField(
      controller: widget.controller,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      obscureText: isPasswordType,
      textInputAction: TextInputAction.done,
      style: currentTheme.textTheme.titleSmall,
      decoration: inputDecoration.copyWith(
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
          ),
          child: Icon(
            prefixIconData,
            size: 22.0,
          ),
        ),
        suffixIcon: ValueListenableBuilder<bool>(
          valueListenable: _showClean,
          builder: (_, bool value, Widget? child) {
            return value
                ? IconButton(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(
                      IconFontIcons.closeCircleLine,
                      size: 18.0,
                    ),
                    onPressed: () {
                      widget.controller.text = '';
                    },
                  )
                : child!;
          },
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
