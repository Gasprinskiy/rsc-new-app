
import 'package:flutter/material.dart';
import 'package:rsc/state/accounting.dart';
import 'package:rsc/state/entity/entity.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/view-widgets/prepayments_screen.dart';
import 'package:rsc/widgets/toast.dart';

class PrepaymentsDetails extends StatefulWidget {
  const PrepaymentsDetails({super.key});

  @override
  State<PrepaymentsDetails> createState() => _PrepaymentsDetailsState();
}

class _PrepaymentsDetailsState extends State<PrepaymentsDetails> { 
  final accountingState = AccountingState.getInstance();
  final appTaost = AppToast.getInstance();

  List<Prepayment> prepayments = [];

  void initPrepayments() {
    accountingState.getPrepaymentList().then((value) {
      if (value != null) {
        setState(() {
          prepayments = value;
        });
      }
    });
  }

  Future<void> redactPrepayment(Prepayment prepayment) async {
    appTaost.init(context);

    int updatedIndex = prepayments.indexWhere((element) => element.id == prepayment.id);
    if (updatedIndex >= 0) {
      prepayments[updatedIndex] = prepayment;
      await accountingState.updateAndSyncPrepayment(prepayment);
      accountingState.setUpdatedValuesCount(UpdatedValuesType.prepayment, 1);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrepayments();
  }

  @override
  Widget build(BuildContext context) {
    return PrepaymentsScreen(
      key: ValueKey(prepayments.length),
      prepayments: prepayments,
      onRedact: redactPrepayment,
    );
  }
}