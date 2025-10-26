import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/job.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  late Box jobsBox;

  @override
  void initState() {
    super.initState();
    jobsBox = Hive.box('jobs');
  }

  Future<void> _giveFeedback(int index) async {
    final jobMap = Map<String, dynamic>.from(jobsBox.getAt(index));
    final feedbackCtrl = TextEditingController(text: jobMap['feedback'] ?? '');
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Submit Feedback'),
        content: TextField(
          controller: feedbackCtrl,
          decoration: const InputDecoration(labelText: 'Feedback'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              jobMap['feedback'] = feedbackCtrl.text.trim();
              jobsBox.putAt(index, jobMap);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobs = jobsBox.values
        .map((e) => Job.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Available Jobs')),
      body: jobs.isEmpty
          ? const Center(child: Text('No jobs available'))
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, i) {
                final job = jobs[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(job.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.description),
                        Text('Location: ${job.location}'),
                        if (job.wage != null) Text('Wage: ${job.wage}'),
                        Text('Skills: ${job.skillRequired}'),
                        if ((job.feedback ?? '').isNotEmpty) 
                          Text('Feedback: ${job.feedback}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.feedback_outlined),
                      tooltip: 'Give Feedback',
                      onPressed: () => _giveFeedback(i),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
