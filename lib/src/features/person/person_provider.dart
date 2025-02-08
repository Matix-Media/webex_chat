import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/features/person/people_cache_notifier.dart';

import '../../core/models/person.dart';
import '../authentication/auth_providers.dart';

final peopleCacheProvider = StateNotifierProvider<PeopleCacheNotifier, Map<String, AsyncValue<Person>>>(
  (ref) => PeopleCacheNotifier(ref.watch(webexApiProvider)),
);

final personProvider = Provider.family<AsyncValue<Person>, String>((ref, personId) {
  ref.watch(peopleCacheProvider);
  return ref.read(peopleCacheProvider.notifier).getPerson(personId);
});
