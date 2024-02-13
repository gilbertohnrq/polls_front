import 'package:flutter/material.dart';
import 'package:polls_front/core/domain/entities/poll_entity.dart';
import 'package:polls_front/pages/controller/poll_controller.dart';

class CreatePollPage extends StatelessWidget {
  const CreatePollPage({super.key, required this.controller});

  final PollController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a poll'),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  TextFormField(
                    controller: controller.titleCtl.value,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ...List.generate(
                    controller.optionsCtl.value.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextFormField(
                        controller: controller.optionsCtl.value[index],
                        decoration: InputDecoration(
                          labelText: 'Option ${index + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () {
                  final title = controller.titleCtl.value.text;
                  final options = controller.optionsCtl.value
                      .map((e) => e.text)
                      .where((element) => element.isNotEmpty)
                      .toList();

                  if (title.isNotEmpty && options.isNotEmpty) {
                    controller.createPoll(
                      PollEntity(
                        title: title,
                        options: options
                            .map((e) => Option(id: '', title: e, votes: 0))
                            .toList(),
                      ),
                    );
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Create Poll'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
