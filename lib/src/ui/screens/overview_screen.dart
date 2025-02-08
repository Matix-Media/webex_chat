import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/core/models/team.dart';
import 'package:webex_chat/src/features/chat/chat_history.dart';
import 'package:webex_chat/src/features/chat/chat_titlebar.dart';
import 'package:webex_chat/src/features/teams/teams_list.dart';
import 'package:webex_chat/src/ui/widgets/vertical_split_view.dart';

import '../../core/models/room.dart';
import '../../features/rooms/rooms_list.dart';
import '../../features/teams/team_titlebar.dart';

class OverviewScreen extends ConsumerStatefulWidget {
  const OverviewScreen({super.key});

  @override
  ConsumerState<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends ConsumerState<OverviewScreen> with TickerProviderStateMixin {
  late final AnimationController _selectedTeamAnimationController;
  late final AnimationController _selectedRoomAnimationController;
  Team? _selectedTeam;
  bool _isShowingTeamRooms = false;
  Room? _selectedRoom;

  @override
  void initState() {
    super.initState();
    _selectedTeamAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _selectedRoomAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: VerticalSplitView(
          ratio: 0.3,
          left: Column(
            children: [
              SizeTransition(
                sizeFactor: CurvedAnimation(parent: _selectedTeamAnimationController, curve: Curves.decelerate),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card.filled(
                      color: _selectedTeam != null
                          ? _selectedTeam!.colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceBright,
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _selectedTeam != null
                            ? TeamTitleBar(
                                team: _selectedTeam!,
                                onBackPressed: () {
                                  _selectedTeamAnimationController.reverse();
                                  setState(() => _isShowingTeamRooms = false);
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Expanded(
                child: Card.filled(
                  color: Theme.of(context).colorScheme.surfaceBright,
                  clipBehavior: Clip.antiAlias,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _selectedTeam != null && _isShowingTeamRooms
                        ? RoomsList(
                            forTeam: _selectedTeam,
                            onRoomSelected: (room) {
                              setState(() {
                                _selectedRoom = room;
                              });
                              _selectedRoomAnimationController.forward();
                            },
                          )
                        : TeamsList(
                            onTeamSelected: (team) {
                              setState(() {
                                _selectedTeam = team;
                                _isShowingTeamRooms = true;
                              });
                              _selectedTeamAnimationController.forward();
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card.filled(
                color: Theme.of(context).colorScheme.surfaceBright,
                child: NavigationBar(
                  backgroundColor: Colors.transparent,
                  destinations: [
                    NavigationDestination(icon: Icon(Icons.groups_outlined), label: "Teams"),
                    NavigationDestination(icon: Icon(Icons.forum_outlined), label: "Chats"),
                  ],
                ),
              ),
            ],
          ),
          right: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizeTransition(
                sizeFactor: CurvedAnimation(parent: _selectedRoomAnimationController, curve: Curves.decelerate),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card.filled(
                      color: Theme.of(context).colorScheme.surfaceBright,
                      child: Padding(
                        padding: EdgeInsets.all(14.5),
                        child: _selectedRoom == null ? null : ChatTitleBar(room: _selectedRoom!),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Expanded(
                child: Card.filled(
                  color: Theme.of(context).colorScheme.surfaceBright,
                  child: _selectedRoom == null
                      ? const Center(child: Text("Select a room to chat."))
                      : Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: ChatHistory(room: _selectedRoom!),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
