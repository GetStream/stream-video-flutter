import '../platform/app_lifecycle_provider.dart';
import 'lifecycle_state.dart';

Stream<LifecycleState> get appState => AppLifecycleProvider.instance.appState;
