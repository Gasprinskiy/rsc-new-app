
import 'package:flutter/material.dart';
import 'package:rsc/state/accounting.dart';
import 'package:rsc/state/entity/entity.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/view-widgets/tips_screen.dart';
import 'package:rsc/widgets/toast.dart';

class TipsDetails extends StatefulWidget {
  const TipsDetails({super.key});

  @override
  State<TipsDetails> createState() => _TipsDetailsState();
}

class _TipsDetailsState extends State<TipsDetails> { 
  final accountingState = AccountingState.getInstance();
  final appTaost = AppToast.getInstance();

  List<Tip> tips = [];

  void initPrepayments() {
    accountingState.getTipList().then((value) {
      if (value != null) {
        setState(() {
          tips = value;
        });
      }
    });
  }

  Future<void> redactTips(Tip tip) async {
    appTaost.init(context);

    int updatedIndex = tips.indexWhere((element) => element.id == tip.id);
    if (updatedIndex >= 0) {
      tips[updatedIndex] = tip;
      await accountingState.updateAndSyncTip(tip);
      accountingState.setUpdatedValuesCount(UpdatedValuesType.tip, 1);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrepayments();
  }

  @override
  Widget build(BuildContext context) {
    return TipsScreen(
      key: ValueKey(tips.length),
      tips: tips,
      onRedact: redactTips,
    );
  }
}