import 'package:flutter/widgets.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class CustomSwitchWidget extends StatelessWidget {
  final String labelText;
  final bool initialValue;
  final Function? onChanged;
  final Function? onDoubleTap;
  final Function? onSwipe;
  final Function? onTap;
  final String textOn;
  final String textOff;

  const CustomSwitchWidget({
    super.key,
    required this.labelText,
    this.initialValue = false,
    this.onChanged,
    this.onDoubleTap,
    this.onSwipe,
    this.onTap,
    required this.textOn,
    required this.textOff,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          // Usamos Expanded para que el Text ocupe el espacio disponible
          child: Align(
            // Alineamos el texto a la izquierda
            alignment: Alignment.centerLeft,
            child: Text(
              labelText, // Texto de ejemplo
              style: const TextStyle(fontSize: 15),
              // No necesitamos maxLines, el texto se ajustará automáticamente
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: LiteRollingSwitch(
              value: false,
              textOn: textOn,
              onChanged: (bool state) => onChanged?.call(state),
              textOff: textOff,
              onDoubleTap: () {},
              onSwipe: () {},
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
