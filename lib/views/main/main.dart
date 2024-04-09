import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/state/accounting.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/tools/datetime.dart';
import 'package:rsc/tools/extensions.dart';
import 'package:rsc/utils/event_bus.dart';
import 'package:rsc/widgets/toast.dart';
import 'package:rsc/views/main/children/accounting/accounting.dart';
import 'package:rsc/views/main/children/home.dart';
import 'package:rsc/views/main/children/user/user.dart';

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int _selectedViewIndex = 0;
  String _greetByHour = greetByHour().capitalize();
  bool _hasUnSyncData = false;
  bool _isSyncInProgress = false;
  bool _showGreet = true;

  final appToast = AppToast.getInstance();
  final userState = UserState.getInstance();
  final accountingState = AccountingState.getInstance();
  final appBus = AppEventBus.getInstance();

  static const List<Widget> viewOptions = [
    Home(),
    Accounting(),
    UserRoute(),
  ];

  @override
  void initState() {
    super.initState();
    _setGreedByHourTimer();
    _checkSyncData();
  }

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _selectedViewIndex = index;
      if (index == 2) {
        _showGreet = false;
      } else {
        _showGreet = true;
      }
    });
  }

  void _setGreedByHourTimer() {
    Timer.periodic(const Duration(minutes: 30), (timer) {
      setState(() {
        _greetByHour = greetByHour().capitalize();
      });
    });
  }

  void _checkSyncData() {
    accountingState.hasDataToSync().then((value) {
      setState(() {
        _hasUnSyncData = value;
      });
    });
    appBus.on<SynchronizationDoneEvent>().listen((event) {
      setState(() {
        if (event.failedSyncCount > 0) {
          _hasUnSyncData = true;
        } else {
          _hasUnSyncData = false;
        }
      });
    });
  }

  Future<void> _syncData() async {
    if (_hasUnSyncData) {
      setState(() {
        _isSyncInProgress = true;
      });
      await accountingState.syncAllData();
      setState(() {
        _isSyncInProgress = false;
      });
    } else {
      appToast.showWarnToast(AppStrings.noDataToSync);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showGreet
          ? PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: DecoratedBox(
                decoration: const BoxDecoration(color: AppColors.primary),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              _greetByHour,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              userState.user!.personalInfo.name,
                              style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        _isSyncInProgress
                            ? const TextButton(
                                onPressed: null,
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    backgroundColor: AppColors.primary,
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                ))
                            : TextButton(
                                onPressed: () {
                                  appToast.init(context);
                                  _syncData();
                                },
                                child: !_hasUnSyncData ? const Icon(Icons.cloud_queue_rounded, color: Colors.white) : const Icon(Icons.cloud_off_rounded, color: AppColors.warn))
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: viewOptions.elementAt(_selectedViewIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Отчет',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_sharp),
            label: 'Польователь',
          ),
        ],
        currentIndex: _selectedViewIndex,
        selectedItemColor: AppColors.primary,
        onTap: _onBottomBarItemTapped,
      ),
    );
  }
}
