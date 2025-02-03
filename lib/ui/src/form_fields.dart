// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '/services/services.dart';

class FormFields extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String value)? onChanged;
  final String? label;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function()? onTap;
  final bool? readOnly;
  final Color? fillColor;
  final int? maxLines;
  final String? Function(String? input)? valid;
  final TextInputType? keyType;
  final bool? enabled;
  final TextInputAction? action;
  final String? value;
  const FormFields(
      {super.key,
      required this.controller,
      this.onChanged,
      this.label,
      this.hintText,
      this.suffixIcon,
      this.prefixIcon,
      this.onTap,
      this.readOnly,
      this.fillColor,
      this.maxLines,
      this.valid,
      this.keyType,
      this.enabled,
      this.action,
      this.value});

  @override
  State<FormFields> createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  @override
  Widget build(BuildContext context) {
    if (widget.label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.enabled == false)
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.label ?? '',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w300),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.lock_rounded,
                  color: AppColors.greyColor,
                  size: 16,
                )
              ],
            )
          else
            Text(
              widget.label ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w300),
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: widget.controller,
            enabled: widget.enabled,
            keyboardType: widget.keyType,
            onTap: widget.onTap,
            maxLines: widget.maxLines ?? 1,
            readOnly: widget.readOnly ?? false,
            textInputAction: widget.action,
            onEditingComplete: () {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: widget.fillColor ?? AppColors.pureWhiteColor,
              prefixIcon: widget.prefixIcon,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.fillColor != null
                      ? Colors.black26
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.fillColor != null
                      ? Colors.black12
                      : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            autocorrect: false,
            enableSuggestions: false,
            validator: widget.valid,
          ),
        ],
      );
    } else {
      return TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,
        keyboardType: widget.keyType,
        onTap: widget.onTap,
        maxLines: widget.maxLines ?? 1,
        readOnly: widget.readOnly ?? false,
        onEditingComplete: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon,
          filled: true,
          fillColor: widget.fillColor ?? AppColors.pureWhiteColor,
          prefixIcon: widget.prefixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.fillColor != null
                  ? Colors.black26
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.fillColor != null
                  ? Colors.black12
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        autocorrect: false,
        enableSuggestions: false,
        validator: widget.valid,
      );
    }
  }
}
