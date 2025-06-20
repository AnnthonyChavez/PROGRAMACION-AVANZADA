import '../../data/models/character_model.dart';
import '../../data/datasources/character_remote_data_source.dart';

class GetCharactersUseCase {
  final CharacterRemoteDataSource remoteDataSource;

  GetCharactersUseCase(this.remoteDataSource);

  Future<List<CharacterModel>> execute() async {
    return await remoteDataSource.getCharacters();
  }
}