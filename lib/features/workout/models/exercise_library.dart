import 'exercise_model.dart';

/// Catálogo estático de ejercicios clasificados.
/// Se mantiene en local (dato de referencia, no cambia por usuario).
class ExerciseLibrary {
  ExerciseLibrary._();

  static const List<ExerciseModel> all = [
    // ═══════════════════════════════════════════
    // PUSH HORIZONTAL
    // ═══════════════════════════════════════════

    // PRINCIPIANTE

    ExerciseModel(
      id: 'incline_push_up',
      nameEs: 'Lagartijas inclinadas',
      muscleGroups: [
        MuscleGroup.pecho,
        MuscleGroup.triceps,
        MuscleGroup.hombros
      ],
      primaryMuscle: MuscleGroup.pecho,
      movementPattern: MovementPattern.pushHorizontal,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 2,
      isCompound: true,
      goals: [
        TrainingGoal.ganarMusculo,
        TrainingGoal.mejorarResistencia,
        TrainingGoal.bajarPeso
      ],
      alternatives: ['push_up', 'machine_chest_press'],
      tags: ['beginner_friendly', 'bodyweight'],
    ),

    ExerciseModel(
      id: 'push_up',
      nameEs: 'Lagartijas',
      muscleGroups: [
        MuscleGroup.pecho,
        MuscleGroup.triceps,
        MuscleGroup.hombros
      ],
      primaryMuscle: MuscleGroup.pecho,
      movementPattern: MovementPattern.pushHorizontal,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 2,
      fatigue: 3,
      isCompound: true,
      goals: [
        TrainingGoal.ganarMusculo,
        TrainingGoal.mejorarResistencia,
        TrainingGoal.bajarPeso
      ],
      alternatives: ['machine_chest_press'],
      tags: ['bodyweight', 'functional', 'beginner_friendly'],
    ),

    ExerciseModel(
      id: 'machine_chest_press',
      nameEs: 'Press pecho en máquina',
      muscleGroups: [MuscleGroup.pecho, MuscleGroup.triceps],
      primaryMuscle: MuscleGroup.pecho,
      movementPattern: MovementPattern.pushHorizontal,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 3,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      alternatives: ['push_up', 'bench_press_barbell'],
      tags: ['machine', 'beginner_friendly'],
    ),

    ExerciseModel(
      id: 'seated_dumbbell_press',
      nameEs: 'Press hombro sentado con mancuernas',
      muscleGroups: [MuscleGroup.hombros, MuscleGroup.triceps],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 3,
      fatigue: 4,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      alternatives: ['machine_shoulder_press'],
      tags: ['shoulders', 'dumbbell', 'beginner_friendly'],
    ),

    ExerciseModel(
      id: 'machine_shoulder_press',
      nameEs: 'Press hombro en máquina',
      muscleGroups: [MuscleGroup.hombros, MuscleGroup.triceps],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 3,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      alternatives: ['seated_dumbbell_press'],
      tags: ['machine', 'shoulders', 'beginner_friendly'],
    ),

    ExerciseModel(
      id: 'assisted_dips',
      nameEs: 'Fondos asistidos',
      muscleGroups: [
        MuscleGroup.pecho,
        MuscleGroup.triceps,
        MuscleGroup.hombros
      ],
      primaryMuscle: MuscleGroup.triceps,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 4,
      fatigue: 5,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mejorarResistencia],
      alternatives: ['bench_dips', 'dips'],
      tags: ['assisted', 'compound'],
    ),

    ExerciseModel(
      id: 'arnold_press_light',
      nameEs: 'Press Arnold ligero',
      muscleGroups: [MuscleGroup.hombros, MuscleGroup.triceps],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 4,
      fatigue: 4,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['seated_dumbbell_press'],
      tags: ['dumbbell', 'hypertrophy'],
    ),

    // INTERMEDIO

