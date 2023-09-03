import 'package:flutter/material.dart';
import 'package:pomodoro_relay/models/project.dart';

class ManageUserDialog extends StatefulWidget {
  const ManageUserDialog({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  State<ManageUserDialog> createState() => _ManageUserDialogState();
}

class _ManageUserDialogState extends State<ManageUserDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...widget.project.users.asMap().keys.map((userindex) => _User(
                  key: Key(widget.project.users[userindex].id),
                  user: widget.project.users[userindex],
                  userIndex: userindex,
                  onChangedUsername: (value) => setState(
                      () => widget.project.users[userindex].name = value),
                  onClickedDeleteUser: () =>
                      setState(() => widget.project.users.removeAt(userindex)),
                )),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => setState(() {
                widget.project.users.add(User(name: 'Nouvel.le Instavidéaste'));
              }),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ajouter un.e instavidéaste'),
                    SizedBox(width: 12),
                    Icon(Icons.add),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Confirmer'))
          ],
        ),
      ),
    );
  }
}

class _User extends StatelessWidget {
  const _User({
    required super.key,
    required this.user,
    required this.userIndex,
    required this.onChangedUsername,
    required this.onClickedDeleteUser,
  });

  final User user;
  final int userIndex;
  final Function(String) onChangedUsername;
  final Function() onClickedDeleteUser;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration:
                  InputDecoration(labelText: 'Instavidéaste ${userIndex + 1}'),
              maxLines: 1,
              minLines: 1,
              initialValue: user.name,
              onChanged: onChangedUsername,
            ),
          ),
          InkWell(
              onTap: onClickedDeleteUser,
              borderRadius: BorderRadius.circular(25),
              child: const SizedBox(
                height: 40,
                width: 40,
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )),
        ],
      ),
    );
  }
}
