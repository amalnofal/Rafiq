import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool? value; // اختياري، لو مش موجود هيستخدم الحالة الداخلية
  final ValueChanged<bool>? onChanged;

  const CustomSwitch({super.key, this.value, this.onChanged});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late bool _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.value ?? false;
  }

  void _toggleSwitch() {
    setState(() {
      _internalValue = !_internalValue;
    });

    if (widget.onChanged != null) widget.onChanged!(_internalValue);
  }

  @override
  Widget build(BuildContext context) {
    final bool displayValue = widget.value ?? _internalValue;

    // 🌟 ألوان حسب الثيم
    final theme = Theme.of(context);
    final Color backgroundColor = displayValue
        ? theme
              .colorScheme
              .primaryContainer //الخلفيهON
        : theme.colorScheme.secondary; // الخلفيهOFF
    final Color circleColor = displayValue
        ? theme
              .colorScheme
              .onPrimary //الدايرهON
        : theme.colorScheme.onPrimary; //الدايرهOFF

    return GestureDetector(
      onTap: _toggleSwitch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Align(
          alignment: displayValue
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Transform.translate(
            offset: displayValue
                ? const Offset(3, 0)
                : const Offset(6, 0), // تحريك الدايرة خارج المحيط
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
