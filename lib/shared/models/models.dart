class UserModel {
  final String id;
  final String? gymId;
  final String? fullName;
  final String? sexo;
  final DateTime? fechaNacimiento;
  final double? pesoKg;
  final double? estaturaCm;
  final String? tiempoEntrenando;
  final String? diasSemana;
  final String? sigueRutina;
  final String? objetivo;
  final String? sentadilla;
  final String? dominadas;
  final int nivel;
  final String rango;
  final int xpTotal;
  final int puntosSemana;
  final String subscriptionTier;
  final int streak;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    this.gymId,
    this.fullName,
    this.sexo,
    this.fechaNacimiento,
    this.pesoKg,
    this.estaturaCm,
    this.tiempoEntrenando,
    this.diasSemana,
    this.sigueRutina,
    this.objetivo,
    this.sentadilla,
    this.dominadas,
    this.nivel = 1,
    this.rango = 'Novato',
    this.xpTotal = 0,
    this.puntosSemana = 0,
    this.subscriptionTier = 'Free',
    this.streak = 0,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPro => subscriptionTier == 'Premium';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      gymId: json['gym_id'] as String?,
      fullName: json['full_name'] as String?,
      sexo: json['sexo'] as String?,
      fechaNacimiento: json['fecha_nacimiento'] != null ? DateTime.parse(json['fecha_nacimiento'] as String) : null,
      pesoKg: (json['peso_kg'] as num?)?.toDouble(),
      estaturaCm: (json['estatura_cm'] as num?)?.toDouble(),
      tiempoEntrenando: json['tiempo_entrenando'] as String?,
      diasSemana: json['dias_semana'] as String?,
      sigueRutina: json['sigue_rutina'] as String?,
      objetivo: json['objetivo'] as String?,
      sentadilla: json['sentadilla'] as String?,
      dominadas: json['dominadas'] as String?,
      nivel: json['nivel'] as int? ?? 1,
      rango: json['rango'] as String? ?? 'Novato',
      xpTotal: json['xp_total'] as int? ?? 0,
      puntosSemana: json['puntos_semana'] as int? ?? 0,
      subscriptionTier: json['subscription_tier'] as String? ?? 'Free',
      streak: json['streak'] as int? ?? 0,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gym_id': gymId,
      'full_name': fullName,
      'sexo': sexo,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'peso_kg': pesoKg,
      'estatura_cm': estaturaCm,
      'tiempo_entrenando': tiempoEntrenando,
      'dias_semana': diasSemana,
      'sigue_rutina': sigueRutina,
      'objetivo': objetivo,
      'sentadilla': sentadilla,
      'dominadas': dominadas,
      'nivel': nivel,
      'rango': rango,
      'xp_total': xpTotal,
      'puntos_semana': puntosSemana,
      'subscription_tier': subscriptionTier,
      'streak': streak,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class GymModel {
  final String id;
  final String nombre;
  final String ciudad;
  final String? codigoAdmin;
  final double? lat;
  final double? lng;

  const GymModel({
    required this.id,
    required this.nombre,
    required this.ciudad,
    this.codigoAdmin,
    this.lat,
    this.lng,
  });

  factory GymModel.fromJson(Map<String, dynamic> json) {
    return GymModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      ciudad: json['ciudad'] as String,
      codigoAdmin: json['codigo_admin'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }
}

class WorkoutModel {
  final String id;
  final String userId;
  final DateTime fecha;
  final int? duracion;
  final int puntosGenerados;
  final String? title;
  final bool isTemplate;

  const WorkoutModel({
    required this.id,
    required this.userId,
    required this.fecha,
    this.duracion,
    this.puntosGenerados = 0,
    this.title,
    this.isTemplate = false,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      duracion: json['duracion'] as int?,
      puntosGenerados: json['puntos_generados'] as int? ?? 0,
      title: json['title'] as String?,
      isTemplate: json['is_template'] as bool? ?? false,
    );
  }
}

class LeaderboardEntry {
  final String id;
  final String? gymId;
  final String? userId;
  final String semanaIso;
  final String categoria;
  final int puntos;
  final int? posicion;

  // Joined from user table
  final String? fullName;
  final String? avatarUrl;

  const LeaderboardEntry({
    required this.id,
    this.gymId,
    this.userId,
    required this.semanaIso,
    required this.categoria,
    this.puntos = 0,
    this.posicion,
    this.fullName,
    this.avatarUrl,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'] as String,
      gymId: json['gym_id'] as String?,
      userId: json['user_id'] as String?,
      semanaIso: json['semana_iso'] as String,
      categoria: json['categoria'] as String,
      puntos: json['puntos'] as int? ?? 0,
      posicion: json['posicion'] as int?,
      fullName: json['users']?['full_name'] as String?,
      avatarUrl: json['users']?['avatar_url'] as String?,
    );
  }
}
