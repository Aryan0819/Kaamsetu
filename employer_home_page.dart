import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/job.dart';

class EmployerHomePage extends StatefulWidget {
  const EmployerHomePage({super.key});

  @override
  State<EmployerHomePage> createState() => _EmployerHomePageState();
}

class _EmployerHomePageState extends State<EmployerHomePage> {
  late Box jobsBox;

  @override
  void initState() {
    super.initState();
    jobsBox = Hive.box('jobs');
  }

  Future<void> _jobDialog({Job? existing, int? editIndex}) async {
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final locCtrl = TextEditingController(text: existing?.location ?? '');
    final wageCtrl = TextEditingController(text: existing?.wage ?? '');
    final skillsCtrl = TextEditingController(text: existing?.skillRequired ?? '');
    final feedbackCtrl = TextEditingController(text: existing?.feedback ?? '');
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editIndex == null ? 'Add Job' : 'Edit Job'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Location'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: wageCtrl, decoration: const InputDecoration(labelText: 'Wage')),
              TextFormField(controller: skillsCtrl, decoration: const InputDecoration(labelText: 'Skills (comma-separated)'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: feedbackCtrl, decoration: const InputDecoration(labelText: 'Feedback'), maxLines: 2),
            ]),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final job = Job(
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  location: locCtrl.text.trim(),
                  wage: wageCtrl.text.trim().isEmpty ? null : wageCtrl.text.trim(),
                  skillRequired: skillsCtrl.text.trim(),
                  feedback: feedbackCtrl.text.trim(),
                );
                final map = job.toMap();
                if (editIndex == null) {
                  jobsBox.add(map);
                } else {
                  jobsBox.putAt(editIndex, map);
                }
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: Text(editIndex == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteJob(int index) async {
    await jobsBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final jobs = jobsBox.values
        .map((e) => Job.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _jobDialog(),
            tooltip: 'Add Job',
          )
        ],
      ),
      body: jobs.isEmpty
          ? const Center(child: Text('No jobs posted yet'))
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, i) {
                final job = jobs[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(job.description),
                        Text('Location: ${job.location}'),
                        if (job.wage != null) Text('Wage: ${job.wage}'),
                        Text('Skills: ${job.skillRequired}'),
                        if (job.feedback != null) Text('Feedback: ${job.feedback}'),
                        Row(
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                              onPressed: () => _jobDialog(existing: job, editIndex: i),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text('Delete'),
                              onPressed: () => _deleteJob(i),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
