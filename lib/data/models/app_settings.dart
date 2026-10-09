enum OverlayLayout { bottomCard, topLeft, topRight, fullInfo }

enum OverlayBackgroundStyle { solid, translucent }

enum OverlayTextStyle { regular, medium, bold }

class OverlaySettings {
  const OverlaySettings({
    this.showAddress = true,
    this.showLatitude = true,
    this.showLongitude = true,
    this.showDate = true,
    this.showTime = true,
    this.showGpsAccuracy = true,
    this.showAltitude = false,
    this.showCompassDirection = false,
    this.showMiniMap = false,
    this.showNearbyLandmark = false,
    this.showEvidenceId = true,
    this.showAppBranding = true,
    this.layout = OverlayLayout.bottomCard,
    this.backgroundStyle = OverlayBackgroundStyle.translucent,
    this.backgroundColor = 0xCC07111F,
    this.textColor = 0xFFFFFFFF,
    this.accentColor = 0xFF0B6DFF,
    this.fontSize = 13.0,
    this.textStyle = OverlayTextStyle.medium,
    this.quality = 90,
    this.resolution = 'High',
    this.saveOriginal = true,
    this.saveStamped = true,
    this.useTrueNorth = true,
    this.showTimezone = true,
  });

  final bool showAddress;
  final bool showLatitude;
  final bool showLongitude;
  final bool showDate;
  final bool showTime;
  final bool showGpsAccuracy;
  final bool showAltitude;
  final bool showCompassDirection;
  final bool showMiniMap;
  final bool showNearbyLandmark;
  final bool showEvidenceId;
  final bool showAppBranding;

  final OverlayLayout layout;
  final OverlayBackgroundStyle backgroundStyle;

  final int backgroundColor;
  final int textColor;
  final int accentColor;

  final double fontSize;
  final OverlayTextStyle textStyle;

  final int quality;
  final String resolution;

  final bool saveOriginal;
  final bool saveStamped;
  final bool useTrueNorth;
  final bool showTimezone;

  OverlaySettings copyWith({
    bool? showAddress,
    bool? showLatitude,
    bool? showLongitude,
    bool? showDate,
    bool? showTime,
    bool? showGpsAccuracy,
    bool? showAltitude,
    bool? showCompassDirection,
    bool? showMiniMap,
    bool? showNearbyLandmark,
    bool? showEvidenceId,
    bool? showAppBranding,
    OverlayLayout? layout,
    OverlayBackgroundStyle? backgroundStyle,
    int? backgroundColor,
    int? textColor,
    int? accentColor,
    double? fontSize,
    OverlayTextStyle? textStyle,
    int? quality,
    String? resolution,
    bool? saveOriginal,
    bool? saveStamped,
    bool? useTrueNorth,
    bool? showTimezone,
  }) {
    return OverlaySettings(
      showAddress: showAddress ?? this.showAddress,
      showLatitude: showLatitude ?? this.showLatitude,
      showLongitude: showLongitude ?? this.showLongitude,
      showDate: showDate ?? this.showDate,
      showTime: showTime ?? this.showTime,
      showGpsAccuracy: showGpsAccuracy ?? this.showGpsAccuracy,
      showAltitude: showAltitude ?? this.showAltitude,
      showCompassDirection: showCompassDirection ?? this.showCompassDirection,
      showMiniMap: showMiniMap ?? this.showMiniMap,
      showNearbyLandmark: showNearbyLandmark ?? this.showNearbyLandmark,
      showEvidenceId: showEvidenceId ?? this.showEvidenceId,
      showAppBranding: showAppBranding ?? this.showAppBranding,
      layout: layout ?? this.layout,
      backgroundStyle: backgroundStyle ?? this.backgroundStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      accentColor: accentColor ?? this.accentColor,
      fontSize: fontSize ?? this.fontSize,
      textStyle: textStyle ?? this.textStyle,
      quality: quality ?? this.quality,
      resolution: resolution ?? this.resolution,
      saveOriginal: saveOriginal ?? this.saveOriginal,
      saveStamped: saveStamped ?? this.saveStamped,
      useTrueNorth: useTrueNorth ?? this.useTrueNorth,
      showTimezone: showTimezone ?? this.showTimezone,
    );
  }

  Map<String, dynamic> toJson() => {
    'showAddress': showAddress,
    'showLatitude': showLatitude,
    'showLongitude': showLongitude,
    'showDate': showDate,
    'showTime': showTime,
    'showGpsAccuracy': showGpsAccuracy,
    'showAltitude': showAltitude,
    'showCompassDirection': showCompassDirection,
    'showMiniMap': showMiniMap,
    'showNearbyLandmark': showNearbyLandmark,
    'showEvidenceId': showEvidenceId,
    'showAppBranding': showAppBranding,
    'layout': layout.name,
    'backgroundStyle': backgroundStyle.name,
    'backgroundColor': backgroundColor,
    'textColor': textColor,
    'accentColor': accentColor,
    'fontSize': fontSize,
    'textStyle': textStyle.name,
    'quality': quality,
    'resolution': resolution,
    'saveOriginal': saveOriginal,
    'saveStamped': saveStamped,
    'useTrueNorth': useTrueNorth,
    'showTimezone': showTimezone,
  };

