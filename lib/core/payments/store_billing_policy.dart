import 'package:flutter/foundation.dart';

/// Native mobile purchases must use their store, including legacy entry points.
bool get usesNativeStoreBilling =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);
