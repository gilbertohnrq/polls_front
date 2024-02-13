import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:polls_front/core/domain/entities/poll_entity.dart';
import 'package:polls_front/core/domain/repositories/poll_repository.dart';
import 'package:signals/signals_flutter.dart';

import '../../core/domain/entities/failues.dart';

@injectable
class PollController {
  PollController(this._repository);
  final PollsRepository _repository;

  final state = signal<PollStates>(Loading());
  final selectedOption = signal<Option?>(null);

  final titleCtl =
      signal<TextEditingController>(TextEditingController(text: ''));
  final optionsCtl = signal<List<TextEditingController>>([
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
  ]);

  Future<void> load() async {
    state.set(Loading());
    final result = await _repository.getPolls();
    result.fold(
      (err) => state.set(Error(err)),
      (data) => state.set(Ready(data)),
    );
  }

  Future<void> voteOnPoll(String pollId, Option option) async {
    state.set(Loading());
    final result = await _repository.voteOnPoll(pollId, option.id);
    selectedOption.set(option);
    result.fold(
      (err) => state.set(Error(err)),
      (data) => load(),
    );
  }

  Future<void> createPoll(PollEntity poll) async {
    state.set(Loading());
    final result = await _repository.createPoll(poll);
    result.fold(
      (err) => state.set(Error(err)),
      (data) => load(),
    );
  }
}

sealed class PollStates {
  const PollStates();
}

class Loading extends PollStates {}

class Error extends PollStates {
  const Error(this.error);
  final Failure error;
}

class Ready extends PollStates {
  const Ready(this.polls);
  final List<PollEntity> polls;
}
