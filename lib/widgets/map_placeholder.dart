import 'package:flutter/material.dart';
import 'package:pedivo_activity_verification/constants/app_theme.dart';

/// Widget to display a placeholder map showing the walking route
class MapPlaceholder extends StatelessWidget {
  final List<List<double>> route;
  final String sessionId;

  const MapPlaceholder({
    Key? key,
    required this.route,
    required this.sessionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Stack(
        children: [
          // Background with gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryLight.withOpacity(0.2),
                  AppColors.lightGrey,
                ],
              ),
            ),
          ),

          // Custom route drawing
          CustomPaint(
            painter: _RouteMapPainter(route),
            size: Size.infinite,
          ),

          // Start and End markers
          Positioned(
            left: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.verifiedGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.verifiedGreen.withOpacity(0.5),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),

          // Info card at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.95),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppBorderRadius.md),
                  bottomRight: Radius.circular(AppBorderRadius.md),
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route Map',
                    style: AppTextStyles.subtitle,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Total waypoints: ${route.length}',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  if (route.isNotEmpty)
                    Text(
                      'Start: ${route.first[0].toStringAsFixed(4)}, ${route.first[1].toStringAsFixed(4)}',
                      style: AppTextStyles.caption,
                    ),
                ],
              ),
            ),
          ),

          // Center label if no data
          if (route.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    color: AppColors.lightText,
                    size: 48,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No route data available',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom painter to draw the route on the map
class _RouteMapPainter extends CustomPainter {
  final List<List<double>> route;

  _RouteMapPainter(this.route);

  @override
  void paint(Canvas canvas, Size size) {
    if (route.length < 2) return;

    // Find bounding box
    double minLat = route.first[0];
    double maxLat = route.first[0];
    double minLng = route.first[1];
    double maxLng = route.first[1];

    for (final point in route) {
      minLat = minLat > point[0] ? point[0] : minLat;
      maxLat = maxLat < point[0] ? point[0] : maxLat;
      minLng = minLng > point[1] ? point[1] : minLng;
      maxLng = maxLng < point[1] ? point[1] : maxLng;
    }

    // Convert coordinates to pixel positions
    final latRange = maxLat - minLat;
    final lngRange = maxLng - minLng;
    final padding = 40.0;

    List<Offset> pixelPoints = [];
    for (final point in route) {
      final x = padding +
          ((point[1] - minLng) / lngRange) * (size.width - 2 * padding);
      final y = size.height -
          padding -
          ((point[0] - minLat) / latRange) * (size.height - 100);
      pixelPoints.add(Offset(x, y));
    }

    // Draw the path
    final pathPaint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.7)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(pixelPoints.first.dx, pixelPoints.first.dy);
    for (int i = 1; i < pixelPoints.length; i++) {
      path.lineTo(pixelPoints[i].dx, pixelPoints[i].dy);
    }

    canvas.drawPath(path, pathPaint);

    // Draw waypoint dots
    final pointPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < pixelPoints.length; i++) {
      final radius = i == 0 || i == pixelPoints.length - 1 ? 6.0 : 4.0;
      canvas.drawCircle(pixelPoints[i], radius, pointPaint);
    }

    // Draw end marker
    final endMarkerPaint = Paint()
      ..color = AppColors.rejectedRed.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(pixelPoints.last, 8, endMarkerPaint);

    final endIconPaint = Paint()
      ..color = AppColors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw an X for end marker
    final endPoint = pixelPoints.last;
    canvas.drawLine(
      Offset(endPoint.dx - 3, endPoint.dy - 3),
      Offset(endPoint.dx + 3, endPoint.dy + 3),
      endIconPaint,
    );
    canvas.drawLine(
      Offset(endPoint.dx + 3, endPoint.dy - 3),
      Offset(endPoint.dx - 3, endPoint.dy + 3),
      endIconPaint,
    );
  }

  @override
  bool shouldRepaint(_RouteMapPainter oldDelegate) {
    return oldDelegate.route != route;
  }
}
