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

  load() async {
    state.set(Loading());
    final result = await _repository.getPolls();
    result.fold(
      (err) => state.set(Error(err)),
      (data) => state.set(Ready(data)),
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
