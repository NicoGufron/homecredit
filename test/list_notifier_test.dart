import 'package:homecredit/controller/list_notifier.dart';
import 'package:homecredit/models/contract.dart';
import 'package:homecredit/models/insurance.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test/test.dart';

void main() {
  group('tests', () {
    test('sort item dueDate ascending', () {
      final container = ProviderContainer();
      final notifier = container.read(listProvider.notifier);

      final contract = [
        Contract(
          contractNumber: "10004",
          dueDate: "1 August 2025",
          status: "Active",
          dueAmount: {
            "amount" : "1100000",
            "currency" : "IDR"
          },
          contractInfo: {
            "tenor" : "12",
            "creditAmount" : {
              "amount" : "12000000",
              "currency" : "IDR"
            },
            "installmentAmount": {
              "amount" : "1050000",
              "currency" : "IDR"

            }
          },
          createdDate: "1 June 2025"
        ),
        Contract(
          contractNumber: "10003",
          dueDate: "19 July 2025",
          status: "Active",
          dueAmount: {
            "amount" : "350000",
            "currency" : "IDR"
          },
          contractInfo: {
            "tenor" : "3",
            "creditAmount" : {
              "amount" : "1000000",
              "currency" : "IDR"
            },
            "installmentAmount": {
              "amount" : "350000",
              "currency" : "IDR"

            }
          },
          createdDate: "19 May 2025"
        ),
        Contract(
          contractNumber: "10002",
          dueDate: "15 November 2024",
          status: "Finished",
          contractInfo: {
            "tenor" : "24",
            "creditAmount" : {
              "amount" : "22000000",
              "currency" : "IDR"
            },
            "installmentAmount": {
              "amount" : "1000000",
              "currency" : "IDR"

            }
          },
          createdDate: "1 November 2022"
        ),
      ];

      final insurance = [
        Insurance(
          orderId: "32819382", 
          status: "Rejected", 
          amount: "100000", 
          productCode: "x0101", 
          policyNumber: "011101", 
          createdDate: "2025-04-03"
        )
      ];

      notifier.state = [...contract, ...insurance];
      notifier.sort();

      final sorted = notifier.state;

      expect(sorted[0].due.isBefore(sorted[1].due), true);
      expect(sorted[1].due.isBefore(sorted[2].due), true);
    });

    test('sort item dueDate descending', () {
      final container = ProviderContainer();
      final notifier = container.read(listProvider.notifier);

      final contract = [
        Contract(
          contractNumber: "10004",
          dueDate: "1 August 2025",
          status: "Active",
          dueAmount: {
            "amount" : "1100000",
            "currency" : "IDR"
          },
          contractInfo: {
            "tenor" : "12",
            "creditAmount" : {
              "amount" : "12000000",
              "currency" : "IDR"
            },
            "installmentAmount": {
              "amount" : "1050000",
              "currency" : "IDR"

            }
          },
          createdDate: "1 June 2025"
        ),
        Contract(
          contractNumber: "10003",
          dueDate: "19 July 2025",
          status: "Active",
          dueAmount: {
            "amount" : "350000",
            "currency" : "IDR"
          },
          contractInfo: {
            "tenor" : "3",
            "creditAmount" : {
              "amount" : "1000000",
              "currency" : "IDR"
            },
            "installmentAmount": {
              "amount" : "350000",
              "currency" : "IDR"

            }
          },
          createdDate: "19 May 2025"
        ),
        Contract(
          contractNumber: "10002",
          dueDate: "15 November 2024",
          status: "Finished",
          contractInfo: {
            "tenor" : "24",
            "creditAmount" : {
              "amount" : "22000000",
              "currency" : "IDR"
            },
            "installmentAmount": {
              "amount" : "1000000",
              "currency" : "IDR"

            }
          },
          createdDate: "1 November 2022"
        ),
      ];

      final insurance = [
        Insurance(
          orderId: "20250501000012", 
          status: "Rejected", 
          amount: "100000", 
          productCode: "x0101", 
          policyNumber: "011101", 
          createdDate: "2025-04-03"
        ),
        Insurance(
          orderId: "2024040100043",
          status: "Finished",
          amount: "10000000",
          productCode: "GOLD",
          policyNumber: "X0000012",
          createdDate: "1 April 2024"
        )
      ];

      notifier.state = [...contract, ...insurance];
      
      //jaga2 kalau dia ada sortnya diganti
      notifier.toggleSort();
      notifier.sort();

      final items = notifier.state;

      expect(items[0].due.isAfter(items[1].due), true);
      expect(items[1].due.isAfter(items[2].due), true);

    });
  });
}