  factory OverlaySettings.fromJson(Map<String, dynamic> json) {
    T enumValue<T extends Enum>(List<T> values, Object? value, T fallback) {
      return values.firstWhere(
        (item) => item.name == value,
        orElse: () => fallback,
      );
    }

    return OverlaySettings(
      showAddress: json['showAddress'] as bool? ?? true,
      showLatitude: json['showLatitude'] as bool? ?? true,
      showLongitude: json['showLongitude'] as bool? ?? true,
      showDate: json['showDate'] as bool? ?? true,
      showTime: json['showTime'] as bool? ?? true,
      showGpsAccuracy: json['showGpsAccuracy'] as bool? ?? true,
      showAltitude: json['showAltitude'] as bool? ?? false,
      showCompassDirection: json['showCompassDirection'] as bool? ?? false,
      showMiniMap: json['showMiniMap'] as bool? ?? false,
      showNearbyLandmark: json['showNearbyLandmark'] as bool? ?? false,
      showEvidenceId: json['showEvidenceId'] as bool? ?? true,
      showAppBranding: json['showAppBranding'] as bool? ?? true,
      layout: enumValue(
        OverlayLayout.values,
        json['layout'],
        OverlayLayout.bottomCard,
      ),
      backgroundStyle: enumValue(
        OverlayBackgroundStyle.values,
        json['backgroundStyle'],
        OverlayBackgroundStyle.translucent,
      ),
      backgroundColor: json['backgroundColor'] as int? ?? 0xCC07111F,
      textColor: json['textColor'] as int? ?? 0xFFFFFFFF,
      accentColor: json['accentColor'] as int? ?? 0xFF0B6DFF,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 13.0,
      textStyle: enumValue(
        OverlayTextStyle.values,
        json['textStyle'],
        OverlayTextStyle.medium,
      ),
      quality: json['quality'] as int? ?? 90,
      resolution: json['resolution'] as String? ?? 'High',
      saveOriginal: json['saveOriginal'] as bool? ?? true,
      saveStamped: json['saveStamped'] as bool? ?? true,
      useTrueNorth: json['useTrueNorth'] as bool? ?? true,
      showTimezone: json['showTimezone'] as bool? ?? true,
    );
  }
}

class AppSettings {
  const AppSettings({
    this.imageOverlay = const OverlaySettings(),
    this.videoOverlay = const OverlaySettings(resolution: '1080p', quality: 85),
    this.saveOriginalPhotos = true,
    this.saveStampedPhotos = true,
    this.saveOriginalVideos = true,
    this.saveStampedVideos = true,
    this.useTrueNorth = true,
  });

  final OverlaySettings imageOverlay;
  final OverlaySettings videoOverlay;

  final bool saveOriginalPhotos;
  final bool saveStampedPhotos;
  final bool saveOriginalVideos;
  final bool saveStampedVideos;
  final bool useTrueNorth;

  AppSettings copyWith({
    OverlaySettings? imageOverlay,
    OverlaySettings? videoOverlay,
    bool? saveOriginalPhotos,
    bool? saveStampedPhotos,
    bool? saveOriginalVideos,
    bool? saveStampedVideos,
    bool? useTrueNorth,
  }) {
    return AppSettings(
      imageOverlay: imageOverlay ?? this.imageOverlay,
      videoOverlay: videoOverlay ?? this.videoOverlay,
      saveOriginalPhotos: saveOriginalPhotos ?? this.saveOriginalPhotos,
      saveStampedPhotos: saveStampedPhotos ?? this.saveStampedPhotos,
      saveOriginalVideos: saveOriginalVideos ?? this.saveOriginalVideos,
      saveStampedVideos: saveStampedVideos ?? this.saveStampedVideos,
      useTrueNorth: useTrueNorth ?? this.useTrueNorth,
    );
  }

  Map<String, dynamic> toJson() => {
    'imageOverlay': imageOverlay.toJson(),
    'videoOverlay': videoOverlay.toJson(),
    'saveOriginalPhotos': saveOriginalPhotos,
    'saveStampedPhotos': saveStampedPhotos,
    'saveOriginalVideos': saveOriginalVideos,
    'saveStampedVideos': saveStampedVideos,
    'useTrueNorth': useTrueNorth,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      imageOverlay: json['imageOverlay'] is Map
          ? OverlaySettings.fromJson(
              Map<String, dynamic>.from(json['imageOverlay'] as Map),
            )
          : const OverlaySettings(),
      videoOverlay: json['videoOverlay'] is Map
          ? OverlaySettings.fromJson(
              Map<String, dynamic>.from(json['videoOverlay'] as Map),
            )
          : const OverlaySettings(resolution: '1080p', quality: 85),
      saveOriginalPhotos: json['saveOriginalPhotos'] as bool? ?? true,
      saveStampedPhotos: json['saveStampedPhotos'] as bool? ?? true,
      saveOriginalVideos: json['saveOriginalVideos'] as bool? ?? true,
      saveStampedVideos: json['saveStampedVideos'] as bool? ?? true,
      useTrueNorth: json['useTrueNorth'] as bool? ?? true,
    );
  }
}
