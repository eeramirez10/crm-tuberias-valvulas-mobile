import '../../domain/entities/create_activity_input.dart';

class CreateActivityRequestDto {
  const CreateActivityRequestDto({
    required this.type,
    required this.summary,
    required this.owner,
  });

  final String type;
  final String summary;
  final String owner;

  factory CreateActivityRequestDto.fromInput(CreateActivityInput input) {
    return CreateActivityRequestDto(
      type: input.type,
      summary: input.summary,
      owner: input.owner,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'type': type, 'summary': summary, 'owner': owner};
  }
}
