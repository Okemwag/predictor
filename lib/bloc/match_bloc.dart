import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:match_manager/data/models/match_model.dart';
import 'package:match_manager/data/repositories/match_repository.dart';
import 'package:match_manager/presentation/bloc/match_event.dart';
import 'package:match_manager/presentation/bloc/match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final MatchRepository matchRepository;

  MatchBloc({required this.matchRepository}) : super(MatchInitial());

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    if (event is MatchLoad) {
      yield* _mapMatchLoadToState();
    } else if (event is MatchCreate) {
      yield* _mapMatchCreateToState(event);
    } else if (event is MatchUpdate) {
      yield* _mapMatchUpdateToState(event);
    } else if (event is MatchDelete) {
      yield* _mapMatchDeleteToState(event);
    }
  }

  Stream<MatchState> _mapMatchLoadToState() async* {
    try {
      final matches = await this.matchRepository.getMatches();
      yield MatchLoadSuccess(matches);
    } catch (_) {
      yield MatchOperationFailure();
    }
  }

  Stream<MatchState> _mapMatchCreateToState(MatchCreate event) async* {
    try {
      await this.matchRepository.createMatch(event.match);
      final matches = await this.matchRepository.getMatches();
      yield MatchLoadSuccess(matches);
    } catch (_) {
      yield MatchOperationFailure();
    }
  }

  Stream<MatchState> _mapMatchUpdateToState(MatchUpdate event) async* {
    try {
      await this.matchRepository.updateMatch(event.match);
      final matches = await this.matchRepository.getMatches();
      yield MatchLoadSuccess(matches);
    } catch (_) {
      yield MatchOperationFailure();
    }
  }

  Stream<MatchState> _mapMatchDeleteToState(MatchDelete event) async* {
    try {
      await this.matchRepository.deleteMatch(event.match.id);
      final matches = await this.matchRepository.getMatches();
      yield MatchLoadSuccess(matches);
    } catch (_) {
      yield MatchOperationFailure();
    }
  }
}
