import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../extensions/context_extension.dart';
import '../extensions/padding_extension.dart';
import '../extensions/sized_box_helper.dart';
import '../extensions/text_style_extensions.dart';
import '../helpers/validators.dart';
import 'image_widgets/cached_image.dart';

/// Dropdown display types
enum CustomDropdownType { menu, bottomSheet }

/// Common reusable dropdown helpers (UI builders, decoration, popup config).
mixin CustomDropdownHelpers<T> {
  /// Converts an item into a string for display
  String Function(T?) get itemToString;

  /// Defines dropdown display type
  CustomDropdownType get dropdownType;

  /// (Optional) Gets the item’s image URL
  String Function(T)? get itemImageUrl;

  /// (Optional) Custom border radius
  BorderRadius? get borderRadius;

  /// Builds how each dropdown item is displayed
  Widget Function(BuildContext, T, bool, bool) get buildDropdownItem =>
      (BuildContext context, T item, bool isSelected, bool isFocused) {
        return ListTile(
          title: Text(
            itemToString(item),
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.black,
            ),
          ),
          leading: dropdownType == CustomDropdownType.menu
              ? (isSelected
                  ? const Icon(Icons.check, color: AppColors.primary)
                  : const SizedBox.shrink())
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Icon(Icons.check, color: AppColors.primary)
                    else
                      25.szW,
                    AppSize.sH10.szW,
                    if (itemImageUrl != null)
                      CachedImage(
                        url: itemImageUrl!(item),
                        height: 20.h,
                        width: 30.w,
                        borderRadius: BorderRadius.circular(3),
                        fit: BoxFit.fill,
                      ).paddingSymmetric(horizontal: 2.w),
                  ],
                ),
        );
      };

  /// Loading indicator for async dropdown
  Widget buildLoadingIndicator() => const Center(
        child: CupertinoActivityIndicator(),
      );

  /// Builds popup configuration based on dropdown type
  PopupProps<T> buildPopupProps() {
    final constraints = BoxConstraints(
      maxHeight: 300.h,
      maxWidth: 400.w,
      minWidth: 350.w,
    );

    final searchFieldDecoration = InputDecoration(
      hintText: LocaleKeys.search,
      prefixIcon: const Icon(Icons.search),
      enabledBorder: dropdownType == CustomDropdownType.bottomSheet
          ? const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            )
          : null,
    );

    switch (dropdownType) {
      case CustomDropdownType.menu:
        return PopupProps.menu(
          showSearchBox: true,
          showSelectedItems: true,
          constraints: constraints,
          itemBuilder: buildDropdownItem,
          loadingBuilder: (_, __) => buildLoadingIndicator(),
          searchFieldProps: TextFieldProps(decoration: searchFieldDecoration),
          menuProps: const MenuProps(backgroundColor: AppColors.white),
        );

      case CustomDropdownType.bottomSheet:
        return PopupProps.bottomSheet(
          showSearchBox: true,
          showSelectedItems: true,
          constraints: constraints,
          itemBuilder: buildDropdownItem,
          loadingBuilder: (_, __) => buildLoadingIndicator(),
          searchFieldProps: TextFieldProps(decoration: searchFieldDecoration),
          bottomSheetProps: const BottomSheetProps(
            backgroundColor: AppColors.white,
          ),
        );
    }
  }

  /// Input decoration for the main dropdown field
  InputDecoration buildInputDecoration({
    required Widget? prefixIcon,
    required String? hint,
  }) {
    final radius = borderRadius ?? BorderRadius.circular(AppCircular.r20);

    return InputDecoration(
      prefixIcon: prefixIcon,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppPadding.pW10,
        vertical: AppPadding.pW14,
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.border),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.border),
        borderRadius: radius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: radius,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: radius,
      ),
    );
  }
}

/// Reusable custom dropdown field
class CustomDropdownField<T> extends StatelessWidget
    with CustomDropdownHelpers<T> {
  @override
  final String Function(T?) itemToString;
  @override
  final CustomDropdownType dropdownType;
  @override
  final String Function(T)? itemImageUrl;
  @override
  final BorderRadius? borderRadius;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final T? selectedItem;
  final String? hint;
  final String? label;
  final Future<List<T>> Function(String, LoadProps?)? asyncItems;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget Function(BuildContext, T?)? customSelectedItemBuilder;

  const CustomDropdownField({
    super.key,
    required this.itemToString,
    this.asyncItems,
    this.validator,
    this.onChanged,
    this.hint,
    this.selectedItem,
    this.label,
    this.prefixIcon,
    this.customSelectedItemBuilder,
    this.dropdownType = CustomDropdownType.menu,
    this.itemImageUrl,
    this.borderRadius,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppMargin.mH6,
      children: [
        if (label != null)
          Text(
            label!,
            style: const TextStyle().setPrimaryColor.s14.medium,
          ),
        Theme(
          data: context.theme.copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
          child: DropdownSearch<T>(
            validator: validator,
            onChanged: onChanged,
            selectedItem: selectedItem,
            decoratorProps: DropDownDecoratorProps(
              baseStyle: const TextStyle(color: Colors.black),
              decoration: buildInputDecoration(
                prefixIcon: prefixIcon,
                hint: hint,
              ),
            ),
            items: asyncItems,
            suffixProps: DropdownSuffixProps(
              clearButtonProps: const ClearButtonProps(
                isVisible: false,
                icon: Icon(Icons.clear, size: 18, color: Colors.black),
                alignment: Alignment.centerLeft,
              ),
              dropdownButtonProps: DropdownButtonProps(
                padding: EdgeInsets.zero,
                iconOpened: suffixIcon ?? const Icon(Icons.arrow_drop_down),
                visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
              ),
            ),
            dropdownBuilder: customSelectedItemBuilder,
            compareFn: (item, selected) => item == selected,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            itemAsString: itemToString,
            popupProps: buildPopupProps(),
          ),
        ),
      ],
    );
  }
}
