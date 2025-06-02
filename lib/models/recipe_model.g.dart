// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      idMeal: fields[0] as String?,
      strMeal: fields[1] as String?,
      strCategory: fields[2] as String?,
      strArea: fields[3] as String?,
      strInstructions: fields[4] as String?,
      strMealThumb: fields[5] as String?,
      strTags: fields[6] as String?,
      strYoutube: fields[7] as String?,
      strIngredient1: fields[8] as String?,
      strIngredient2: fields[9] as String?,
      strIngredient3: fields[10] as String?,
      strIngredient4: fields[11] as String?,
      strIngredient5: fields[12] as String?,
      strMeasure1: fields[13] as String?,
      strMeasure2: fields[14] as String?,
      strMeasure3: fields[15] as String?,
      strMeasure4: fields[16] as String?,
      strMeasure5: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.idMeal)
      ..writeByte(1)
      ..write(obj.strMeal)
      ..writeByte(2)
      ..write(obj.strCategory)
      ..writeByte(3)
      ..write(obj.strArea)
      ..writeByte(4)
      ..write(obj.strInstructions)
      ..writeByte(5)
      ..write(obj.strMealThumb)
      ..writeByte(6)
      ..write(obj.strTags)
      ..writeByte(7)
      ..write(obj.strYoutube)
      ..writeByte(8)
      ..write(obj.strIngredient1)
      ..writeByte(9)
      ..write(obj.strIngredient2)
      ..writeByte(10)
      ..write(obj.strIngredient3)
      ..writeByte(11)
      ..write(obj.strIngredient4)
      ..writeByte(12)
      ..write(obj.strIngredient5)
      ..writeByte(13)
      ..write(obj.strMeasure1)
      ..writeByte(14)
      ..write(obj.strMeasure2)
      ..writeByte(15)
      ..write(obj.strMeasure3)
      ..writeByte(16)
      ..write(obj.strMeasure4)
      ..writeByte(17)
      ..write(obj.strMeasure5);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
