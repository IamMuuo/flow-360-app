import 'package:flutter/material.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';

class TankStatusIndicator extends StatelessWidget {
  final TankModel tank;

  const TankStatusIndicator({
    super.key,
    required this.tank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tank.statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tank.statusColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(),
            size: 12,
            color: tank.statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            tank.fuelStatus,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: tank.statusColor,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon() {
    if (!tank.isActive) return Icons.cancel;
    if (tank.hasLowFuel) return Icons.warning;
    if (tank.hasMediumFuel) return Icons.info;
    return Icons.check_circle;
  }
}

