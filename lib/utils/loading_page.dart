import 'package:hooks_riverpod/hooks_riverpod.dart';

final loadingProvider = StateNotifierProvider<LoadingController, bool>(
    (ref) => LoadingController());

class LoadingController extends StateNotifier<bool> {
  LoadingController() : super(false);

  bool isLoading = false;

  Future<void> startLoading() async {
    isLoading = true;
  }

  Future<void> endLoading() async {
    isLoading = false;
  }
}
