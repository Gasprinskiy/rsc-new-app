
import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/views/main/children/accounting/children/details/children/prepayments.dart';
import 'package:test_flutter/views/main/children/accounting/children/details/children/sales.dart';
import 'package:test_flutter/views/main/children/accounting/children/details/children/tips.dart';
import 'package:test_flutter/views/main/entity/entity.dart';

class Details extends StatefulWidget {
  final DetailsScreenType type;
  const Details({super.key, required this.type});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late DetailsScreenType type;

  static const Map<DetailsScreenType, Widget> viewsMap = {
    DetailsScreenType.sales: SalesScreen(),
    DetailsScreenType.prepayments: PrepaymentsScreen(),
    DetailsScreenType.tips: TipsScreen()
  };

  static const Map<DetailsScreenType, String> topTitleMap = {
    DetailsScreenType.sales: AppStrings.sales,
    DetailsScreenType.prepayments: AppStrings.prepayments,
    DetailsScreenType.tips: AppStrings.tips
  };
  
  void navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    type = widget.type;
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
                        Text(
                          topTitleMap[type] ?? '',
                          style: const TextStyle(
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
      body: viewsMap[type],
    );
  }
}