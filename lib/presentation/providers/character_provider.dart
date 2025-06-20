import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/character_remote_data_source.dart';
import '../../domain/usecases/get_characters_usecase.dart';
import '../../data/models/character_model.dart';

final characterProvider = FutureProvider<List<CharacterModel>>((ref) async {
  final remoteDataSource = CharacterRemoteDataSource();
  final getCharactersUseCase = GetCharactersUseCase(remoteDataSource);
  return await getCharactersUseCase.execute();
});