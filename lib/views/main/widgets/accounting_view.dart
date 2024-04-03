
// import 'package:accordion/accordion.dart';
// import 'package:accordion/accordion_section.dart';
// import 'package:animated_digit/animated_digit.dart';
// import 'package:flutter/material.dart';
// import 'package:rsc/constants/app_collors.dart';
// import 'package:rsc/constants/app_strings.dart';
// import 'package:rsc/core/accounting_calculations.dart';
// import 'package:rsc/core/entity.dart';
// import 'package:rsc/storage/hive/entity/adapters.dart';
// import 'package:rsc/tools/datetime.dart';
// import 'package:rsc/tools/number.dart';
// import 'package:rsc/widgets/decoration_box.dart';

// class AccountingView extends StatefulWidget {
//   final User? user;
//   final List<Sale> sales;
//   final List<Prepayment> prepayments;
//   final List<Tip> tips;
//   final bool? readOnly;
//   final void Function(Sale)? onSaleClicked;
//   final void Function(Tip)? onTipClicked;
//   final void Function(Prepayment)? onPrepaymentClicked;

//   const AccountingView({
//     super.key,
//     this.user,
//     this.readOnly,
//     required this.sales,
//     required this.prepayments,
//     required this.tips,
//     this.onSaleClicked,
//     this.onTipClicked,
//     this.onPrepaymentClicked
//   });

//   @override
//   State<AccountingView> createState() => _AccountingViewState();
// }

// class _AccountingViewState extends State<AccountingView> {
//   late bool readOnly;
//   late User? user;
//   late List<Sale> sales;
//   late List<Prepayment> prepayments;
//   late List<Tip> tips;
//   late void Function(Sale)? onSaleClicked;
//   late void Function(Tip)? onTipClicked;
//   late void Function(Prepayment)? onPrepaymentClicked;

//   final calcCore = AccountingCalculations.getInstance();
  
//   double _commonSalary = 0;

//   void setCommonSalary() {
//     List<PercentChangeRule>? percentChangeRules = user?.percentChangeConditions?.map((item) {
//       return PercentChangeRule(
//         percentGoal: item.percentGoal, 
//         percentChange: item.percentChange, 
//         salaryBonus: item.salaryBonus ?? 0
//       );
//     }).toList();
//     setState(() {
//       _commonSalary = calcCore.calcCommonSalary(
//         CalcCommonSalaryOptions(
//           sales: sales.isNotEmpty ? sales.map((item) => item.total).toList() : [], 
//           salary: user?.salaryInfo?.salary ?? 0, 
//           percentFromSales: user?.salaryInfo?.percentFromSales ?? 0,
//           ignorePlan: user?.salaryInfo?.ignorePlan ?? false, 
//           isVariablePercent: user?.percentChangeConditions != null, 
//           plan: user?.salaryInfo?.plan ?? 0, 
//           percentChangeRules: percentChangeRules ?? []
//         )
//       );
//     });
//   }
//   AccordionSection saleItems() {
//     if (sales.isNotEmpty) {
//       double percentFromSales = user?.salaryInfo?.percentFromSales ?? 0;
//       List<double> salesTotalList = sales.map((item) => item.total).toList();
//       List<double> cashTaxesTotalList = sales.map((item) => item.cashTaxes).toList();
//       List<double> nonCasTotalList = sales.map((item) => item.nonCash).toList();
//       double commonSales = calcCore.calcTotal(salesTotalList);
//       double commonCashTaxes = calcCore.calcTotal(cashTaxesTotalList);
//       double commonNonCash = calcCore.calcTotal(nonCasTotalList);
//       ReachedConditionResult? reachedConditions = calcCore.findReachedConditions(
//           FindReachedConditionsOptions(
//             sales: salesTotalList, 
//             plan: user!.salaryInfo!.plan!, 
//             rules: user!.percentChangeConditions!.map((item) {
//               return PercentChangeRule(
//                 percentGoal: item.percentGoal, 
//                 percentChange: item.percentChange, 
//                 salaryBonus: item.salaryBonus != null ? item.salaryBonus! : 0
//               );
//             }).toList()
//           )
//         );
//       if (reachedConditions != null) {
//         percentFromSales = reachedConditions.changedPercent;
//       }
      
