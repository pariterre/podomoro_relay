import 'package:enhanced_containers/enhanced_containers.dart';

class User extends ItemSerializable {
  String name;

  User({required super.id, required this.name});

  User.fromSerialized(map)
      : name = map['name'],
        super.fromSerialized(map);

  @override
  Map<String, dynamic> serializedMap() => {'name': name};
}
