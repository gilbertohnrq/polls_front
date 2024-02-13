import 'package:polls_front/core/domain/entities/poll_entity.dart';

abstract interface class PollsDataSource {
  Future<List<PollEntity>> getPolls();
}
