import 'package:flutter/material.dart' hide Action;
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'dropdown_menu.g.dart';

@JsonSerializable()
final class DropDownMenu extends ContentItem {
  static const schemaName = 'vyuh.dropDownMenu';

  final String label;

  final Action? selectionChanged;

  final List<DropDownItem> items;

  DropDownMenu({
    required this.items,
    this.label = '',
    this.selectionChanged,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory DropDownMenu.fromJson(Map<String, dynamic> json) =>
      _$DropDownMenuFromJson(json);
}

final class DropDownContentBuilder extends ContentBuilder<DropDownMenu> {
  DropDownContentBuilder()
      : super(
          content: TypeDescriptor(
            schemaType: DropDownMenu.schemaName,
            title: 'DropDown Menu',
            fromJson: DropDownMenu.fromJson,
          ),
          defaultLayout: DefaultDropDownMenuLayout(),
          defaultLayoutDescriptor: DefaultDropDownMenuLayout.typeDescriptor,
        );
}

final class DefaultDropDownMenuLayout
    extends LayoutConfiguration<DropDownMenu> {
  static const schemaName = '${DropDownMenu.schemaName}.layout.default';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Default DropDown Menu Layout',
    fromJson: DefaultDropDownMenuLayout.fromJson,
  );

  DefaultDropDownMenuLayout() : super(schemaType: schemaName);

  factory DefaultDropDownMenuLayout.fromJson(Map<String, dynamic> json) =>
      DefaultDropDownMenuLayout();

  @override
  Widget build(BuildContext context, DropDownMenu content) {
    return DropDownMenuWidget(content: content);
  }
}

@JsonSerializable()
final class DropDownItem {
  @JsonKey(defaultValue: '')
  final String title;

  final String value;

  final Action? action;

  DropDownItem({
    required this.title,
    required this.value,
    this.action,
  });

  factory DropDownItem.fromJson(Map<String, dynamic> json) =>
      _$DropDownItemFromJson(json);
}

class DropDownMenuWidget extends StatefulWidget {
  final DropDownMenu content;

  const DropDownMenuWidget({
    super.key,
    required this.content,
  });

  @override
  State<DropDownMenuWidget> createState() => _DropDownMenuWidgetState();
}

class _DropDownMenuWidgetState extends State<DropDownMenuWidget>
    with AutomaticKeepAliveClientMixin {
  DropDownItem? _selectedItem;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  void onItemChange(DropDownItem? data) {
    if (data == null) return;
    setState(() {
      _selectedItem = data;
    });
    final arguments = <String, dynamic>{DropDownMenu.schemaName: data};
    final action =
        data.action != null ? data.action! : widget.content.selectionChanged;
    action?.execute(context, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DropdownButton<DropDownItem>(
      value: _selectedItem,
      items: widget.content.items.map((data) {
        return DropdownMenuItem<DropDownItem>(
          value: data,
          child: Text(
            data.title,
            style: Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.visible,
            maxLines: 2,
            softWrap: true,
          ),
        );
      }).toList(),
      onChanged: onItemChange,
    );
  }
}
