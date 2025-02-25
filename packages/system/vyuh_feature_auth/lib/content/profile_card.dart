import 'package:json_annotation/json_annotation.dart';
import 'package:vyuh_core/vyuh_core.dart';
import 'package:vyuh_extension_content/vyuh_extension_content.dart';

import 'profile_form_layout.dart';

part 'profile_card.g.dart';

@JsonSerializable()
final class ProfileCard extends ContentItem {
  final Action? logoutAction;
  final Action? loginAction;

  static const schemaName = 'auth.profileCard';
  static final typeDescriptor = TypeDescriptor(
    schemaType: schemaName,
    title: 'Profile Card',
    fromJson: ProfileCard.fromJson,
  );
  static final contentBuilder = ContentBuilder(
    content: typeDescriptor,
    defaultLayoutDescriptor: ProfileCardLayout.typeDescriptor,
    defaultLayout: ProfileCardLayout(),
  );

  ProfileCard({
    this.loginAction,
    this.logoutAction,
    super.layout,
    super.modifiers,
  }) : super(schemaType: schemaName);

  factory ProfileCard.fromJson(Map<String, dynamic> json) =>
      _$ProfileCardFromJson(json);
}

final class ProfileFormDescriptor extends ContentDescriptor {
  ProfileFormDescriptor({super.layouts})
      : super(
          schemaType: ProfileCard.schemaName,
          title: 'Profile Card',
        );
}
