import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BanksPage extends StatefulWidget {
  @override
  State<BanksPage> createState() => _BanksPageState();
}

class _BanksPageState extends State<BanksPage> {
  List<BusinessBankModal> businessBanks = [];

  int length = 0;

  var bank = BusinessBankModal();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var args = ModalRoute.of(context)?.settings.arguments;
      businessBanks = args as List<BusinessBankModal>;
      setState(() => length = businessBanks.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Our Bankers'.toUpperCase())),
      body: ListView(children: [
        EditTextForm(
          'Bank Name',
          bank.name,
          keyboardType: TextInputType.name,
          onChanged: (value) => bank.name = value.toUpperCase(),
          readOnly: false,
          top: 18,
        ),
        EditTextForm(
          'ifsc code',
          bank.ifsc,
          keyboardType: TextInputType.text,
          onChanged: (value) => bank.ifsc = value.toUpperCase(),
          readOnly: false,
        ),
        EditTextForm(
          'Account Number',
          bank.number,
          keyboardType: TextInputType.phone,
          onChanged: (value) => bank.number = value.toUpperCase(),
          readOnly: false,
        ),
        EditTextForm(
          'Branch',
          bank.branch,
          keyboardType: TextInputType.text,
          onChanged: (value) => bank.branch = value.toUpperCase(),
          readOnly: false,
        ),
        EditTextForm(
          'Account holder name',
          bank.holder,
          keyboardType: TextInputType.text,
          onChanged: (value) => bank.holder = value.toUpperCase(),
          readOnly: false,
        ),
        EditTextForm(
          'BHIM UPI',
          bank.upi,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => bank.upi = value,
          readOnly: false,
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 12),
          child: ElevatedButton(
            onPressed: () {
              if (bank.isNotEmpty)
                setState(() {
                  businessBanks.add(bank);
                  bank = BusinessBankModal();
                });
            },
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
                padding: EdgeInsets.all(12),
                shape: CircleBorder(),
                primary: Colors.orange),
            child: Icon(Icons.add),
          ),
        ),
        ...businessBanks
            .map((e) => ListTile(
                  leading: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.green,
                  ),
                  title: Text('${e.name}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() => businessBanks.remove(e));
                    },
                  ),
                ))
            .toList(),
        Container(
          padding: EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () {
              if (bank.isNotEmpty) {
                businessBanks.add(bank);
                bank = BusinessBankModal();
                Navigator.pop(context, businessBanks);
              } else if (length != businessBanks.length) {
                Navigator.pop(context, businessBanks);
              }
            },
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
                padding: EdgeInsets.all(12),
                minimumSize: Size(180, 45),
                primary: Colors.blue[300]),
            child: Text('UPDATE'),
          ),
        )
      ]),
    );
  }
}
