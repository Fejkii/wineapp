// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProjectSettingsModel {
  int id;
  int projectId;
  double defaultFreeSulfur;
  double defaultLiquidSulfur;

  ProjectSettingsModel({
    required this.id,
    required this.projectId,
    required this.defaultFreeSulfur,
    required this.defaultLiquidSulfur,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'project_id': projectId,
      'default_free_sulfur': defaultFreeSulfur,
      'default_liquid_sulfur': defaultLiquidSulfur,
    };
  }

  factory ProjectSettingsModel.fromMap(Map<String, dynamic> map) {
    return ProjectSettingsModel(
      id: map['id'] as int,
      projectId: map['project_id'] as int,
      defaultFreeSulfur: map['default_free_sulfur'].toDouble(),
      defaultLiquidSulfur: map['default_liquid_sulfur'].toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectSettingsModel.fromJson(String source) => ProjectSettingsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
