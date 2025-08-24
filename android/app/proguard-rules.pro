# -------- Flutter basics --------
# Keep Flutter embedding + plugin registrant (prevents reflection issues)
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.app.** { *; }
-dontwarn io.flutter.**

# -------- Firebase / Google Play --------
# Most Firebase AARs ship their own rules, but these silence warnings and
# keep things R8 sometimes gets too aggressive about.
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Firestore / Realtime Database internals & protobuf
-keep class com.google.firebase.firestore.** { *; }
-keep class com.google.firestore.v1.** { *; }
-keep class com.google.type.** { *; }
-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**

# -------- JSON / reflection (if you use toJson/fromJson, Gson, etc.) --------
-keepattributes Signature, *Annotation*
# Keep your model classes so reflection/serialization doesn’t nuke fields.
# TODO: change "com.yourapp.model" to your real package(s).
-keep class com.yourapp.model.** { *; }

# If using Gson anywhere (Firestore converters, etc.)
-keep class com.google.gson.** { *; }
-keep class sun.misc.Unsafe { *; }
-dontwarn sun.misc.Unsafe

# -------- Rive (no special rules needed, but keep to be safe) --------
-keep class app.rive.runtime.kotlin.** { *; }
-dontwarn app.rive.runtime.kotlin.**

# -------- Kotlin/Coroutines noise reducers --------
-dontwarn kotlin.**
-dontwarn kotlinx.**

# -------- OkHttp/Okio (pulled by Google libs) --------
-dontwarn okhttp3.**
-dontwarn okio.**

# -------- Misc cleanup --------
# Keep class/method names for stacktraces if you care
-keepattributes SourceFile, LineNumberTable