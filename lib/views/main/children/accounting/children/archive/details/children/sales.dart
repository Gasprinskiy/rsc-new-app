
import 'package:flutter/material.dart';
import 'package:rsc/state/accounting.dart';
import 'package:rsc/state/entity/entity.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/view-widgets/sales_screen.dart';
import 'package:rsc/widgets/toast.dart';

class SaleDetails extends StatefulWidget {
  const SaleDetails({
    super.key,
  });

  @override
  State<SaleDetails> createState() => _SaleDetailsState();
}

class _SaleDetailsState extends State<SaleDetails> {
  List<Sale> sales = [];

  final accountingState = AccountingState.getInstance();
  final appTaost = AppToast.getInstance();
  
  void initSales() {
    accountingState.getSaleList().then((value) {
      if (value != null) {
        setState(() {
          sales = value;
        });
      }
    });
  }

  Future<void> onSaleRedact(Sale sale) async {
    appTaost.init(context);

    int updatedIndex = sales.indexWhere((element) => element.id == sale.id);
    if (updatedIndex >= 0) {
      sales[updatedIndex] = sale;
      await accountingState.updateAndSyncSale(sale);
      accountingState.setUpdatedValuesCount(UpdatedValuesType.sale, 1);
    }
  }

  @override
  void initState() {
    super.initState();
    initSales();
  }

  @override
  Widget build(BuildContext context) {
    return SalesScreen(
      key: ValueKey(sales.length),
      sales: sales,
      onRedact: onSaleRedact,
    );
  }
}