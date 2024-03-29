import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:polls_front/core/data/poll_data_source/poll_data_source.dart';
import 'package:polls_front/core/domain/entities/failues.dart';
import 'package:polls_front/core/domain/entities/poll_entity.dart';

@injectable
final class PollsRepository {
  const PollsRepository(this.dataSource);
  final PollsDataSource dataSource;

  Future<RepositoryResponse<List<PollEntity>>> getPolls() async {
    try {
      final result = await dataSource.getPolls();
      return right(result);
    } on SocketException catch (e, s) {
      log(e.toString(), stackTrace: s);
      return left(ConnectionFailure(stackTrace: s));
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return left(PollsGetFailure(stackTrace: s));
    }
  }

  Future<RepositoryResponse<void>> voteOnPoll(
      String pollId, String optionId) async {
    try {
      await dataSource.voteOnPoll(pollId, optionId);
      return right(null);
    } on SocketException catch (e, s) {
      log(e.toString(), stackTrace: s);
      return left(ConnectionFailure(stackTrace: s));
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return left(PollsPostFailure(stackTrace: s));
    }
  }

  Future<RepositoryResponse<void>> createPoll(PollEntity poll) async {
    try {
      await dataSource.createPoll(poll);
      return right(null);
    } on SocketException catch (e, s) {
      log(e.toString(), stackTrace: s);
      return left(ConnectionFailure(stackTrace: s));
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      return left(PollsPostFailure(stackTrace: s));
    }
  }
}

final class PollsGetFailure extends Failure {
  const PollsGetFailure({super.stackTrace})
      : super(
            'An error occurred while trying to get the polls, please try again later.');

  @override
  String text(BuildContext context) {
    return 'An error occurred while trying to get the polls, please try again later.';
  }
}

final class PollsPostFailure extends Failure {
  const PollsPostFailure({super.stackTrace})
      : super(
            'An error occurred while trying to post the poll, please try again later.');

  @override
  String text(BuildContext context) {
    return 'An error occurred while trying to post the poll, please try again later.';
  }
}
