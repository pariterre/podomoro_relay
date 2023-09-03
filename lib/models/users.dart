import 'package:enhanced_containers/enhanced_containers.dart';

List<int> _currentlyUsedIds = [];
int _generateNextId() {
  int i = 0;
  while (true) {
    if (!_currentlyUsedIds.contains(i)) return i;
    i++;
  }
}

class User extends ItemSerializable {
  String name;

  User({required this.name, int? id})
      : super(id: (id ?? _generateNextId()).toString()) {
    _currentlyUsedIds.add(int.parse(this.id));
  }

  User.fromSerialized(map)
      : name = map['name'],
        super.fromSerialized(map);

  @override
  Map<String, dynamic> serializedMap() => {'name': name};
}
