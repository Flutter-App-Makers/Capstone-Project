// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 0;

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      todoId: fields[0] as String,
      content: fields[1] as String,
      isCompleted: fields[2] as bool,
      category: fields[4] as TodoCategory,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.todoId)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TodoCategoryAdapter extends TypeAdapter<TodoCategory> {
  @override
  final int typeId = 1;

  @override
  TodoCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TodoCategory.work;
      case 1:
        return TodoCategory.personal;
      case 2:
        return TodoCategory.shopping;
      case 3:
        return TodoCategory.health;
      case 4:
        return TodoCategory.travel;
      case 5:
        return TodoCategory.finance;
      case 6:
        return TodoCategory.education;
      case 7:
        return TodoCategory.entertainment;
      case 8:
        return TodoCategory.home;
      case 9:
        return TodoCategory.fitness;
      case 10:
        return TodoCategory.hobbies;
      case 11:
        return TodoCategory.family;
      case 12:
        return TodoCategory.friends;
      case 13:
        return TodoCategory.selfCare;
      case 14:
        return TodoCategory.spirituality;
      case 15:
        return TodoCategory.community;
      case 16:
        return TodoCategory.volunteering;
      case 17:
        return TodoCategory.pets;
      case 18:
        return TodoCategory.technology;
      case 19:
        return TodoCategory.fashion;
      case 20:
        return TodoCategory.food;
      case 21:
        return TodoCategory.sports;
      case 22:
        return TodoCategory.music;
      case 23:
        return TodoCategory.art;
      case 24:
        return TodoCategory.books;
      case 25:
        return TodoCategory.movies;
      case 26:
        return TodoCategory.games;
      case 27:
        return TodoCategory.photography;
      case 28:
        return TodoCategory.gardening;
      case 29:
        return TodoCategory.crafts;
      case 30:
        return TodoCategory.writing;
      case 31:
        return TodoCategory.cooking;
      case 32:
        return TodoCategory.homeImprovement;
      case 33:
        return TodoCategory.other;
      default:
        return TodoCategory.work;
    }
  }

  @override
  void write(BinaryWriter writer, TodoCategory obj) {
    switch (obj) {
      case TodoCategory.work:
        writer.writeByte(0);
        break;
      case TodoCategory.personal:
        writer.writeByte(1);
        break;
      case TodoCategory.shopping:
        writer.writeByte(2);
        break;
      case TodoCategory.health:
        writer.writeByte(3);
        break;
      case TodoCategory.travel:
        writer.writeByte(4);
        break;
      case TodoCategory.finance:
        writer.writeByte(5);
        break;
      case TodoCategory.education:
        writer.writeByte(6);
        break;
      case TodoCategory.entertainment:
        writer.writeByte(7);
        break;
      case TodoCategory.home:
        writer.writeByte(8);
        break;
      case TodoCategory.fitness:
        writer.writeByte(9);
        break;
      case TodoCategory.hobbies:
        writer.writeByte(10);
        break;
      case TodoCategory.family:
        writer.writeByte(11);
        break;
      case TodoCategory.friends:
        writer.writeByte(12);
        break;
      case TodoCategory.selfCare:
        writer.writeByte(13);
        break;
      case TodoCategory.spirituality:
        writer.writeByte(14);
        break;
      case TodoCategory.community:
        writer.writeByte(15);
        break;
      case TodoCategory.volunteering:
        writer.writeByte(16);
        break;
      case TodoCategory.pets:
        writer.writeByte(17);
        break;
      case TodoCategory.technology:
        writer.writeByte(18);
        break;
      case TodoCategory.fashion:
        writer.writeByte(19);
        break;
      case TodoCategory.food:
        writer.writeByte(20);
        break;
      case TodoCategory.sports:
        writer.writeByte(21);
        break;
      case TodoCategory.music:
        writer.writeByte(22);
        break;
      case TodoCategory.art:
        writer.writeByte(23);
        break;
      case TodoCategory.books:
        writer.writeByte(24);
        break;
      case TodoCategory.movies:
        writer.writeByte(25);
        break;
      case TodoCategory.games:
        writer.writeByte(26);
        break;
      case TodoCategory.photography:
        writer.writeByte(27);
        break;
      case TodoCategory.gardening:
        writer.writeByte(28);
        break;
      case TodoCategory.crafts:
        writer.writeByte(29);
        break;
      case TodoCategory.writing:
        writer.writeByte(30);
        break;
      case TodoCategory.cooking:
        writer.writeByte(31);
        break;
      case TodoCategory.homeImprovement:
        writer.writeByte(32);
        break;
      case TodoCategory.other:
        writer.writeByte(33);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
