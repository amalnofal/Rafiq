import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSwitch extends StatefulWidget {
  final bool? value;
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

    // ألوان حسب الثيم (كما هي في كودك)
    final theme = Theme.of(context);
    final Color backgroundColor = displayValue
        ? theme
              .colorScheme
              .primary // الخلفيه ON
        : theme.colorScheme.tertiary; // الخلفيه OFF

    final Color circleColor = displayValue
        ? theme
              .colorScheme
              .onPrimary // الدايره ON
        : theme.colorScheme.onPrimary; // الدايره OFF

    return GestureDetector(
      onTap: _toggleSwitch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50.w,
        height: 28.h,
        padding: EdgeInsets.all(4.h),

        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24.r),
        ),

        // 2. تغيير محاذاة الدايره بناءً على القيمة
        alignment: displayValue
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,

        // 3. الدائرة الداخلية
        child: Container(
          width: 22.w,
          height: 22.h,
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
    );
  }
}
