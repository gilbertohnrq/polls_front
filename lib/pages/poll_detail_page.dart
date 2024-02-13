import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polls_front/core/domain/entities/poll_entity.dart';
import 'package:polls_front/pages/controller/poll_controller.dart';
import 'package:signals/signals_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PollDetailPage extends StatefulWidget {
  const PollDetailPage({
    super.key,
    required this.controller,
    required this.poll,
  });

  final PollController controller;
  final PollEntity poll;

  @override
  State<PollDetailPage> createState() => _PollDetailPageState();
}

class _PollDetailPageState extends State<PollDetailPage> {
  late WebSocketChannel _channel;
  late Stream _broadcastStream;

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://polls-api-126y.onrender.com/polls/${widget.poll.id}/results'),
    );

    _broadcastStream = _channel.stream.asBroadcastStream();
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.poll.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )),
      body: Card(
        child: Column(
          children: [
            for (final option in widget.poll.options)
              InkWell(
                onTap: () {
                  widget.controller.voteOnPoll(widget.poll.id, option);
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: widget.controller.selectedOption.watch(context) ==
                          option,
                      onChanged: (value) {
                        if (value == true) {
                          widget.controller.voteOnPoll(widget.poll.id, option);
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    Text(option.title),
                    const Spacer(),
                    SizedBox(
                      width: 50,
                      child: StreamBuilder(
                        stream: _broadcastStream,
                        builder: (context, snapshot) {
                          int votes = 0;
                          if (snapshot.hasData) {
                            final data = json.decode(snapshot.data.toString());

                            if (data['pollOptionId'] == option.id) {
                              votes = data['votes'];
                            }
                          }

                          return Text('$votes');
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
