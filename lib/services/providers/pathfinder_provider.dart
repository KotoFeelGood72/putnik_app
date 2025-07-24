import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:putnik_app/services/pathfinder_repository.dart';

final pathfinderRepositoryProvider = Provider<PathfinderRepository>((ref) {
  return PathfinderRepository();
});

final pathfinderClassesProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(pathfinderRepositoryProvider);
  return await repo.fetchClasses();
});

final pathfinderArchetypesProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(pathfinderRepositoryProvider);
  return await repo.fetchArchetypes();
});

final pathfinderRacesProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(pathfinderRepositoryProvider);
  return await repo.fetchRaces();
});

final pathfinderGodsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(pathfinderRepositoryProvider);
  return await repo.fetchGods();
});
