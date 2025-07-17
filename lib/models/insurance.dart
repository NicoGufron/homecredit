import 'package:homecredit/models/list_item.dart';
import 'package:intl/intl.dart';

class Insurance implements ListItem {
  final String orderId;
  final String status;
  final String amount;
  final String productCode;
  final String policyNumber;
  final String createdDate;

  Insurance({
    required this.orderId, 
    required this.status, 
    required this.amount, 
    required this.productCode, 
    required this.policyNumber, 
    required this.createdDate,
  });

  factory Insurance.fromJson(Map<String, dynamic> json) {
    return Insurance(
      orderId: json['orderId'],
      status: json['status'], 
      amount: json['amount'], 
      productCode: json['productCode'], 
      policyNumber: json['policyNumber'], 
      createdDate:json['createdDate'],
    );
  }

  @override
  // DateTime get due => DateTime.parse(createdDate);

   @override
  DateTime get due {
    try {

      if (createdDate.contains(' ') && !createdDate.contains('-')) {
        return DateFormat('d MMMM yyyy').parse(createdDate);
      }

      return DateTime.parse(createdDate);

    } catch (e) {
      return DateTime.now();
    }
  }

  String get displayId => orderId;
  String get type => 'Insurance';
}