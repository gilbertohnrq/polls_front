import 'package:flutter/material.dart';
import 'package:polls_front/pages/controller/poll_controller.dart';
import 'package:polls_front/pages/create_poll_page.dart';
import 'package:polls_front/pages/poll_detail_page.dart';
import 'package:signals/signals_flutter.dart';

import '../core/injection/injection.dart';

class PollsPage extends StatefulWidget {
  const PollsPage({Key? key}) : super(key: key);

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  final controller = getIt<PollController>();

  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final state = controller.state.watch(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePollPage(
                controller: controller,
              ),
            ),
          ) as bool?;

          if (result == true) {
            controller.load();
          }
        },
      ),
      appBar: AppBar(
          title: const Text('Vote on Polls'),
          leading: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await controller.load();
            },
          )),
      body: switch (state.runtimeType) {
        Loading => const Center(child: CircularProgressIndicator()),
        Error => Center(child: Text((state as Error).error.message)),
        Ready => RefreshIndicator.adaptive(
            onRefresh: () => controller.load(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: (state as Ready).polls.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.polls[index].title),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PollDetailPage(
                          poll: state.polls[index],
                          controller: controller,
                        ),
                      ),
                    ) as bool;
                    if (result) {
                      controller.load();
                    }
                  },
                );
              },
            ),
          ),
        _ => const SizedBox()
      },
    );
  }
}
