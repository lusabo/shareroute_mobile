import 'package:flutter/foundation.dart';

enum ParticipationMode {
  driver,
  passenger,
}

ParticipationMode? participationModeFromJson(dynamic value) {
  if (value is! String) {
    return null;
  }

  switch (value.toLowerCase()) {
    case 'motorista':
      return ParticipationMode.driver;
    case 'passageiro':
      return ParticipationMode.passenger;
    default:
      return null;
  }
}

String participationModeToJson(ParticipationMode mode) {
  switch (mode) {
    case ParticipationMode.driver:
      return 'motorista';
    case ParticipationMode.passenger:
      return 'passageiro';
  }
}

@immutable
class RidePreferences {
  const RidePreferences({
    required this.aceitaConversas,
    required this.aceitaMusica,
    required this.aceitaPets,
    required this.aceitaFumar,
    this.horarioPreferidoIda,
    this.horarioPreferidoVolta,
  });

  final bool aceitaConversas;
  final bool aceitaMusica;
  final bool aceitaPets;
  final bool aceitaFumar;
  final String? horarioPreferidoIda;
  final String? horarioPreferidoVolta;

  factory RidePreferences.fromJson(Map<String, dynamic> json) {
    return RidePreferences(
      aceitaConversas: json['aceitaConversas'] as bool? ?? false,
      aceitaMusica: json['aceitaMusica'] as bool? ?? false,
      aceitaPets: json['aceitaPets'] as bool? ?? false,
      aceitaFumar: json['aceitaFumar'] as bool? ?? false,
      horarioPreferidoIda: json['horarioPreferidoIda'] as String?,
      horarioPreferidoVolta: json['horarioPreferidoVolta'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aceitaConversas': aceitaConversas,
      'aceitaMusica': aceitaMusica,
      'aceitaPets': aceitaPets,
      'aceitaFumar': aceitaFumar,
      'horarioPreferidoIda': horarioPreferidoIda,
      'horarioPreferidoVolta': horarioPreferidoVolta,
    };
  }

  RidePreferences copyWith({
    bool? aceitaConversas,
    bool? aceitaMusica,
    bool? aceitaPets,
    bool? aceitaFumar,
    String? horarioPreferidoIda,
    String? horarioPreferidoVolta,
  }) {
    return RidePreferences(
      aceitaConversas: aceitaConversas ?? this.aceitaConversas,
      aceitaMusica: aceitaMusica ?? this.aceitaMusica,
      aceitaPets: aceitaPets ?? this.aceitaPets,
      aceitaFumar: aceitaFumar ?? this.aceitaFumar,
      horarioPreferidoIda: horarioPreferidoIda ?? this.horarioPreferidoIda,
      horarioPreferidoVolta: horarioPreferidoVolta ?? this.horarioPreferidoVolta,
    );
  }
}

@immutable
class UserProfile {
  const UserProfile({
    required this.nome,
    required this.departamento,
    required this.unidade,
    required this.preferenciasCarona,
    required this.formasUso,
  });

  final String nome;
  final String departamento;
  final String unidade;
  final RidePreferences preferenciasCarona;
  final List<ParticipationMode> formasUso;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final rawFormasUso = json['formasUso'];
    final parsedFormasUso = <ParticipationMode>[];
    if (rawFormasUso is List) {
      for (final value in rawFormasUso) {
        final mode = participationModeFromJson(value);
        if (mode != null) {
          parsedFormasUso.add(mode);
        }
      }
    }

    return UserProfile(
      nome: json['nome'] as String? ?? '',
      departamento: json['departamento'] as String? ?? '',
      unidade: json['unidade'] as String? ?? '',
      preferenciasCarona: RidePreferences.fromJson(
        json['preferenciasCarona'] as Map<String, dynamic>? ??
            const <String, dynamic>{},
      ),
      formasUso: parsedFormasUso,
    );
  }
}
