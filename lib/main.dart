import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'firebase_options.dart';
import 'core/env/env.dart';
import 'core/network/network.dart';
import 'core/services/objectbox_service.dart';
import 'core/widgets/app_lifecycle_handler.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';

import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'core/theme/theme_controller.dart';
import 'core/services/theme_service.dart';
import 'core/language/language_controller.dart';
import 'core/services/language_service.dart';
import 'i18n/strings.g.dart';

late ObjectBoxService objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
    !kDebugMode,
  );

  // Initialize ObjectBox
  objectBox = await ObjectBoxService.create();

  // Initialize Network Layer
  DioClient.initialize(
    config: NetworkConfig(baseUrl: Env.baseUrl, enableLogging: true),
  );

  // Load theme before creating controller
  final themeService = ThemeService();
  final savedTheme = await themeService.getTheme();

  // Load language before creating controller
  final languageService = LanguageService();
  final savedLanguage = await languageService.getLanguage();

  // Inject Controllers globally (GetX for state management only)
  Get.put(AuthController());
  Get.lazyPut(() => OnboardingController());
  Get.put(ThemeController(initialTheme: savedTheme));
  Get.put(LanguageController(initialLanguage: savedLanguage));

  runApp(MyApp(database: objectBox));
}

class MyApp extends StatelessWidget {
  final ObjectBoxService database;

  const MyApp({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: AppLifecycleHandler(
        child: TranslationProvider(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: GetBuilder<ThemeController>(
              builder: (themeController) {
                return GetBuilder<LanguageController>(
                  builder: (languageController) {
                    return MaterialApp.router(
                      title: 'Flutter Base Project',
                      debugShowCheckedModeBanner: false,
                      theme: AppTheme.getTheme(),
                      routerConfig: AppRouter.router,
                      locale: languageController.currentAppLocale.flutterLocale,
                      supportedLocales:
                          AppLocaleUtils.instance.supportedLocales,
                      localizationsDelegates: const [
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      builder: (context, child) {
                        // Wrap with Directionality for RTL support
                        return Directionality(
                          textDirection: languageController.isRTL
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: child!,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
