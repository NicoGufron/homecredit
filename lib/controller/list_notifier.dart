import 'dart:convert';

import 'package:homecredit/models/insurance.dart';
import 'package:homecredit/models/list_item.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';

import '../models/contract.dart';

class ListNotifier extends StateNotifier<List<ListItem>> {
  ListNotifier() : super([]);

  bool isLoading = true;
  bool asc = true;
  
  String? error;

  set setAsc(bool value) {
    asc = value;
    sort();
  }

  Future<void> load() async {
    try {
      isLoading = true;
      error = null;

      final contractUrl = await http.get(Uri.parse("https://private-7e14ff-testingapiaryio.apiary-mock.com/contracts/"));
      final insuranceUrl = await http.get(Uri.parse("https://private-7e14ff-testingapiaryio.apiary-mock.com/insurances/"));

      if (contractUrl.statusCode != 200) {
        throw Exception("Failed to load contracts: ${contractUrl.statusCode}");
      }

      if (insuranceUrl.statusCode != 200) {
        throw Exception("Failed to load insurance: ${insuranceUrl.statusCode}");
      }

      final contractData = jsonDecode(contractUrl.body);

      final contractItems = (contractData['contracts'] as List).map((e) => Contract.fromJson(e)).toList();

      // Harus akses ke item orderList
      final insuranceData = jsonDecode(insuranceUrl.body);
      final insuranceItems = (insuranceData['orderList'] as List).map((e) => Insurance.fromJson(e)).toList();

      state = [...contractItems, ...insuranceItems];

      sort();
    } catch (e) {
      error = e.toString();
      state = [];
    } finally {
      isLoading = false;
    }
  }

  void sort() {

    final sorted = [...state];
    sorted.sort((a,b) {
      return asc ? a.due.compareTo(b.due) : b.due.compareTo(a.due);
    });

    state = sorted;
  }

  void toggleSort() {
    asc = !asc;
    sort();
  }
}

final listProvider = StateNotifierProvider<ListNotifier, List<ListItem>>((ref) {
  final notifier = ListNotifier();
  notifier.load();
  return notifier;
});