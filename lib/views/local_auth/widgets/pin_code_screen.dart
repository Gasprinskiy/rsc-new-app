import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/constants/app_theme.dart';

class PinCodeWidget extends StatefulWidget {
  final void Function(List<String>)? onEnter;
  final bool Function(List<String>)? validator;
  final void Function()? onBiometricsClicked;
  final int? pinLenght;
  final bool? isValid;
  final double padding;
  final String title;
  final String submitText;

  const PinCodeWidget(
      {super.key,
      required this.onEnter,
      required this.padding,
      required this.title,
      required this.submitText,
      this.validator,
      this.isValid,
      this.onBiometricsClicked,
      this.pinLenght});

  @override
  State<PinCodeWidget> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PinCodeWidget> {
  void Function(List<String>)? onEnter;
  bool Function(List<String>)? validator;
  void Function()? onBiometricsClicked;
  bool? isValid;
  late double padding;
  late String title;
  late String submitText;
  late int pinLenght;

  final List<String> _pin = [];
  int _animationKey = 0;
  double _animationEnd = 0.0;

  @override
  void initState() {
    super.initState();
    onEnter = widget.onEnter;
    validator = widget.validator;
    onBiometricsClicked = widget.onBiometricsClicked;
    padding = widget.padding;
    title = widget.title;
    submitText = widget.submitText;
    isValid = widget.isValid;
    pinLenght = widget.pinLenght ?? 4; // TO:DO make pin length
  }

  final Map<String, List<String>> _pinRows = {
    '1': ['1', '2', '3'],
    '2': ['4', '5', '6'],
    '3': ['7', '8', '9']
  };

  MaterialStateProperty<Size> getButtonSize() {
    return MaterialStateProperty.all(Size(
        (MediaQuery.of(context).size.width - 40) * 0.33,
        (MediaQuery.of(context).size.width - 40) * 0.2));
  }

  List<TextButton> getButtonsByMapKey(String key) {
    return _pinRows[key]!.map((item) {
      return TextButton(
        style: ButtonStyle(fixedSize: getButtonSize()),
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        onPressed: () => addPinValue(item),
      );
    }).toList();
  }

  List<Container> getPinMask() {
    return [1, 2, 3, 4].map((item) {
      return Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
            color: _pin.length >= item ? AppColors.primary : Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
      );
    }).toList();
  }

  void addPinValue(String value) {
    if (_pin.length < 4) {
      setState(() {
        _pin.add(value);
      });
    }
  }

  void removeLastPinValue() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.removeLast();
      });
    }
  }

  void clearPinCode() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin.clear();
      });
    }
  }

  void showEasterEgg() {
    if (_animationKey == 100) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                title: const Text(AppStrings.tiChoYebanulsa),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(AppStrings.no)),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(AppStrings.yes))
                ],
              ));
    }
  }

  void executeOnEnter() {
    bool? validatorState = validator?.call(_pin);
    bool isPinValid = validatorState != null
        ? (_pin.length == 4 && validatorState != false)
        : _pin.length == 4;

    if (isPinValid) {
      onEnter?.call(_pin);
    } else {
      clearPinCode();
      setState(() {
        if (_animationEnd == 0.0) {
          _animationEnd = 1.0;
        }
        _animationKey += 1;
      });
      showEasterEgg();
    }
  }

  double shakeAnimation(double animation) =>
      2 * (0.5 - (0.5 - Curves.bounceOut.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTheme.titleLargeGrey,
                textAlign: TextAlign.center,
              )
            ],
          ),
          Expanded(
            flex: 1,
            child: Align(
                key: ValueKey(_animationKey),
                alignment: Alignment.center,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, animation, child) => Transform.translate(
                    offset: Offset(20 * shakeAnimation(animation), 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [...getPinMask()],
                    ),
                  ),
                )
                //
                ),
          ),
          Expanded(
            flex: 2,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Row(
                        children: [...getButtonsByMapKey('1')],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [...getButtonsByMapKey('2')],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [...getButtonsByMapKey('3')],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          onBiometricsClicked != null
                              ? IconButton(
                                  onPressed: onBiometricsClicked,
                                  style:
                                      ButtonStyle(fixedSize: getButtonSize()),
                                  icon: const Icon(Icons.fingerprint))
                              : SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 40) *
                                          0.33,
                                  height:
                                      (MediaQuery.of(context).size.width - 40) *
                                          0.2),
                          TextButton(
                              onPressed: () => addPinValue('0'),
                              style: ButtonStyle(fixedSize: getButtonSize()),
                              child: const Text(
                                '0',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 24),
                              )),
                          IconButton(
                              onPressed: removeLastPinValue,
                              style: ButtonStyle(fixedSize: getButtonSize()),
                              icon: const Icon(Icons.backspace_outlined))
                        ],
                      ),
                    ]),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: executeOnEnter,
                      child: Text(
                        submitText,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    ));
  }
}
