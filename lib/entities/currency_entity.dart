class CurrencyEntity {
  final String code;
  final String name;
  final String country;
  final String countryCode;
  final String? flag;

  const CurrencyEntity({
    required this.code,
    required this.name,
    required this.country,
    required this.countryCode,
    required this.flag,
  });

  factory CurrencyEntity.fromJson(Map<String, dynamic> json) {
    return CurrencyEntity(
      code: json['code'],
      name: json['name'],
      country: json['country'],
      countryCode: json['countryCode'],
      flag: json['flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'country': country,
      'countryCode': countryCode,
      'flag': flag,
    };
  }
}