//       return AccordionSection(
//           header: const Text(
//             AppStrings.sales,
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.white,
//               fontWeight: FontWeight.w500
//             ),
//           ),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 AppStrings.commoData,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500
//                 ),
//                 textAlign: TextAlign.start,
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: DecoratedBox(
//                   decoration: const BoxDecoration(
//                     color: AppColors.primaryTransparent,
//                     borderRadius: BorderRadius.all(Radius.circular(5))
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('${AppStrings.cashTaxes}:', style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500
//                             )),
//                             DecoratedBox(
//                               decoration: const BoxDecoration(
//                                 color: AppColors.primary,
//                                 borderRadius: BorderRadius.all(Radius.circular(3))
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(5),
//                                 child: Text(currencyFormat(commonCashTaxes), style: const TextStyle(
//                                   color: Colors.white
//                                 )),
//                               ),
//                             )
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('${AppStrings.nonCash}:', style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500
//                             )),
//                             DecoratedBox(
//                               decoration: const BoxDecoration(
//                                 color: AppColors.primary,
//                                 borderRadius: BorderRadius.all(Radius.circular(3))
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(5),
//                                 child: Text(currencyFormat(commonNonCash), style: const TextStyle(
//                                   color: Colors.white
//                                 )),
//                               ),
//                             )
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text('${AppStrings.sales}:', style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500
//                             )),
//                             DecoratedBox(
//                               decoration: const BoxDecoration(
//                                 color: AppColors.primary,
//                                 borderRadius: BorderRadius.all(Radius.circular(3))
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(5),
//                                 child: Text(currencyFormat(commonSales), style: const TextStyle(
//                                   color: Colors.white
//                                 )),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 AppStrings.detailData,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500
//                 ),
//                 textAlign: TextAlign.start,
//               ),
//               const SizedBox(height: 10),
//               ...sales.map((item) {
//               return Column(
//                 children: [
//                 const SizedBox(height: 10),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: DecoratedBox(
//                     decoration: const BoxDecoration(
//                       color: AppColors.primaryTransparent,
//                       borderRadius: BorderRadius.all(Radius.circular(5))
//                     ),
//                     child: TextButton(
//                       style: ButtonStyle(
//                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           )
//                         )
//                       ),
//                       onPressed: () => {
                        
//                       },
//                       child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     const Text('${AppStrings.cashTaxes}:', style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500
//                                     )),
//                                     DecoratedBox(
//                                       decoration: const BoxDecoration(
//                                         color: AppColors.primary,
//                                         borderRadius: BorderRadius.all(Radius.circular(3))
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(5),
//                                         child: Text(currencyFormat(item.cashTaxes), style: const TextStyle(
//                                           color: Colors.white
//                                         )),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     const Text('${AppStrings.nonCash}:', style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500
//                                     )),
//                                     DecoratedBox(
//                                       decoration: const BoxDecoration(
//                                         color: AppColors.primary,
//                                         borderRadius: BorderRadius.all(Radius.circular(3))
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(5),
//                                         child: Text(currencyFormat(item.nonCash), style: const TextStyle(
//                                           color: Colors.white
//                                         )),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     const Text('${AppStrings.total}:', style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500
//                                     )),
//                                     DecoratedBox(
//                                       decoration: const BoxDecoration(
//                                         color: AppColors.primary,
//                                         borderRadius: BorderRadius.all(Radius.circular(3))
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(5),
//                                         child: Text(currencyFormat(item.total), style: const TextStyle(
//                                           color: Colors.white
//                                         )),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 percentFromSales > 0
//                                 ?
//                                 Column(
//                                   children: [
//                                     const SizedBox(height: 10),
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         const Text('${AppStrings.percentFromSales}:', style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500
//                                         )),
//                                         DecoratedBox(
//                                           decoration: const BoxDecoration(
//                                             color: AppColors.primary,
//                                             borderRadius: BorderRadius.all(Radius.circular(5))
//                                           ),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(3),
//                                             child: Text(
//                                               currencyFormat(
//                                                 calcCore.calcPercent(item.total, percentFromSales)
//                                               ), 
//                                               style: const TextStyle(
//                                                 color: Colors.white
//                                               )
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 )
//                                 :
//                                 const SizedBox(height: 0),
//                                 const SizedBox(height: 10),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     const Text('${AppStrings.date}:', style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500
//                                     )),
//                                     DecoratedBox(
//                                       decoration: const BoxDecoration(
//                                         color: AppColors.primary,
//                                         borderRadius: BorderRadius.all(Radius.circular(5))
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(3),
//                                         child: Text(monthDateYear(item.creationDate), style: const TextStyle(
//                                           color: Colors.white
//                                         )),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                       )
//                     )
//                   )
//                 ],
//               );
//             }).toList(),
//             ]
//           )
//       );
//     }
//     return AccordionSection(
//       header: const Text(
//         AppStrings.sales,
//         style: TextStyle(
//           fontSize: 18,
//           color: Colors.white,
//           fontWeight: FontWeight.w500
//         ),
//       ),
//       content: const Center(
//         child: Column(
//           children: [
//             Icon(Icons.not_interested_rounded, color: Colors.grey),
//             Text(AppStrings.salesNotFound, style: TextStyle(color : Colors.grey))
//           ],
//         ),
//       )
//     );
//   }

//   AccordionSection prepaymentsItem() {
//     if (prepayments.isNotEmpty) {
//       double commonAmount = calcCore.calcTotal(prepayments.map((item) => item.value).toList());
//       return AccordionSection(
//         header: const Text(
//           AppStrings.prepayments,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.w500
//           ),
//         ),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               AppStrings.commoData,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500
//               ),
//               textAlign: TextAlign.start,
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: DecoratedBox(
//                 decoration: const BoxDecoration(
//                   color: AppColors.primaryTransparent,
//                   borderRadius: BorderRadius.all(Radius.circular(5))
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('${AppStrings.amount}:', style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500
//                           )),
//                           DecoratedBox(
//                             decoration: const BoxDecoration(
//                               color: AppColors.primary,
//                               borderRadius: BorderRadius.all(Radius.circular(3))
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(5),
//                               child: Text(currencyFormat(commonAmount), style: const TextStyle(
//                                 color: Colors.white
//                               )),
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               AppStrings.detailData,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500
//               ),
//               textAlign: TextAlign.start,
//             ),
//             const SizedBox(height: 10),
//             ...prepayments.map((item) {
//               return Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: DecoratedBox(
//                       decoration: const BoxDecoration(
//                         color: AppColors.primaryTransparent,
//                         borderRadius: BorderRadius.all(Radius.circular(5))
//                       ),
//                       child: TextButton(
//                         style: ButtonStyle(
//                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5),
//                             )
//                           )
//                         ),
//                         onPressed: () => {
                          
//                         }, 
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text('${AppStrings.amount}:', style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500
//                                 )),
//                                 DecoratedBox(
//                                   decoration: const BoxDecoration(
//                                     color: AppColors.primary,
//                                     borderRadius: BorderRadius.all(Radius.circular(3))
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(5),
//                                     child: Text(currencyFormat(item.value), style: const TextStyle(
//                                       color: Colors.white
//                                     )),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text('${AppStrings.creationDate}:', style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500
//                                 )),
//                                 DecoratedBox(
//                                   decoration: const BoxDecoration(
//                                     color: AppColors.primary,
//                                     borderRadius: BorderRadius.all(Radius.circular(3))
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(5),
//                                     child: Text(monthDateYear(item.creationDate), style: const TextStyle(
//                                       color: Colors.white
//                                     )),
//                                   ),
//                                 )
//                               ],
//                             )
//                           ],
//                         )
//                       ),
//                     )
//                   )
//                 ]
//               );
//             })
//           ],
//         ),
//       );
//     }
//     return AccordionSection(
//       header: const Text(
//         AppStrings.prepayments,
//         style: TextStyle(
//           fontSize: 18,
//           color: Colors.white,
//           fontWeight: FontWeight.w500
//         ),
//       ),
//       content: const Center(
//         child: Column(
//           children: [
//             Icon(Icons.not_interested_rounded, color: Colors.grey),
//             Text(AppStrings.prepaymentsNotFound, style: TextStyle(color : Colors.grey))
//           ],
//         ),
//       )
//     );
//   }

//   AccordionSection tipsItem() {
//     if (tips.isNotEmpty) {
//       double commonAmount = calcCore.calcTotal(tips.map((item) => item.value).toList());
//       return AccordionSection(
//         header: const Text(
//           AppStrings.tips,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.white,
//             fontWeight: FontWeight.w500
//           ),
//         ),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               AppStrings.commoData,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500
//               ),
//               textAlign: TextAlign.start,
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: DecoratedBox(
//                 decoration: const BoxDecoration(
//                   color: AppColors.primaryTransparent,
//                   borderRadius: BorderRadius.all(Radius.circular(5))
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text('${AppStrings.amount}:', style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500
//                           )),
//                           DecoratedBox(
//                             decoration: const BoxDecoration(
//                               color: AppColors.primary,
//                               borderRadius: BorderRadius.all(Radius.circular(3))
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(5),
//                               child: Text(currencyFormat(commonAmount), style: const TextStyle(
//                                 color: Colors.white
//                               )),
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 )
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               AppStrings.detailData,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500
//               ),
//               textAlign: TextAlign.start,
//             ),
//             const SizedBox(height: 10),
//             ...tips.map((item) {
//               return Column(
//                 children: [
//                   const SizedBox(height: 10),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: DecoratedBox(
//                       decoration: const BoxDecoration(
//                         color: AppColors.primaryTransparent,
//                         borderRadius: BorderRadius.all(Radius.circular(5))
//                       ),
//                       child: TextButton(
//                         style: ButtonStyle(
//                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5),
//                             )
//                           )
//                         ),
//                         onPressed: () => {
                          
//                         }, 
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text('${AppStrings.amount}:', style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500
//                                 )),
//                                 DecoratedBox(
//                                   decoration: const BoxDecoration(
//                                     color: AppColors.primary,
//                                     borderRadius: BorderRadius.all(Radius.circular(3))
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(5),
//                                     child: Text(currencyFormat(item.value), style: const TextStyle(
//                                       color: Colors.white
//                                     )),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text('${AppStrings.creationDate}:', style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500
//                                 )),
//                                 DecoratedBox(
//                                   decoration: const BoxDecoration(
//                                     color: AppColors.primary,
//                                     borderRadius: BorderRadius.all(Radius.circular(3))
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(5),
//                                     child: Text(monthDateYear(item.creationDate), style: const TextStyle(
//                                       color: Colors.white
//                                     )),
//                                   ),
//                                 )
//                               ],
//                             )
//                           ],
//                         )
//                       ),
//                     )
//                   )
//                 ]
//               );
//             })
//           ],
//         ),
//       );
//     }
//     return AccordionSection(
//       header: const Text(
//         AppStrings.tips,
//         style: TextStyle(
//           fontSize: 18,
//           color: Colors.white,
//           fontWeight: FontWeight.w500
//         ),
//       ),
//       content: const Center(
//         child: Column(
//           children: [
//             Icon(Icons.not_interested_rounded, color: Colors.grey),
//             Text(AppStrings.tipsNotFound, style: TextStyle(color : Colors.grey))
//           ],
//         ),
//       )
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     readOnly = widget.readOnly ?? true;
//     user = widget.user;
//     sales = widget.sales;
//     prepayments = widget.prepayments;
//     tips = widget.tips;
//     onSaleClicked = widget.onSaleClicked;
//     onTipClicked = widget.onTipClicked;
//     onPrepaymentClicked = widget.onPrepaymentClicked;

//     setCommonSalary();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         DecorationBox(
//           top: 0,
//           children: [
//               const Text(
//                 AppStrings.commonSalary,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               AnimatedDigitWidget(
//                 value: _commonSalary,
//                 enableSeparator: true,
//                 textStyle: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 38,
//                 ),
//                 duration: const Duration(milliseconds: 500),
//               ),
//               const SizedBox(height: 10),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Accordion(
//               paddingBetweenClosedSections: 10,
//               paddingBetweenOpenSections: 10,
//               headerPadding: const EdgeInsets.all(10),
//               openAndCloseAnimation: false,
//               children: [
//                 saleItems(),
//                 prepaymentsItem(),
//                 tipsItem()
//               ],
//             )
//           )
//       ],
//     );
//   }
// }