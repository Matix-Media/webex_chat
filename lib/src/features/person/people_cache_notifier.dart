import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/core/models/person.dart';
import 'package:webex_chat/src/core/webex_sdk/webex_api.dart';

class PeopleCacheNotifier extends StateNotifier<Map<String, AsyncValue<Person>>> {
  final WebexAPI _webexApi;

  PeopleCacheNotifier(WebexAPI webexApi)
      : _webexApi = webexApi,
        super({});

  Future<void> fetchAndCachePeople(List<String> peopleIds) async {
    final peopleToFetch = peopleIds.where((id) => !state.containsKey(id));
    if (peopleToFetch.isEmpty) return;
    await _fetchPeople(peopleIds);
  }

  Future<void> _fetchPeople(List<String> peopleIds) async {
    state = {
      ...state,
      ...Map.fromEntries(peopleIds.map((id) => MapEntry(id, const AsyncLoading<Person>()))),
    };

    try {
      final people = await _webexApi.getPeople(peopleIds: peopleIds);
      state = {
        ...state,
        ...Map.fromEntries(people.items.map((person) => MapEntry(person.id, AsyncData(person)))),
      };
    } catch (e, s) {
      state = {
        ...state,
        ...Map.fromEntries(peopleIds.map((id) => MapEntry(id, AsyncError(e, s)))),
      };
    }
  }

  AsyncValue<Person> getPerson(String personId) {
    if (state.containsKey(personId)) {
      return state[personId]!;
    } else {
      _fetchPeople([personId]);
      return state[personId] ?? const AsyncLoading<Person>();
    }
  }
}
