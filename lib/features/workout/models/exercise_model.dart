enum MovementPattern { pushHorizontal, pushVertical, pullHorizontal, pullVertical, kneeHinge, hipHinge, core, cardio }
enum MuscleGroup { pecho, espalda, hombros, biceps, triceps, cuadriceps, isquiotibiales, gluteos, core, pantorrillas }
enum ExerciseDifficulty { principiante, intermedio, avanzado }
enum TrainingGoal { bajarPeso, ganarMusculo, mejorarResistencia, mantenerme, competir }
enum EquipmentType { barra, mancuernas, maquina, cable, pesoCorporal, kettlebell, caminadora, bicicleta }

class ExerciseModel {
  final String id;
  final String nameEs;
  final List<MuscleGroup> muscleGroups;
  final MuscleGroup primaryMuscle;
  final MovementPattern movementPattern;
  final List<EquipmentType> equipment;
  final ExerciseDifficulty difficulty;
  final int skillRequirement;
  final int fatigue;
  final bool isCompound;
  final List<TrainingGoal> goals;
  final List<String> alternatives;
  final List<String> tags;

  const ExerciseModel({
    required this.id,
    required this.nameEs,
    required this.muscleGroups,
    required this.primaryMuscle,
    required this.movementPattern,
    required this.equipment,
    required this.difficulty,
    required this.skillRequirement,
    required this.fatigue,
    required this.isCompound,
    required this.goals,
    this.alternatives = const [],
    this.tags = const [],
  });

  Map<String, dynamic> toTrackerMap({required int targetSets, required int targetReps, String weight = 'BW'}) => {
    'name': nameEs,
    'targetSets': targetSets,
    'targetReps': targetReps,
    'weight': weight,
    'exerciseId': id,
  };
}
