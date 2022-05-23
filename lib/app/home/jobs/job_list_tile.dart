import 'package:flutter/material.dart';
import 'package:hanarecite/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key? key, required this.job, this.onTap})
      : super(key: key);
  final Job job;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // return Avatar(
    //       radius: 50,
    //       borderColor: Colors.black54,
    //       borderWidth: 2.0,
    //     ),
    //     const SizedBox(height: 8),
    //     Text(
    //       "설정1",
    //       style: const TextStyle(color: Colors.black54),
    //     ),
    //     const SizedBox(height: 8));
    return ListTile(
      title: Text(job.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
