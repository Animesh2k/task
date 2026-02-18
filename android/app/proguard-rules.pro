# Preserve Singular SDK classes
-keep class com.singular.sdk.** { *; }

# Preserve Android Install Referrer library
-keep public class com.android.installreferrer.** { *; }

# Uncomment if using Singular revenue tracking with Google Play Billing Library
#-keep public class com.android.billingclient.** { *; }