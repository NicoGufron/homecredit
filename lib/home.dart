import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:homecredit/controller/list_notifier.dart';
import 'package:homecredit/models/contract.dart';
import 'package:homecredit/models/insurance.dart';
import 'package:homecredit/utils/context_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp.', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {

    final items = ref.watch(listProvider);
    final notifier = ref.read(listProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(context.l10n.myContractList),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  notifier.toggleSort();
                  // notifier.load();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.compare_arrows),
                    SizedBox(width: 5),
                    Flexible(
                      child: Text("${context.l10n.sortByDueDate} ${notifier.asc ?  context.l10n.earliestFirst : context.l10n.latestFirst }", textAlign: TextAlign.center,))
                  ],
                )
              ),
              SizedBox(height: 10),
              Expanded(
                child: notifier.isLoading ? Center(
                  child: CircularProgressIndicator(),
                ) : notifier.error != null ? Center(
                  child: Column(
                    children: [
                      Icon(Icons.error, size: 48, color: Colors.red,),
                      SizedBox(height: 16),
                      Text('Error: ${notifier.error}'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => notifier.load(), 
                        child: Text(context.l10n.retry)
                      )
                    ],
                  ),
                ) : ImplicitlyAnimatedList(
                  items: items, 
                  // id harus sama dengan satu sama lain
                  areItemsTheSame: (a, b) => a.displayId == b.displayId,
                  itemBuilder: (context, animation, item, index) {
                    return SizeFadeTransition(
                      animation: animation,
                      curve: Curves.easeIn,
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          side: BorderSide(color: Colors.black26)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CardHeader(
                                id: item is Contract ? item.contractNumber : (item as Insurance).orderId,
                                type: item is Contract ? context.l10n.contract : context.l10n.insurance,
                                status: item is Contract ? item.status : (item as Insurance).status,
                                icon: item is Contract ? FaIcon(FontAwesomeIcons.fileInvoice, color: Colors.green) : FaIcon(FontAwesomeIcons.shield, color: Colors.blue)
                              ),
                              SizedBox(height: 25,),
                              if (item is Contract) ...[
                                ItemDescription(
                                  leftText: context.l10n.dueAmount,
                                  leftIcon: FaIcon(FontAwesomeIcons.solidMoneyBill1, size: 18, color: Colors.black45,),
                                  leftBottomText: item.dueAmount != null ? formatter.format(int.parse(item.dueAmount!['amount'])) : "N/A",
                                  rightText: context.l10n.installment,
                                  rightBottomText: item.contractInfo != null ? formatter.format(int.parse(item.contractInfo!['installmentAmount']?['amount'])) ?? 'N/A' : "N/A",
                                  rightIcon: FaIcon(FontAwesomeIcons.creditCard, size: 18, color: Colors.black45,),
                                ),
                                SizedBox(height: 10,),
                                ItemDescription(
                                  leftText: context.l10n.creditAmount,
                                  leftBottomText: item.contractInfo != null ? formatter.format(int.parse(item.contractInfo!['creditAmount']?['amount'])) ?? "N/A" : "N/A",
                                  leftIcon: FaIcon(FontAwesomeIcons.moneyBill, size: 18, color: Colors.black45),
                                  rightText: context.l10n.tenor,
                                  rightBottomText: item.contractInfo != null ? "${item.contractInfo!['tenor'] ?? 'N/A'} months" : "N/A",
                                  rightIcon: FaIcon(FontAwesomeIcons.clock, size: 18, color: Colors.black45),
                                ),
                              ] else if (item is Insurance) ... [
                                ItemDescription(
                                  leftText: context.l10n.amount,
                                  leftIcon: FaIcon(FontAwesomeIcons.solidMoneyBill1, size: 18, color: Colors.black45),
                                  leftBottomText: formatter.format(int.parse(item.amount)),
                                  rightText: context.l10n.product,
                                  rightBottomText: item.productCode,
                                  rightIcon: FaIcon(FontAwesomeIcons.boxOpen, size: 18, color: Colors.black45,)
                                ),
                                ItemDescription(
                                  leftText: context.l10n.policyNumber,
                                  leftBottomText: item.policyNumber,
                                  leftIcon: FaIcon(FontAwesomeIcons.fileLines, size: 18, color: Colors.black45),
                                  rightText: context.l10n.status,
                                  rightBottomText: item.status,
                                  rightIcon: FaIcon(FontAwesomeIcons.circleCheck, size: 18, color: Colors.black45),
                                ),
                              ],
                              Divider(),
                              ItemDescription(
                                leftText: context.l10n.createdDate,
                                leftBottomText: item is Contract ? item.createdDate : (item as Insurance).createdDate,
                                leftIcon: Icon(Icons.calendar_today, size: 18, color: Colors.black45),
                                rightText: context.l10n.dueDate,
                                rightBottomText: item is Contract && item.dueDate != null ? item.dueDate! : (item as Insurance).createdDate,
                                rightIcon: Icon(Icons.calendar_today, size: 18, color: Colors.black45),
                              )
                            ]
                          ),
                        ),
                      ),
                    );
                  }, 
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardHeader extends StatelessWidget {

  final String id;
  final String type;
  final String status;
  final Widget? icon;

  CardHeader({
    super.key,
    required this.id,
    required this.type,
    required this.status,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            icon ?? FaIcon(FontAwesomeIcons.fileInvoice, color: Colors.green,),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(type, style: TextStyle(color: Colors.black45, fontSize: 12), )
              ]
            )
          ],
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: getStatusColor(status)
          ),
          child: Text(status == "Active" ? context.l10n.active : status == "Finished" ? context.l10n.finish : status == "Rejected" ? context.l10n.rejected : "", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
      ],
    );
  }

  // Buat status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active' :
        return Colors.green;
      case 'finished':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class ItemDescription extends StatelessWidget {

  String leftText;
  String rightText;
  String leftBottomText;
  String rightBottomText;
  Widget? leftIcon;
  Widget? rightIcon;

  ItemDescription({
    super.key,
    this.leftText = "",
    this.rightText = "",
    this.leftBottomText = "",
    this.rightBottomText = "",
    this.leftIcon,
    this.rightIcon
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Center(child: leftIcon ?? Icon(Icons.money,))),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(leftText, style: TextStyle(color: Colors.black45, fontSize: 12)),
                  Text(leftBottomText, style: TextStyle(fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: rightIcon ?? Icon(Icons.abc))),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rightText, style: TextStyle(color: Colors.black45, fontSize: 12)),
                  Text(rightBottomText, style: TextStyle(fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}