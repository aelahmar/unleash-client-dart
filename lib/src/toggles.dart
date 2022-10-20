class Toggles {
  List<Toggle>? toggles;

  Toggles({
    this.toggles,
  });

  Toggles.fromJson(Map<String, dynamic> json) {
    toggles = (json['toggles'] as List?)
        ?.map((dynamic e) => Toggle.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['toggles'] = toggles?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Toggle {
  String? name;
  bool? enabled;
  Variant? variant;
  bool? impressionData;

  Toggle({
    this.name,
    this.enabled,
    this.variant,
    this.impressionData,
  });

  Toggle.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    enabled = json['enabled'] as bool?;
    variant = (json['variant'] as Map<String, dynamic>?) != null
        ? Variant.fromJson(json['variant'] as Map<String, dynamic>)
        : null;
    impressionData = json['impressionData'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['enabled'] = enabled;
    json['variant'] = variant?.toJson();
    json['impressionData'] = impressionData;
    return json;
  }
}

class Variant {
  String? name;
  bool? enabled;

  Variant({
    this.name,
    this.enabled,
  });

  Variant.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    enabled = json['enabled'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['name'] = name;
    json['enabled'] = enabled;
    return json;
  }
}
