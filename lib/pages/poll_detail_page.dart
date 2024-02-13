import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polls_front/core/domain/entities/poll_entity.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PollDetailPage extends StatefulWidget {
  const PollDetailPage({super.key, required this.poll});

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
          'ws://192.168.0.120:3333/polls/03eed1b9-5d72-436d-8941-922ac4a763dc/results'),
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
            for (var option in widget.poll.options)
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) {},
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
                        }),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
