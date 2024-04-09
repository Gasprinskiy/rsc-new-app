
import 'package:flutter/material.dart';
import 'package:rsc/api/entity/accounting.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/tools/datetime.dart';
import 'package:rsc/tools/extensions.dart';
import 'package:rsc/view-widgets/sales_screen.dart';
import 'package:rsc/widgets/back_appbar.dart';

class SalesArchivedDetails extends StatefulWidget {
  final List<ApiSale> data;
  final DateTime creationDate;
  const SalesArchivedDetails({
    super.key, 
    required this.data,
    required this.creationDate
  });

  @override
  State<SalesArchivedDetails> createState() => _SalesArchivedDetailsState();
}

class _SalesArchivedDetailsState extends State<SalesArchivedDetails> { 
  late List<ApiSale> data;
  late DateTime creationDate;

  @override
  void initState() {
    super.initState();
    data = widget.data;
    creationDate = widget.creationDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: BackAppBar(
          title: Text(
            '${AppStrings.sales} ${monthAndYear(creationDate).capitalize()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
          )
        )
      ),
      body: SalesScreen(
        key: ValueKey(data.length),
        sales: data.map((item) {
          return Sale(
            total: item.total, 
            nonCash: item.nonCash, 
            cashTaxes: item.cashTaxes, 
            creationDate: item.creationDate
          );
        }).toList(),
      ),
    );
  }
}