    ExerciseModel(
      id: 'bench_press_barbell',
      nameEs: 'Press banca con barra',
      muscleGroups: [
        MuscleGroup.pecho,
        MuscleGroup.triceps,
        MuscleGroup.hombros
      ],
      primaryMuscle: MuscleGroup.pecho,
      movementPattern: MovementPattern.pushHorizontal,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.competir],
      alternatives: ['dumbbell_bench_press'],
      tags: ['strength', 'barbell', 'compound'],
    ),

    ExerciseModel(
      id: 'incline_dumbbell_press',
      nameEs: 'Press inclinado con mancuernas',
      muscleGroups: [
        MuscleGroup.pecho,
        MuscleGroup.triceps,
        MuscleGroup.hombros
      ],
      primaryMuscle: MuscleGroup.pecho,
      movementPattern: MovementPattern.pushHorizontal,
      equipment: [EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 5,
      fatigue: 6,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['bench_press_barbell'],
      tags: ['upper_chest', 'hypertrophy'],
    ),

    ExerciseModel(
      id: 'overhead_press_barbell',
      nameEs: 'Press militar con barra',
      muscleGroups: [MuscleGroup.hombros, MuscleGroup.triceps],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.competir],
      alternatives: ['seated_dumbbell_press'],
      tags: ['strength', 'barbell', 'shoulders'],
    ),

    ExerciseModel(
      id: 'dips',
      nameEs: 'Fondos en paralelas',
      muscleGroups: [
        MuscleGroup.pecho,
        MuscleGroup.triceps,
        MuscleGroup.hombros
      ],
      primaryMuscle: MuscleGroup.triceps,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 6,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mejorarResistencia],
      alternatives: ['assisted_dips'],
      tags: ['bodyweight', 'compound'],
    ),

    ExerciseModel(
      id: 'close_grip_bench_press',
      nameEs: 'Press cerrado',
      muscleGroups: [MuscleGroup.pecho, MuscleGroup.triceps],
      primaryMuscle: MuscleGroup.triceps,
      movementPattern: MovementPattern.pushHorizontal,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.competir],
      alternatives: ['bench_press_barbell'],
      tags: ['triceps_focus', 'barbell'],
    ),

    ExerciseModel(
      id: 'push_press',
      nameEs: 'Push Press',
      muscleGroups: [
        MuscleGroup.hombros,
        MuscleGroup.triceps,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 7,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.ganarMusculo],
      alternatives: ['overhead_press_barbell'],
      tags: ['explosive', 'strength', 'athletic'],
    ),

    // AVANZADO

    ExerciseModel(
      id: 'paused_bench_press',
      nameEs: 'Press banca pausado',
      muscleGroups: [
        MuscleGroup.pecho,
        MuscleGroup.triceps,
        MuscleGroup.hombros
      ],
      primaryMuscle: MuscleGroup.pecho,
      movementPattern: MovementPattern.pushHorizontal,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 8,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.competir],
      alternatives: ['bench_press_barbell'],
      tags: ['powerlifting', 'strength'],
    ),

    ExerciseModel(
      id: 'handstand_push_up',
      nameEs: 'Handstand Push-Up',
      muscleGroups: [
        MuscleGroup.hombros,
        MuscleGroup.triceps,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 9,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.mejorarResistencia],
      alternatives: ['overhead_press_barbell'],
      tags: ['gymnastics', 'bodyweight', 'advanced'],
    ),

    ExerciseModel(
      id: 'weighted_dips',
      nameEs: 'Fondos lastrados',
      muscleGroups: [
        MuscleGroup.pecho,
        MuscleGroup.triceps,
        MuscleGroup.hombros
      ],
      primaryMuscle: MuscleGroup.triceps,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 8,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.ganarMusculo],
      alternatives: ['dips'],
      tags: ['weighted', 'strength', 'compound'],
    ),

    ExerciseModel(
      id: 'strict_overhead_press_heavy',
      nameEs: 'Press militar estricto pesado',
      muscleGroups: [
        MuscleGroup.hombros,
        MuscleGroup.triceps,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 8,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.ganarMusculo],
      alternatives: ['push_press'],
      tags: ['strength', 'barbell', 'advanced'],
    ),

    // ═══════════════════════════════════════════
    // PULL VERTICAL
    // ═══════════════════════════════════════════

    // PRINCIPIANTE

    ExerciseModel(
      id: 'lat_pulldown',
      nameEs: 'Jalón al pecho',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.cable],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 2,
      fatigue: 3,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mejorarResistencia],
      alternatives: ['pull_up', 'assisted_pull_up'],
      tags: ['beginner_friendly', 'machine', 'back'],
    ),

    ExerciseModel(
      id: 'seated_row_machine',
      nameEs: 'Remo en máquina',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullHorizontal,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 2,
      fatigue: 3,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      alternatives: ['barbell_row', 'single_arm_dumbbell_row'],
      tags: ['machine', 'beginner_friendly'],
    ),

    ExerciseModel(
      id: 'single_arm_dumbbell_row',
      nameEs: 'Remo unilateral con mancuerna',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullHorizontal,
      equipment: [EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 3,
      fatigue: 4,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['seated_row_machine'],
      tags: ['dumbbell', 'unilateral', 'hypertrophy'],
    ),

    ExerciseModel(
      id: 'face_pull',
      nameEs: 'Face Pull',
      muscleGroups: [MuscleGroup.hombros, MuscleGroup.espalda],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.pullHorizontal,
      equipment: [EquipmentType.cable],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 2,
      fatigue: 2,
      isCompound: false,
      goals: [TrainingGoal.mantenerme, TrainingGoal.ganarMusculo],
      alternatives: ['rear_delt_row'],
      tags: ['rear_delts', 'posture', 'rehab'],
    ),

    ExerciseModel(
      id: 'dumbbell_bicep_curl',
      nameEs: 'Curl de bíceps con mancuerna',
      muscleGroups: [MuscleGroup.biceps],
      primaryMuscle: MuscleGroup.biceps,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 2,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['barbell_bicep_curl'],
      tags: ['isolation', 'arms', 'hypertrophy'],
    ),

    ExerciseModel(
      id: 'assisted_pull_up',
      nameEs: 'Dominadas asistidas',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 4,
      fatigue: 5,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mejorarResistencia],
      alternatives: ['pull_up', 'lat_pulldown'],
      tags: ['assisted', 'bodyweight_progression'],
    ),

    // INTERMEDIO

    ExerciseModel(
      id: 'pull_up',
      nameEs: 'Dominadas',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps, MuscleGroup.core],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 6,
      isCompound: true,
      goals: [
        TrainingGoal.ganarMusculo,
        TrainingGoal.competir,
        TrainingGoal.mejorarResistencia
      ],
      alternatives: ['lat_pulldown'],
      tags: ['bodyweight', 'strength', 'compound'],
    ),

    ExerciseModel(
      id: 'barbell_row',
      nameEs: 'Remo con barra',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps, MuscleGroup.core],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullHorizontal,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.competir],
      alternatives: ['t_bar_row'],
      tags: ['strength', 'barbell', 'compound'],
    ),

    ExerciseModel(
      id: 't_bar_row',
      nameEs: 'Remo T-Bar',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullHorizontal,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 5,
      fatigue: 6,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['barbell_row'],
      tags: ['hypertrophy', 'back_thickness'],
    ),

    ExerciseModel(
      id: 'barbell_bicep_curl',
      nameEs: 'Curl con barra Z',
      muscleGroups: [MuscleGroup.biceps],
      primaryMuscle: MuscleGroup.biceps,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 2,
      fatigue: 3,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['dumbbell_bicep_curl'],
      tags: ['arms', 'isolation', 'hypertrophy'],
    ),

    ExerciseModel(
      id: 'cable_pullover',
      nameEs: 'Pull-over en cable',
      muscleGroups: [MuscleGroup.espalda],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.cable],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 3,
      fatigue: 3,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['lat_pulldown'],
      tags: ['lat_focus', 'isolation'],
    ),

    ExerciseModel(
      id: 'chin_up',
      nameEs: 'Chin-Up',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps, MuscleGroup.core],
      primaryMuscle: MuscleGroup.biceps,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 6,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mejorarResistencia],
      alternatives: ['pull_up'],
      tags: ['bodyweight', 'biceps_focus'],
    ),

    // AVANZADO

    ExerciseModel(
      id: 'weighted_pull_up',
      nameEs: 'Dominadas lastradas',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps, MuscleGroup.core],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 8,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.ganarMusculo],
      alternatives: ['pull_up'],
      tags: ['weighted', 'strength', 'advanced'],
    ),

    ExerciseModel(
      id: 'muscle_up',
      nameEs: 'Muscle-Up',
      muscleGroups: [
        MuscleGroup.espalda,
        MuscleGroup.biceps,
        MuscleGroup.hombros,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 10,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir],
      alternatives: ['pull_up'],
      tags: ['gymnastics', 'explosive', 'advanced'],
    ),

    ExerciseModel(
      id: 'pendlay_row',
      nameEs: 'Remo Pendlay',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps, MuscleGroup.core],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullHorizontal,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 8,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.ganarMusculo],
      alternatives: ['barbell_row'],
      tags: ['strength', 'explosive', 'barbell'],
    ),

    ExerciseModel(
      id: 'high_pull',
      nameEs: 'High Pull',
      muscleGroups: [
        MuscleGroup.espalda,
        MuscleGroup.hombros,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 9,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir],
      alternatives: ['power_clean'],
      tags: ['olympic', 'explosive', 'athletic'],
    ),

    ExerciseModel(
      id: 'explosive_pull_up',
      nameEs: 'Dominadas explosivas',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps, MuscleGroup.core],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullVertical,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 8,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.mejorarResistencia],
      alternatives: ['weighted_pull_up'],
      tags: ['explosive', 'bodyweight'],
    ),

    ExerciseModel(
      id: 'front_lever_row',
      nameEs: 'Front Lever Row',
      muscleGroups: [MuscleGroup.espalda, MuscleGroup.biceps, MuscleGroup.core],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.pullHorizontal,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 10,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir],
      alternatives: ['pull_up'],
      tags: ['gymnastics', 'advanced', 'core_strength'],
    ),

    // ═══════════════════════════════════════════
    // KNEE HINGE (Pierna – dominante rodilla)
    // ═══════════════════════════════════════════

    // PRINCIPIANTE

    ExerciseModel(
      id: 'goblet_squat',
      nameEs: 'Sentadilla Goblet',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.mancuernas, EquipmentType.kettlebell],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 3,
      fatigue: 4,
      isCompound: true,
      goals: [
        TrainingGoal.ganarMusculo,
        TrainingGoal.bajarPeso,
        TrainingGoal.mantenerme
      ],
      alternatives: ['back_squat', 'leg_press'],
      tags: ['beginner_friendly', 'mobility', 'compound'],
    ),

    ExerciseModel(
      id: 'leg_press',
      nameEs: 'Prensa de pierna',
      muscleGroups: [MuscleGroup.cuadriceps, MuscleGroup.gluteos],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 5,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      alternatives: ['goblet_squat', 'hack_squat'],
      tags: ['machine', 'hypertrophy', 'beginner_friendly'],
    ),

    ExerciseModel(
      id: 'bodyweight_squat',
      nameEs: 'Sentadilla libre',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 2,
      isCompound: true,
      goals: [
        TrainingGoal.bajarPeso,
        TrainingGoal.mejorarResistencia,
        TrainingGoal.mantenerme
      ],
      alternatives: ['goblet_squat'],
      tags: ['bodyweight', 'functional', 'mobility'],
    ),

    ExerciseModel(
      id: 'leg_extension',
      nameEs: 'Extensión de cuádriceps',
      muscleGroups: [MuscleGroup.cuadriceps],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 3,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['sissy_squat'],
      tags: ['isolation', 'machine', 'hypertrophy'],
    ),

    ExerciseModel(
      id: 'step_up',
      nameEs: 'Step-Up',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.pesoCorporal, EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 3,
      fatigue: 4,
      isCompound: true,
      goals: [
        TrainingGoal.bajarPeso,
        TrainingGoal.mejorarResistencia,
        TrainingGoal.ganarMusculo
      ],
      alternatives: ['walking_lunge'],
      tags: ['unilateral', 'functional'],
    ),

    ExerciseModel(
      id: 'split_squat',
      nameEs: 'Split Squat',
      muscleGroups: [MuscleGroup.cuadriceps, MuscleGroup.gluteos],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.pesoCorporal, EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 4,
      fatigue: 5,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mejorarResistencia],
      alternatives: ['bulgarian_split_squat'],
      tags: ['unilateral', 'balance'],
    ),

    // INTERMEDIO

    ExerciseModel(
      id: 'back_squat',
      nameEs: 'Sentadilla con barra',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 7,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.competir],
      alternatives: ['front_squat'],
      tags: ['barbell', 'strength', 'compound'],
    ),

    ExerciseModel(
      id: 'front_squat',
      nameEs: 'Sentadilla frontal',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.core,
        MuscleGroup.gluteos
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 8,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.competir],
      alternatives: ['back_squat'],
      tags: ['barbell', 'olympic', 'quad_focus'],
    ),

    ExerciseModel(
      id: 'bulgarian_split_squat',
      nameEs: 'Bulgarian Split Squat',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.bajarPeso],
      alternatives: ['split_squat'],
      tags: ['unilateral', 'hypertrophy', 'balance'],
    ),

    ExerciseModel(
      id: 'hack_squat',
      nameEs: 'Hack Squat',
      muscleGroups: [MuscleGroup.cuadriceps, MuscleGroup.gluteos],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 3,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['leg_press', 'back_squat'],
      tags: ['machine', 'quad_focus', 'hypertrophy'],
    ),

    ExerciseModel(
      id: 'walking_lunge',
      nameEs: 'Zancadas caminando',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 5,
      fatigue: 6,
      isCompound: true,
      goals: [
        TrainingGoal.bajarPeso,
        TrainingGoal.ganarMusculo,
        TrainingGoal.mejorarResistencia
      ],
      alternatives: ['step_up'],
      tags: ['functional', 'unilateral'],
    ),

    // AVANZADO

    ExerciseModel(
      id: 'heavy_back_squat',
      nameEs: 'Back Squat pesado',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 9,
      fatigue: 10,
      isCompound: true,
      goals: [TrainingGoal.competir],
      alternatives: ['paused_squat'],
      tags: ['powerlifting', 'strength', 'advanced'],
    ),

    ExerciseModel(
      id: 'olympic_front_squat',
      nameEs: 'Front Squat olímpico',
      muscleGroups: [MuscleGroup.cuadriceps, MuscleGroup.core],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 9,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir],
      alternatives: ['front_squat'],
      tags: ['olympic', 'advanced', 'strength'],
    ),

    ExerciseModel(
      id: 'pause_squat',
      nameEs: 'Pause Squat',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 8,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.ganarMusculo],
      alternatives: ['back_squat'],
      tags: ['strength', 'powerlifting'],
    ),

    ExerciseModel(
      id: 'zercher_squat',
      nameEs: 'Zercher Squat',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 9,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.ganarMusculo],
      alternatives: ['front_squat'],
      tags: ['functional', 'barbell', 'advanced'],
    ),

    ExerciseModel(
      id: 'pistol_squat',
      nameEs: 'Pistol Squat',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 10,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.mejorarResistencia],
      alternatives: ['split_squat'],
      tags: ['bodyweight', 'balance', 'advanced'],
    ),

    ExerciseModel(
      id: 'advanced_sissy_squat',
      nameEs: 'Sissy Squat avanzada',
      muscleGroups: [MuscleGroup.cuadriceps],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.kneeHinge,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 8,
      fatigue: 7,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['leg_extension'],
      tags: ['quad_focus', 'advanced', 'isolation'],
    ),

    // ═══════════════════════════════════════════
    // HIP HINGE (Bisagra de cadera)
    // ═══════════════════════════════════════════

    // PRINCIPIANTE

    ExerciseModel(
      id: 'light_romanian_deadlift',
      nameEs: 'Peso muerto rumano ligero',
      muscleGroups: [
        MuscleGroup.isquiotibiales,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.isquiotibiales,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.mancuernas, EquipmentType.barra],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 3,
      fatigue: 4,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      alternatives: ['romanian_deadlift', 'hip_thrust'],
      tags: ['beginner_friendly', 'posterior_chain', 'hinge'],
    ),

    ExerciseModel(
      id: 'machine_hip_thrust',
      nameEs: 'Hip Thrust en máquina',
      muscleGroups: [MuscleGroup.gluteos, MuscleGroup.isquiotibiales],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 2,
      fatigue: 4,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      alternatives: ['barbell_hip_thrust'],
      tags: ['glute_focus', 'machine', 'beginner_friendly'],
    ),

    ExerciseModel(
      id: 'good_morning_pvc',
      nameEs: 'Buenos días con PVC',
      muscleGroups: [
        MuscleGroup.isquiotibiales,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.isquiotibiales,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 2,
      fatigue: 2,
      isCompound: true,
      goals: [TrainingGoal.mantenerme, TrainingGoal.mejorarResistencia],
      alternatives: ['light_romanian_deadlift'],
      tags: ['mobility', 'technique', 'beginner_friendly'],
    ),

    ExerciseModel(
      id: 'cable_pull_through',
      nameEs: 'Pull-Through en cable',
      muscleGroups: [MuscleGroup.gluteos, MuscleGroup.isquiotibiales],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.cable],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 3,
      fatigue: 3,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.bajarPeso],
      alternatives: ['kettlebell_swing'],
      tags: ['glute_focus', 'functional'],
    ),

    // INTERMEDIO

    ExerciseModel(
      id: 'deadlift',
      nameEs: 'Peso muerto convencional',
      muscleGroups: [
        MuscleGroup.isquiotibiales,
        MuscleGroup.gluteos,
        MuscleGroup.espalda,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.isquiotibiales,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 7,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.competir],
      alternatives: ['sumo_deadlift', 'romanian_deadlift'],
      tags: ['strength', 'barbell', 'compound'],
    ),

    ExerciseModel(
      id: 'sumo_deadlift',
      nameEs: 'Peso muerto sumo',
      muscleGroups: [
        MuscleGroup.gluteos,
        MuscleGroup.isquiotibiales,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 7,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.ganarMusculo],
      alternatives: ['deadlift'],
      tags: ['powerlifting', 'barbell', 'strength'],
    ),

    ExerciseModel(
      id: 'barbell_hip_thrust',
      nameEs: 'Hip Thrust con barra',
      muscleGroups: [MuscleGroup.gluteos, MuscleGroup.isquiotibiales],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 5,
      fatigue: 6,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      alternatives: ['machine_hip_thrust'],
      tags: ['glute_focus', 'hypertrophy'],
    ),

    ExerciseModel(
      id: 'romanian_deadlift',
      nameEs: 'Romanian Deadlift',
      muscleGroups: [
        MuscleGroup.isquiotibiales,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.isquiotibiales,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.barra, EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.competir],
      alternatives: ['deadlift'],
      tags: ['posterior_chain', 'hypertrophy'],
    ),

    ExerciseModel(
      id: 'kettlebell_swing',
      nameEs: 'Kettlebell Swing',
      muscleGroups: [
        MuscleGroup.gluteos,
        MuscleGroup.isquiotibiales,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.kettlebell],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.bajarPeso, TrainingGoal.mejorarResistencia],
      alternatives: ['cable_pull_through'],
      tags: ['explosive', 'conditioning', 'functional'],
    ),

    // AVANZADO

    ExerciseModel(
      id: 'heavy_deadlift',
      nameEs: 'Deadlift pesado',
      muscleGroups: [
        MuscleGroup.isquiotibiales,
        MuscleGroup.gluteos,
        MuscleGroup.espalda,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.isquiotibiales,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 9,
      fatigue: 10,
      isCompound: true,
      goals: [TrainingGoal.competir],
      alternatives: ['deadlift'],
      tags: ['powerlifting', 'max_strength', 'advanced'],
    ),

    ExerciseModel(
      id: 'deficit_deadlift',
      nameEs: 'Deficit Deadlift',
      muscleGroups: [
        MuscleGroup.isquiotibiales,
        MuscleGroup.gluteos,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.isquiotibiales,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 9,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.ganarMusculo],
      alternatives: ['heavy_deadlift'],
      tags: ['strength', 'barbell', 'advanced'],
    ),

    ExerciseModel(
      id: 'snatch_grip_deadlift',
      nameEs: 'Snatch Grip Deadlift',
      muscleGroups: [
        MuscleGroup.isquiotibiales,
        MuscleGroup.gluteos,
        MuscleGroup.espalda,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 9,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir],
      alternatives: ['deadlift'],
      tags: ['olympic', 'posterior_chain', 'advanced'],
    ),

    ExerciseModel(
      id: 'clean_pull',
      nameEs: 'Clean Pull',
      muscleGroups: [
        MuscleGroup.gluteos,
        MuscleGroup.isquiotibiales,
        MuscleGroup.espalda,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 10,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir],
      alternatives: ['high_pull'],
      tags: ['olympic', 'explosive', 'athletic'],
    ),

    ExerciseModel(
      id: 'jefferson_deadlift',
      nameEs: 'Jefferson Deadlift',
      muscleGroups: [
        MuscleGroup.gluteos,
        MuscleGroup.isquiotibiales,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.hipHinge,
      equipment: [EquipmentType.barra],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 8,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.competir],
      alternatives: ['sumo_deadlift'],
      tags: ['functional', 'advanced', 'strength'],
    ),

    // ═══════════════════════════════════════════
    // CORE
    // ═══════════════════════════════════════════

    // PRINCIPIANTE

    ExerciseModel(
      id: 'plank',
      nameEs: 'Plancha',
      muscleGroups: [MuscleGroup.core],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 2,
      isCompound: false,
      goals: [
        TrainingGoal.mantenerme,
        TrainingGoal.mejorarResistencia,
        TrainingGoal.bajarPeso
      ],
      alternatives: ['side_plank', 'dead_bug'],
      tags: ['stability', 'beginner_friendly', 'bodyweight'],
    ),

    ExerciseModel(
      id: 'dead_bug',
      nameEs: 'Dead Bug',
      muscleGroups: [MuscleGroup.core],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 2,
      fatigue: 2,
      isCompound: false,
      goals: [TrainingGoal.mantenerme, TrainingGoal.mejorarResistencia],
      alternatives: ['plank'],
      tags: ['stability', 'rehab', 'mobility'],
    ),

    ExerciseModel(
      id: 'machine_crunch',
      nameEs: 'Crunch en máquina',
      muscleGroups: [MuscleGroup.core],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 3,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      alternatives: ['cable_crunch'],
      tags: ['machine', 'hypertrophy', 'abs'],
    ),

    ExerciseModel(
      id: 'knee_raise',
      nameEs: 'Elevación de rodillas',
      muscleGroups: [MuscleGroup.core],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 3,
      fatigue: 3,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mejorarResistencia],
      alternatives: ['leg_raise'],
      tags: ['bodyweight', 'lower_abs'],
    ),

    // INTERMEDIO

    ExerciseModel(
      id: 'hanging_leg_raise',
      nameEs: 'Hanging Leg Raise',
      muscleGroups: [MuscleGroup.core],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 6,
      fatigue: 5,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mejorarResistencia],
      alternatives: ['knee_raise'],
      tags: ['bodyweight', 'lower_abs', 'advanced_control'],
    ),

    ExerciseModel(
      id: 'russian_twist',
      nameEs: 'Russian Twist',
      muscleGroups: [MuscleGroup.core],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.pesoCorporal, EquipmentType.kettlebell],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 4,
      fatigue: 4,
      isCompound: false,
      goals: [TrainingGoal.bajarPeso, TrainingGoal.mejorarResistencia],
      alternatives: ['wood_chopper'],
      tags: ['rotational', 'functional'],
    ),

    ExerciseModel(
      id: 'cable_crunch',
      nameEs: 'Cable Crunch',
      muscleGroups: [MuscleGroup.core],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.cable],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 3,
      fatigue: 4,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo],
      alternatives: ['machine_crunch'],
      tags: ['hypertrophy', 'weighted_abs'],
    ),

    ExerciseModel(
      id: 'dragon_flag_progression',
      nameEs: 'Progresión Dragon Flag',
      muscleGroups: [MuscleGroup.core],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 7,
      fatigue: 6,
      isCompound: false,
      goals: [TrainingGoal.mejorarResistencia, TrainingGoal.competir],
      alternatives: ['dragon_flag'],
      tags: ['gymnastics', 'body_control'],
    ),

    // AVANZADO

    ExerciseModel(
      id: 'dragon_flag',
      nameEs: 'Dragon Flag',
      muscleGroups: [MuscleGroup.core],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 10,
      fatigue: 8,
      isCompound: false,
      goals: [TrainingGoal.competir, TrainingGoal.mejorarResistencia],
      alternatives: ['dragon_flag_progression'],
      tags: ['advanced', 'gymnastics', 'bodyweight'],
    ),

    ExerciseModel(
      id: 'front_lever_hold',
      nameEs: 'Front Lever Hold',
      muscleGroups: [MuscleGroup.core, MuscleGroup.espalda],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 10,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.competir],
      alternatives: ['front_lever_row'],
      tags: ['gymnastics', 'isometric', 'advanced'],
    ),

    ExerciseModel(
      id: 'toes_to_bar',
      nameEs: 'Toes to Bar',
      muscleGroups: [MuscleGroup.core, MuscleGroup.espalda],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 8,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.mejorarResistencia],
      alternatives: ['hanging_leg_raise'],
      tags: ['crossfit', 'bodyweight', 'dynamic_core'],
    ),

    ExerciseModel(
      id: 'windshield_wipers',
      nameEs: 'Windshield Wipers',
      muscleGroups: [MuscleGroup.core],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.core,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 9,
      fatigue: 8,
      isCompound: false,
      goals: [TrainingGoal.competir, TrainingGoal.mejorarResistencia],
      alternatives: ['russian_twist'],
      tags: ['rotational', 'advanced', 'bodyweight'],
    ),

    // ═══════════════════════════════════════════
    // AISLAMIENTO - Biceps / Triceps
    // ═══════════════════════════════════════════
    ExerciseModel(
      id: 'db_bicep_curl',
      nameEs: 'Curl bíceps mancuerna',
      muscleGroups: [MuscleGroup.biceps],
      primaryMuscle: MuscleGroup.biceps,
      movementPattern: MovementPattern.pullHorizontal,
      equipment: [EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 2,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      tags: ['beginner_friendly', 'dumbbell', 'isolation'],
    ),
    ExerciseModel(
      id: 'tricep_pushdown',
      nameEs: 'Extensión tríceps en cable',
      muscleGroups: [MuscleGroup.triceps],
      primaryMuscle: MuscleGroup.triceps,
      movementPattern: MovementPattern.pushHorizontal,
      equipment: [EquipmentType.cable],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 2,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      tags: ['beginner_friendly', 'cable', 'isolation'],
    ),
    ExerciseModel(
      id: 'lateral_raise',
      nameEs: 'Elevaciones laterales',
      muscleGroups: [MuscleGroup.hombros],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.pushVertical,
      equipment: [EquipmentType.mancuernas],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 2,
      fatigue: 2,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo],
      tags: ['beginner_friendly', 'dumbbell', 'isolation'],
    ),
    ExerciseModel(
      id: 'face_pull',
      nameEs: 'Face pulls',
      muscleGroups: [MuscleGroup.hombros, MuscleGroup.espalda],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.pullHorizontal,
      equipment: [EquipmentType.cable],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 2,
      fatigue: 2,
      isCompound: false,
      goals: [TrainingGoal.ganarMusculo, TrainingGoal.mantenerme],
      tags: ['beginner_friendly', 'cable', 'isolation'],
    ),

    // ═══════════════════════════════════════════
    // CARDIO
    // ═══════════════════════════════════════════

    // BAJA INTENSIDAD

    ExerciseModel(
      id: 'incline_treadmill_walk',
      nameEs: 'Caminadora inclinada',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.pantorrillas
      ],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.caminadora],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 3,
      isCompound: true,
      goals: [
        TrainingGoal.bajarPeso,
        TrainingGoal.mejorarResistencia,
        TrainingGoal.mantenerme
      ],
      alternatives: ['outdoor_walk', 'elliptical'],
      tags: ['cardio', 'low_impact', 'fat_loss'],
    ),

    ExerciseModel(
      id: 'stationary_bike',
      nameEs: 'Bicicleta estática',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.pantorrillas,
        MuscleGroup.gluteos
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.bicicleta],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 3,
      isCompound: true,
      goals: [TrainingGoal.bajarPeso, TrainingGoal.mejorarResistencia],
      alternatives: ['assault_bike'],
      tags: ['cardio', 'low_impact', 'endurance'],
    ),

    ExerciseModel(
      id: 'elliptical',
      nameEs: 'Elíptica',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.pantorrillas
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 2,
      isCompound: true,
      goals: [TrainingGoal.bajarPeso, TrainingGoal.mantenerme],
      alternatives: ['incline_treadmill_walk'],
      tags: ['low_impact', 'steady_state'],
    ),

    ExerciseModel(
      id: 'outdoor_walk',
      nameEs: 'Caminata exterior',
      muscleGroups: [MuscleGroup.cuadriceps, MuscleGroup.pantorrillas],
      primaryMuscle: MuscleGroup.pantorrillas,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.principiante,
      skillRequirement: 1,
      fatigue: 1,
      isCompound: true,
      goals: [
        TrainingGoal.bajarPeso,
        TrainingGoal.mantenerme,
        TrainingGoal.mejorarResistencia
      ],
      alternatives: ['incline_treadmill_walk'],
      tags: ['recovery', 'low_intensity', 'fat_loss'],
    ),

    // MEDIA INTENSIDAD

    ExerciseModel(
      id: 'rowing_machine',
      nameEs: 'Remo ergómetro',
      muscleGroups: [
        MuscleGroup.espalda,
        MuscleGroup.core,
        MuscleGroup.cuadriceps
      ],
      primaryMuscle: MuscleGroup.espalda,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 4,
      fatigue: 5,
      isCompound: true,
      goals: [TrainingGoal.mejorarResistencia, TrainingGoal.bajarPeso],
      alternatives: ['battle_ropes'],
      tags: ['full_body', 'conditioning', 'endurance'],
    ),

    ExerciseModel(
      id: 'stairmaster',
      nameEs: 'Stairmaster',
      muscleGroups: [
        MuscleGroup.gluteos,
        MuscleGroup.cuadriceps,
        MuscleGroup.pantorrillas
      ],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.maquina],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 2,
      fatigue: 6,
      isCompound: true,
      goals: [TrainingGoal.bajarPeso, TrainingGoal.mejorarResistencia],
      alternatives: ['incline_treadmill_walk'],
      tags: ['fat_loss', 'glute_focus', 'conditioning'],
    ),

    ExerciseModel(
      id: 'functional_circuit',
      nameEs: 'Circuito funcional',
      muscleGroups: [
        MuscleGroup.core,
        MuscleGroup.cuadriceps,
        MuscleGroup.hombros,
        MuscleGroup.espalda
      ],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.cardio,
      equipment: [
        EquipmentType.mancuernas,
        EquipmentType.kettlebell,
        EquipmentType.pesoCorporal
      ],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 5,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.bajarPeso, TrainingGoal.mejorarResistencia],
      alternatives: ['hiit_training'],
      tags: ['functional', 'full_body', 'conditioning'],
    ),

    ExerciseModel(
      id: 'battle_ropes',
      nameEs: 'Battle Ropes',
      muscleGroups: [
        MuscleGroup.hombros,
        MuscleGroup.core,
        MuscleGroup.espalda
      ],
      primaryMuscle: MuscleGroup.hombros,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.cable],
      difficulty: ExerciseDifficulty.intermedio,
      skillRequirement: 4,
      fatigue: 7,
      isCompound: true,
      goals: [TrainingGoal.bajarPeso, TrainingGoal.mejorarResistencia],
      alternatives: ['rowing_machine'],
      tags: ['conditioning', 'upper_body', 'explosive'],
    ),

    // ALTA INTENSIDAD

    ExerciseModel(
      id: 'hiit_training',
      nameEs: 'HIIT',
      muscleGroups: [
        MuscleGroup.core,
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos
      ],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.pesoCorporal, EquipmentType.kettlebell],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 6,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.bajarPeso, TrainingGoal.mejorarResistencia],
      alternatives: ['functional_circuit'],
      tags: ['high_intensity', 'fat_loss', 'conditioning'],
    ),

    ExerciseModel(
      id: 'assault_bike',
      nameEs: 'Assault Bike',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.hombros,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.cuadriceps,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.bicicleta],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 5,
      fatigue: 9,
      isCompound: true,
      goals: [
        TrainingGoal.bajarPeso,
        TrainingGoal.mejorarResistencia,
        TrainingGoal.competir
      ],
      alternatives: ['stationary_bike'],
      tags: ['crossfit', 'high_intensity', 'conditioning'],
    ),

    ExerciseModel(
      id: 'sprints',
      nameEs: 'Sprints',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.pantorrillas,
        MuscleGroup.core
      ],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 7,
      fatigue: 10,
      isCompound: true,
      goals: [
        TrainingGoal.mejorarResistencia,
        TrainingGoal.competir,
        TrainingGoal.bajarPeso
      ],
      alternatives: ['hiit_training'],
      tags: ['explosive', 'athletic', 'speed'],
    ),

    ExerciseModel(
      id: 'burpees',
      nameEs: 'Burpees',
      muscleGroups: [
        MuscleGroup.core,
        MuscleGroup.pecho,
        MuscleGroup.cuadriceps,
        MuscleGroup.hombros
      ],
      primaryMuscle: MuscleGroup.core,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 6,
      fatigue: 9,
      isCompound: true,
      goals: [TrainingGoal.bajarPeso, TrainingGoal.mejorarResistencia],
      alternatives: ['hiit_training'],
      tags: ['full_body', 'conditioning', 'bodyweight'],
    ),

    ExerciseModel(
      id: 'box_jumps',
      nameEs: 'Box Jumps',
      muscleGroups: [
        MuscleGroup.cuadriceps,
        MuscleGroup.gluteos,
        MuscleGroup.pantorrillas
      ],
      primaryMuscle: MuscleGroup.gluteos,
      movementPattern: MovementPattern.cardio,
      equipment: [EquipmentType.pesoCorporal],
      difficulty: ExerciseDifficulty.avanzado,
      skillRequirement: 7,
      fatigue: 8,
      isCompound: true,
      goals: [TrainingGoal.competir, TrainingGoal.mejorarResistencia],
      alternatives: ['sprints'],
      tags: ['plyometric', 'explosive', 'athletic'],
    ),
  ];

  // ─── Helpers de búsqueda ───────────────────

  static List<ExerciseModel> byPattern(MovementPattern p) =>
      all.where((e) => e.movementPattern == p).toList();

  static List<ExerciseModel> byDifficulty(ExerciseDifficulty d) => all
      .where((e) => e.difficulty == d || e.difficulty.index <= d.index)
      .toList();

  static List<ExerciseModel> byMuscle(MuscleGroup m) =>
      all.where((e) => e.primaryMuscle == m).toList();

  static List<ExerciseModel> byGoal(TrainingGoal g) =>
      all.where((e) => e.goals.contains(g)).toList();

  /// Filtra por nivel + patrón + objetivo. Retorna lista priorizada.
  static List<ExerciseModel> query({
    required ExerciseDifficulty maxLevel,
    MovementPattern? pattern,
    TrainingGoal? goal,
    int? maxSkill,
  }) {
    return all.where((e) {
      if (e.difficulty.index > maxLevel.index) return false;
      if (pattern != null && e.movementPattern != pattern) return false;
      if (goal != null && !e.goals.contains(goal)) return false;
      if (maxSkill != null && e.skillRequirement > maxSkill) return false;
      return true;
    }).toList();
  }
}
