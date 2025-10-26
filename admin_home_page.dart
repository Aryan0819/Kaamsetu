import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/job.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
    final feedbackCtrl = TextEditingController(text: existing?.feedback ?? '');
    final ratingCtrl = TextEditingController(text: existing?.rating?.toString() ?? '');
    final contactCtrl = TextEditingController(text: existing?.contactNo ?? '');
    final skillsCtrl = TextEditingController(text: existing?.skillRequired ?? '');

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(editIndex == null ? 'Add Job' : 'Edit Job'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Job Title'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                TextFormField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                TextFormField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Location'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                TextFormField(controller: wageCtrl, decoration: const InputDecoration(labelText: 'Wage (optional)')),
                TextFormField(controller: feedbackCtrl, decoration: const InputDecoration(labelText: 'Feedback (optional)')),
                TextFormField(controller: ratingCtrl, decoration: const InputDecoration(labelText: 'Rating (1-5)', hintText: 'e.g., 4.5')),
                TextFormField(controller: contactCtrl, decoration: const InputDecoration(labelText: 'Contact No (optional)')),
                TextFormField(controller: skillsCtrl, decoration: const InputDecoration(labelText: 'Skills (comma-separated)'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final rating = double.tryParse(ratingCtrl.text.trim());
                final job = Job(
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  location: locCtrl.text.trim(),
                  wage: wageCtrl.text.trim().isEmpty ? null : wageCtrl.text.trim(),
                  feedback: feedbackCtrl.text.trim().isEmpty ? null : feedbackCtrl.text.trim(),
                  rating: rating,
                  contactNo: contactCtrl.text.trim().isEmpty ? null : contactCtrl.text.trim(),
                  skillRequired: skillsCtrl.text.trim(),
                );
                if (editIndex == null) {
                  await jobsBox.add(job.toMap());
                } else {
                  await jobsBox.putAt(editIndex, job.toMap());
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
        title: const Text('Admin Job Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _jobDialog(),
            tooltip: 'Add Job',
          )
        ],
      ),
      body: jobs.isEmpty
          ? const Center(child: Text('No jobs available'))
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];

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
                        if (job.feedback != null) Text('Feedback: ${job.feedback}'),
                        if (job.rating != null) Text('Rating: ${job.rating}'),
                        if (job.contactNo != null) Text('Contact: ${job.contactNo}'),
                        Text('Skills: ${job.skillRequired}'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                              onPressed: () => _jobDialog(existing: job, editIndex: index),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.delete),
                              label: const Text('Delete'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                              onPressed: () => _deleteJob(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
