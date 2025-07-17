import 'package:homecredit/models/list_item.dart';
import 'package:intl/intl.dart';

class Contract implements ListItem {
  final String contractNumber;
  final String? dueDate;
  final String status;
  final String createdDate;
  final Map<String, dynamic>? dueAmount;
  final Map<String, dynamic>? contractInfo;

  Contract({
    required this.contractNumber,
    this.dueDate,
    required this.status,
    required this.createdDate,
     this.dueAmount,
     this.contractInfo,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      contractNumber: json['contractNumber'],
      status: json['status'],
      dueDate: json['dueDate'],
      createdDate: json['createdDate'],
      dueAmount: json['dueAmount'],
      contractInfo: json['contractInfo']
    );
  }

  // @override
  // DateTime get due => DateTime.parse(dueDate ?? createdDate);

  @override
  DateTime get due {
    try {
      final dateString = dueDate ?? createdDate;

      if (dateString.contains(' ') && !dateString.contains('-')) {
        return DateFormat('d MMMM yyyy').parse(dateString);
      }

      return DateTime.parse(dateString);

    } catch (e) {
      return DateTime.now();
    }
  }

  String get displayId => contractNumber;
  String get type => 'Contract';
}