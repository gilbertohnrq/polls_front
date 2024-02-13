import 'package:polls_front/core/domain/entities/poll_entity.dart';

abstract interface class PollsDataSource {
  Future<List<PollEntity>> getPolls();
  Future<void> voteOnPoll(String pollId, String optionId);
  Future<void> createPoll(PollEntity poll);
}
