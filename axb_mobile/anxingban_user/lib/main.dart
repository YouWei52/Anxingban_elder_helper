import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'data/services/storage_service.dart';
import 'data/services/api_client.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/trip_repository.dart';
import 'data/repositories/task_repository.dart';
import 'data/repositories/card_repository.dart';
import 'data/repositories/sos_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/profiles_list_screen.dart';
import 'presentation/screens/trip_create_screen.dart';
import 'presentation/screens/task_create_screen.dart';
import 'presentation/screens/sos_records_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/help_feedback_screen.dart';
import 'presentation/screens/about_screen.dart';
import 'presentation/screens/pair_elder_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  final apiClient = ApiClient(storageService);

  final authRepository = AuthRepository(apiClient);
  final profileRepository = ProfileRepository(apiClient);
  final tripRepository = TripRepository(apiClient);
  final taskRepository = TaskRepository(apiClient);
  final cardRepository = CardRepository(apiClient);
  final sosRepository = SosRepository(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository, storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(profileRepository),
        ),
        Provider.value(value: tripRepository),
        Provider.value(value: taskRepository),
        Provider.value(value: cardRepository),
        Provider.value(value: sosRepository),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _setupRouter();
  }

  Future<void> _initializeApp() async {
    await context.read<AuthProvider>().loadCurrentUser();
  }

  void _setupRouter() {
    _router = GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final authProvider = context.read<AuthProvider>();
        final isAuthenticated = authProvider.isAuthenticated;

        if (!isAuthenticated &&
            state.matchedLocation != '/login' &&
            state.matchedLocation != '/register') {
          return '/login';
        }

        if (isAuthenticated &&
            (state.matchedLocation == '/login' ||
                state.matchedLocation == '/register')) {
          return '/home';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/profiles',
          builder: (context, state) => const ProfilesListScreen(),
        ),
        GoRoute(
          path: '/trips/create',
          builder: (context, state) => const TripCreateScreen(),
        ),
        GoRoute(
          path: '/sos',
          builder: (context, state) => const SosRecordsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/help',
          builder: (context, state) => const HelpFeedbackScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: '/pair',
          builder: (context, state) => const PairElderScreen(),
        ),
        GoRoute(
          path: '/trips/create',
          builder: (context, state) => const TripCreateScreen(),
        ),
        GoRoute(
          path: '/tasks/create',
          builder: (context, state) => const TaskCreateScreen(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '安行伴 - 子女端',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
