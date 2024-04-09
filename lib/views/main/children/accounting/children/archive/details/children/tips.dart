
import 'package:flutter/material.dart';
import 'package:rsc/api/entity/accounting.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/tools/datetime.dart';
import 'package:rsc/tools/extensions.dart';
import 'package:rsc/view-widgets/tips_screen.dart';
import 'package:rsc/widgets/back_appbar.dart';

class TipsArchivedDetails extends StatefulWidget {
  final List<CommonAdditionalReportData> data;
  final DateTime creationDate;
  const TipsArchivedDetails({
    super.key, 
    required this.data,
    required this.creationDate
  });

  @override
  State<TipsArchivedDetails> createState() => _TipsArchivedDetailsState();
}

class _TipsArchivedDetailsState extends State<TipsArchivedDetails> { 
  late List<CommonAdditionalReportData> data;
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
            '${AppStrings.tips} ${monthAndYear(creationDate).capitalize()}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
          )
        )
      ),
      body: TipsScreen(
        key: ValueKey(data.length),
        tips: data.map((item) => Tip(value: item.value, creationDate: item.creationDate)).toList(),
      ),
    );
  }
}