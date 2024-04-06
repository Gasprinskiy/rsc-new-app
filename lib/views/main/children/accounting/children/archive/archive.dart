
import 'package:flutter/material.dart';
import 'package:rsc/api/acounting.dart';
import 'package:rsc/api/entity/accounting.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/tools/datetime.dart';
import 'package:rsc/tools/number.dart';
import 'package:rsc/widgets/button_box.dart';
import 'package:rsc/widgets/date_range_filter.dart';

class ArchiveData extends StatefulWidget {
  const ArchiveData({super.key});

  @override
  State<ArchiveData> createState() => _ArchiveDataState();
}

class _ArchiveDataState extends State<ArchiveData> {
  final api = AccountingApi.getInstance();

  List<AccountingReport> data = [];
  int totalCount = 0;
  int totalPage = 0;
  int limit = 1;
  int currentPage = 1;
  bool isLoading = true;
  bool isLoadingMore = false;

  DateTime dateFrom = DateTime(DateTime.now().year);
  DateTime dateTo = DateTime.now();

  Future<void> getAcrhivedData() async {
    FindArchivedAccountingReportsResult result = await api.findUserArchivedReportsByDateRange(
      FindArchivedAccountingReportsParams(
        dateRange: ArchivedReportsDateRange(
          from: dateFrom,
          to: dateTo
        ), 
        pagination: FindArchivedAccountngPaginParams(
          limit: limit,
          offset: currentPage
        )
      )
    );
    
    setState(() {
      totalCount = result.totalCount;
      totalPage = result.totalPage;
      data = [...data, ...result.reports];
    });
  }

  Future<void> getDateRange() async {
    ArchivedReportsDateRange? value = await api.getArchivedReportsDateRange();
    if (value != null) {
      setState(() {
        dateFrom = value.from;
        dateTo = value.to;
      });
    }
  }

  void executeInitialData() {
    getDateRange().then((_) {
      getAcrhivedData();
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> loadMore() async {
    setState(() {
      isLoadingMore = true;
      currentPage += 1;
    });
    await Future.delayed(Duration(seconds: 3));
    await getAcrhivedData();
    setState(() {
      isLoadingMore = false;
    });
  }

  void navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    executeInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
                        IconButton(
                          onPressed: navigateBack,
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded, 
                            color: Colors.white
                          )
                        ),
                        const Text(
                          AppStrings.archive,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    )
                  ]
                )    
              ],
            ),
          ),
      ),
      body: 
      isLoading
      ?
      const Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.primary,
          color: Colors.white,
        ),
      )
      :
      ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DateRangeFilter(
            from: dateFrom,
            to: dateTo,
            onSubmit: (from, to) => {},
            onReset: () => {},
          ),
          const Divider(height: 20),
          data.isNotEmpty
          ?
          Column(
            children: [
              ...data.map((item) {
                return Column(
                  children: [
                    ButtonBox(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('${AppStrings.amount}:', style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                              )),
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.all(Radius.circular(3))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(currencyFormat(item.total ?? 0), style: const TextStyle(
                                    color: Colors.white
                                  )),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('${AppStrings.creationDate}:', style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                              )),
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.all(Radius.circular(3))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(monthDateYear(item.creationDate), style: const TextStyle(
                                    color: Colors.white
                                  )),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ),
                    const SizedBox(height: 10)
                  ]
                );
              }),
              isLoadingMore 
              ?
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.primary,
                  color: Colors.white,
                ),
              )
              :
              const SizedBox(width: 0),
              totalPage > currentPage
              ?
              Column(
                children: [
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => !isLoadingMore ? loadMore() : null,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )
                      ),
                      // backgroundColor: MaterialStateProperty.all(AppColors.warnTransparent),
                      backgroundColor: MaterialStateProperty.all(AppColors.primaryTransparent)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${AppStrings.loadMore} $limit', style: const TextStyle(fontSize: 18)),
                      ],
                    )
                  ),
                ],
              )
              :
              const SizedBox(height: 20),
            ],
          )
          :
          SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: const Center(
              child: Text(AppStrings.dataNotFound, style: TextStyle(fontSize: 20))
            ),
          )
        ],
      ),
    );
  }
}