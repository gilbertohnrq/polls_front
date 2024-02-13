import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:polls_front/core/data/poll_data_source/poll_data_source.dart';
import 'package:polls_front/core/domain/entities/poll_entity.dart';

import '../http_client/http_client.dart';

@Injectable(as: PollsDataSource)
class PollsWebSource implements PollsDataSource {
  const PollsWebSource(this.client);
  final HttpClient client;

  @override
  Future<List<PollEntity>> getPolls() async {
    final response = await client.get('/polls');
    final List<dynamic> pollsData = response.data['polls'];
    final List<PollEntity> polls = pollsData
        .map(
            (pollData) => PollEntity.fromJson(pollData as Map<String, dynamic>))
        .toList();
    return polls;
  }

  @override
  Future<void> createPoll(PollEntity poll) async {
    final teste = poll.toJson();
    log(teste.toString());
    await client.post('/polls', data: poll.toJson());
  }

  @override
  Future<void> voteOnPoll(String pollId, String optionId) async {
    await client.post('/polls/$pollId/votes', data: {'pollOptionId': optionId});
  }
}
