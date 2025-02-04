class HealthTips {
  HealthTips({
    this.tip,
  });

  String? tip;

  factory HealthTips.fromJson(Map<String, dynamic> json) => HealthTips(
        tip: json["tip"] ?? "Focus on foods like nuts, avocado and olive oil.",
      );
}

class CausesTips {
  CausesTips({
    this.tip,
  });

  String? tip;

  factory CausesTips.fromJson(Map<String, dynamic> json) => CausesTips(
        tip: json["Tips"] ?? " ",
      );
}
