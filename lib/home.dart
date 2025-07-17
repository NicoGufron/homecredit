import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool sortChange = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text("My Contract List"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                if (mounted) {
                  setState(() {
                    sortChange = !sortChange;
                  });
                }
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
                  Text("Sort by Due Date ${sortChange ?  "(Earliest First)" : "(Latest First)" }")
                ],
              )
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
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
                          CardHeader(),
                          SizedBox(height: 25,),
                          ItemDescription(
                            leftText: "Due Amount",
                            leftIcon: FaIcon(FontAwesomeIcons.solidMoneyBill1, size: 18, color: Colors.black45,),
                            leftBottomText: "Rp. 350.000",
                            rightText: "Installment",
                            rightBottomText: "Rp. 350.000",
                            rightIcon: FaIcon(FontAwesomeIcons.creditCard, size: 18, color: Colors.black45,),
                          ),
                          SizedBox(height: 10,),
                          ItemDescription(
                            leftText: "Credit Amount",
                            leftBottomText: "Rp. 350.000",
                            leftIcon: FaIcon(FontAwesomeIcons.moneyBill, size: 18, color: Colors.black45),
                            rightText: "Tenor",
                            rightBottomText: "18 months",
                            rightIcon: FaIcon(FontAwesomeIcons.clock, size: 18, color: Colors.black45),
                          ),
                          Divider(),
                          ItemDescription(
                            leftText: "Created Date",
                            leftBottomText: "20 June 2025",
                            leftIcon: Icon(Icons.calendar_today, size: 18, color: Colors.black45),
                            rightText: "Due Date",
                            rightBottomText: "20 Dec 2025",
                            rightIcon: Icon(Icons.calendar_today, size: 18, color: Colors.black45),
                          )
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardHeader extends StatelessWidget {

  String id;
  String type;
  String status;
  Widget? icon;

  CardHeader({
    super.key,
    this.id = "",
    this.type = "",
    this.status = "",
    icon
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
                Text("1111222233", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(type == "" ? "Contract" : "Insurance", style: TextStyle(color: Colors.black45, fontSize: 12), )
              ]
            )
          ],
        ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.green
          ),
          child: Text("Active", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
      ],
    );
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
              leftIcon ?? Icon(Icons.money,),
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
              rightIcon ?? Icon(Icons.abc),
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