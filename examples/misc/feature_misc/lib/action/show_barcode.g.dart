// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_barcode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowBarcodeAction _$ShowBarcodeActionFromJson(Map<String, dynamic> json) =>
    ShowBarcodeAction(
      isAwaited: json['isAwaited'] as bool? ?? false,
      barcodeType:
          $enumDecodeNullable(_$BarcodeTypeEnumMap, json['barcodeType']) ??
              BarcodeType.Code128,
      data: json['data'] as String? ?? 'Vyuh Framework',
    );

const _$BarcodeTypeEnumMap = {
  BarcodeType.CodeITF16: 'CodeITF16',
  BarcodeType.CodeITF14: 'CodeITF14',
  BarcodeType.CodeEAN13: 'CodeEAN13',
  BarcodeType.CodeEAN8: 'CodeEAN8',
  BarcodeType.CodeEAN5: 'CodeEAN5',
  BarcodeType.CodeEAN2: 'CodeEAN2',
  BarcodeType.CodeISBN: 'CodeISBN',
  BarcodeType.Code39: 'Code39',
  BarcodeType.Code93: 'Code93',
  BarcodeType.CodeUPCA: 'CodeUPCA',
  BarcodeType.CodeUPCE: 'CodeUPCE',
  BarcodeType.Code128: 'Code128',
  BarcodeType.GS128: 'GS128',
  BarcodeType.Telepen: 'Telepen',
  BarcodeType.QrCode: 'QrCode',
  BarcodeType.Codabar: 'Codabar',
  BarcodeType.PDF417: 'PDF417',
  BarcodeType.DataMatrix: 'DataMatrix',
  BarcodeType.Aztec: 'Aztec',
  BarcodeType.Rm4scc: 'Rm4scc',
  BarcodeType.Postnet: 'Postnet',
  BarcodeType.Itf: 'Itf',
};
