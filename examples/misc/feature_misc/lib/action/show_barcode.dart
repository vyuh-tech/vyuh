import 'dart:async';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

part 'show_barcode.g.dart';

@JsonSerializable()
final class ShowBarcodeAction extends ActionConfiguration {
  static const schemaName = 'misc.action.showBarcode';

  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Show Barcode',
    fromJson: ShowBarcodeAction.fromJson,
  );

  final BarcodeType barcodeType;
  final String data;

  ShowBarcodeAction({
    super.isAwaited,
    this.barcodeType = BarcodeType.Code128,
    this.data = 'Vyuh Framework',
  }) : super(schemaType: schemaName, title: 'Show Bar Code');

  factory ShowBarcodeAction.fromJson(Map<String, dynamic> json) =>
      _$ShowBarcodeActionFromJson(json);

  @override
  FutureOr<void> execute(
    BuildContext context, {
    Map<String, dynamic>? arguments,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.barcode_reader),
        title: Text('Barcode: ${barcodeType.name}'),
        content: BarcodeWidget(
          barcode: Barcode.fromType(barcodeType),
          data: data,
          height: 100,
        ),
      ),
    );
  }
}
