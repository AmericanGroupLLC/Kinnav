# Flutter engine + embedding
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Plugins used by Kinnav
-keep class com.google.android.gms.maps.** { *; }        # google_maps_flutter
-keep class com.baseflow.geolocator.** { *; }            # geolocator
-keep class androidx.security.crypto.** { *; }            # flutter_secure_storage

# Keep annotations / native method names
-keepattributes *Annotation*
-keepclasseswithmembernames class * { native <methods>; }
