// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction()
      ..service = (fields[0] as List).cast<dynamic>()
      ..subService = (fields[1] as List).cast<dynamic>()
      ..subServiceDec = (fields[2] as List).cast<dynamic>()
      ..userData = (fields[3] as Map).cast<String, dynamic>()
      ..myOrders = (fields[4] as Map).cast<String, dynamic>()
      ..userInfo = (fields[5] as List).cast<dynamic>()
      ..Address = (fields[6] as List).cast<dynamic>()
      ..order = (fields[7] as List).cast<dynamic>();
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.service)
      ..writeByte(1)
      ..write(obj.subService)
      ..writeByte(2)
      ..write(obj.subServiceDec)
      ..writeByte(3)
      ..write(obj.userData)
      ..writeByte(4)
      ..write(obj.myOrders)
      ..writeByte(5)
      ..write(obj.userInfo)
      ..writeByte(6)
      ..write(obj.Address)
      ..writeByte(7)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
