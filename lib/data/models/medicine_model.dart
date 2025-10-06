import 'dart:convert';

class MedicineModel {
  final int id;
  final String name;
  final double costPrice;
  final double wholeSalePrice;
  final double salePrice;

  MedicineModel({
    required this.id,
    required this.name,
    required this.costPrice,
    required this.wholeSalePrice,
    required this.salePrice,
  });

  /// 🔑 Computed Secret Code (not stored in DB)
  String get secretCode {
    final Map<String, String> codeMap = {
      "1": "B",
      "2": "U",
      "3": "Y",
      "4": "F",
      "5": "O",
      "6": "R",
      "7": "C",
      "8": "A",
      "9": "S",
      "0": "H",
    };

    return costPrice
        .toInt() // make sure it's an int first
        .toString()
        .split('')
        .map((digit) => codeMap[digit] ?? "")
        .join();
  }

  MedicineModel copyWith({
    int? id,
    String? name,
    double? costPrice,
    double? wholeSalePrice,
    double? salePrice,
  }) {
    return MedicineModel(
      id: id ?? this.id,
      name: name ?? this.name,
      costPrice: costPrice ?? this.costPrice,
      wholeSalePrice: wholeSalePrice ?? this.wholeSalePrice,
      salePrice: salePrice ?? this.salePrice,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'costPrice': costPrice});
    result.addAll({'wholeSalePrice': wholeSalePrice});
    result.addAll({'salePrice': salePrice});

    return result;
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      costPrice: map['costPrice']?.toDouble() ?? 0.0,
      wholeSalePrice: map['wholeSalePrice']?.toDouble() ?? 0.0,
      salePrice: map['salePrice']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicineModel.fromJson(String source) =>
      MedicineModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MedicineModel(id: $id, name: $name, costPrice: $costPrice, wholeSalePrice: $wholeSalePrice, salePrice: $salePrice, secretCode: $secretCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicineModel &&
        other.id == id &&
        other.name == name &&
        other.costPrice == costPrice &&
        other.wholeSalePrice == wholeSalePrice &&
        other.salePrice == salePrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        costPrice.hashCode ^
        wholeSalePrice.hashCode ^
        salePrice.hashCode;
  }
}
