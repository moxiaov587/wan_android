import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show MaxLengthEnforcement, TextInputFormatter;
import 'package:nil/nil.dart' show nil;

import '../../extensions/extensions.dart' show BuildContextExtension;
import '../contacts/icon_font_icons.dart';

const double _kClearIconSize = 18.0;
const double _kContentPaddingLeft =
    kMinInteractiveDimension * 0.5 - _kClearIconSize * 0.5;

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.controller,
    super.key,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enableInteractiveSelection = true,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final bool enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  static Widget _defaultContextMenuBuilder(
    BuildContext _,
    EditableTextState editableTextState,
  ) =>
      AdaptiveTextSelectionToolbar.editableText(
        editableTextState: editableTextState,
      );

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late final ValueNotifier<bool> _showCleanButtonNotifier =
      ValueNotifier<bool>(widget.controller.text.isNotEmpty);

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onInputChanged);
    _showCleanButtonNotifier.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    if (widget.controller.text.isEmpty && _showCleanButtonNotifier.value) {
      _showCleanButtonNotifier.value = false;
    } else if (widget.controller.text.isNotEmpty &&
        !_showCleanButtonNotifier.value) {
      _showCleanButtonNotifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        decoration: widget.decoration.copyWith(
          contentPadding: widget.decoration.prefixIcon != null
              ? EdgeInsets.zero
              : const EdgeInsets.only(left: _kContentPaddingLeft),
          prefixIconConstraints: const BoxConstraints(
            minWidth: kMinInteractiveDimension,
            minHeight: kMinInteractiveDimension,
          ),
          suffixIcon: ValueListenableBuilder<bool>(
            valueListenable: _showCleanButtonNotifier,
            builder: (_, bool value, __) => value
                ? IconButton(
                    icon: const Icon(
                      IconFontIcons.closeCircleLine,
                      size: _kClearIconSize,
                    ),
                    onPressed: () {
                      widget.controller.text = '';
                    },
                  )
                : nil,
          ),
        ),
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        style: widget.style,
        strutStyle: widget.strutStyle,
        textDirection: widget.textDirection,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        showCursor: widget.showCursor,
        obscuringCharacter: widget.obscuringCharacter,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        enableSuggestions: widget.enableSuggestions,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        onSaved: widget.onSaved,
        validator: widget.validator,
        inputFormatters: widget.inputFormatters,
        cursorColor: context.theme.primaryColor,
        keyboardAppearance: context.theme.brightness,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        selectionControls: widget.selectionControls,
        buildCounter: widget.buildCounter,
        scrollPhysics: widget.scrollPhysics,
        autofillHints: widget.autofillHints,
        autovalidateMode: widget.autovalidateMode,
        scrollController: widget.scrollController,
        restorationId: widget.restorationId,
        enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
        contextMenuBuilder: widget.contextMenuBuilder,
      );
}
