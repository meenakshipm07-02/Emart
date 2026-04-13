# Keep Weipl Checkout classes
-keep class com.weipl.checkout.** { *; }
-keep class com.nsdl.egov.esignaar.** { *; }

# Keep Google Play Core Split Install API (used by weipl_checkout_flutter)
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Keep Flutter deferred components (used by the plugin)
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Keep all activities, services, broadcast receivers
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.Application

# Disable ALL warnings for these packages
-dontwarn com.weipl.checkout.**
-dontwarn com.nsdl.egov.esignaar.**
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**