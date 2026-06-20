import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';

class LocationDetailedCard extends StatefulWidget {
  final double latitude;
  final double longitude;

  const LocationDetailedCard({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<LocationDetailedCard> createState() => _LocationDetailedCardState();
}

class _LocationDetailedCardState extends State<LocationDetailedCard> {
  String? _address;

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng(widget.latitude, widget.longitude);
  }

  @override
  void didUpdateWidget(covariant LocationDetailedCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      _getAddressFromLatLng(widget.latitude, widget.longitude);
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    if (lat == 0.0 && lng == 0.0) {
      if (mounted) {
        setState(() {
          _address = null;
        });
      }
      return;
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (mounted) {
          setState(() {
            _address =
                "${place.administrativeArea ?? ''}، ${place.locality ?? place.subLocality ?? ''}";
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _address = "error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final bool isWaitingForGPS =
        widget.latitude == 0.0 && widget.longitude == 0.0;

    String displayAddress;
    if (isWaitingForGPS || _address == null) {
      displayAddress = context.l10n.locating;
    } else if (_address == "error") {
      displayAddress = context.l10n.unknownLocation;
    } else {
      displayAddress = _address!;
    }

    return CustomContainer(
      margin: EdgeInsets.all(AppDimensions.paddingS),
      child: Column(
        children: [
          Row(
            children: [
              CircleIconButton(
                "assets/icons/location.svg",
                color: const Color(0xFF00C950),
                size: 40.h,
                iconSize: 20.h,
                bgColor: isDarkMode
                    ? const Color(0xFF00C950).withValues(alpha: 0.1)
                    : const Color(0xFFF0FDF4),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.currentLocation,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      displayAddress,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isWaitingForGPS
                            ? Theme.of(context).colorScheme.onTertiary
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // الكارت البيج أو الخريطة
          Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              ),
              color: isWaitingForGPS
                  ? (isDarkMode
                        ? const Color(0xFF2A2A2A)
                        : const Color(0xFFFDFBF7))
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: isWaitingForGPS
                  // 1. حالة الانتظار: الكارت البيج الأنيق
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            "assets/icons/location.svg",
                            colorFilter: ColorFilter.mode(
                              Color(0xFF00C950),
                              BlendMode.srcIn,
                            ),
                            height: 45.h,
                            width: 45.h,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          context.l10n.locationUnavailable,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    )
                  // 2. حالة وجود الداتا: الخريطة
                  : FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          widget.latitude,
                          widget.longitude,
                        ),
                        initialZoom: 16.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.rafiq.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(widget.latitude, widget.longitude),
                              width: 40.w,
                              height: 40.w,
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFF00C950),
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
