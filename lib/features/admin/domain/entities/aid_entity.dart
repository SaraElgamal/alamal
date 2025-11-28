import 'package:equatable/equatable.dart';

enum AidType {
  cash,
  food,
  medical,
  educational,
  other,
}

class AidEntity extends Equatable {
  final AidType type;
  final double value;
  final DateTime date;

  const AidEntity({
    required this.type,
    required this.value,
    required this.date,
  });

  @override
  List<Object?> get props => [type, value, date];
}
