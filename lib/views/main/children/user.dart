import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/state/accounting.dart';
import 'package:rsc/storage/hive/synchronization_data.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/widgets/toast.dart';
class UserRoute extends StatefulWidget {
  const UserRoute({super.key});

  @override
  State<UserRoute> createState() => _UserState();
}

class _UserState extends State<UserRoute> {
  final accountingState = AccountingState.getInstance();
  final appToast = AppToast.getInstance();
  final syst = SynchronizationDataStorage.getInstance();
  bool _isSyncInProgress = false;

  Sale sale = Sale(
    total: 1000000,
    nonCash: 200000,
    cashTaxes: 600000,
    creationDate: DateTime.now(),
  );

  Tip tip = Tip(
    value: 100000,
    creationDate: DateTime.now()
  );

  Prepayment prepayment = Prepayment(
    value: 1000000,
    creationDate: DateTime.now()
  );
  

  @override
  void initState() {
    super.initState();
  }

  Future<void> getFuck() async {
    List<SynchronizationData>? list = await syst.getSynchronizationData();
    if (list != null) {
      for (var element in list) {
        print('element: ${element.data}');
      }
    }
  }

  Future<void> update() async {
    List<SynchronizationData>? list = await syst.getSynchronizationData();
    if (list != null && list[0].data is Sale) {
      Sale shit = list[0].data;
      shit.cashTaxes = 2000;
      await accountingState.updateAndSyncSale(shit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => {
                appToast.init(context),
                accountingState.addAndSyncSale(sale)
              }, 
              child: const Text('Add')
            ),
            ElevatedButton(
              onPressed: () => {
                appToast.init(context),
                accountingState.addAndSyncTip(tip)
              }, 
              child: const Text('Add tip')
            ),
            ElevatedButton(
              onPressed: () => {
                appToast.init(context),
                accountingState.addAndSyncPrepayment(prepayment)
              }, 
              child: const Text('Add prepayment')
            ),
            ElevatedButton(
              onPressed: () => {
                appToast.init(context),
                update(),
              }, 
              child: const Text('Update')
            ),
            ElevatedButton(
              onPressed: () async => {
                appToast.init(context),
                setState(() {
                  _isSyncInProgress = true;
                }),
                await accountingState.syncAllData(),
                setState(() {
                  _isSyncInProgress = false;
                }),
              }, 
              child: const Text('Sync')
            ),
            ElevatedButton(
              onPressed: getFuck, 
              child: const Text('getFuck')
            ),
            _isSyncInProgress ? const CircularProgressIndicator(
              backgroundColor: AppColors.primary,
              color: Colors.white,
            ) : const SizedBox(height: 0,)
          ],
        )
      ),
    );
  }
}
