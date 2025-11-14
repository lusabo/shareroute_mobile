import 'package:flutter/material.dart';

class RideRequest {
  RideRequest({
    required this.passengerName,
    required this.time,
    required this.origin,
    required this.destination,
    required this.photoUrl,
    required this.notes,
  });

  final String passengerName;
  final String time;
  final String origin;
  final String destination;
  final String photoUrl;
  final String notes;
}

class RideRoute {
  RideRoute({
    required this.id,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.returnTime,
    required this.days,
    required this.spots,
  });

  final String id;
  final String origin;
  final String destination;
  final String departureTime;
  final String returnTime;
  final List<String> days;
  final int spots;
}

class DriverProfilePreview {
  DriverProfilePreview({
    required this.name,
    required this.rating,
    required this.completedRides,
    required this.photoUrl,
    required this.car,
    required this.departure,
    required this.arrival,
    required this.distance,
    required this.tags,
  });

  final String name;
  final double rating;
  final int completedRides;
  final String photoUrl;
  final String car;
  final String departure;
  final String arrival;
  final double distance;
  final List<String> tags;
}

final mockRequests = [
  RideRequest(
    passengerName: 'Mariana Souza',
    time: '07:20',
    origin: 'Vila Mariana',
    destination: 'Escritório HQ',
    photoUrl: 'https://i.pravatar.cc/100?img=1',
    notes: 'Prefere silêncio nas manhãs.',
  ),
  RideRequest(
    passengerName: 'Felipe Rocha',
    time: '07:45',
    origin: 'Pinheiros',
    destination: 'Escritório HQ',
    photoUrl: 'https://i.pravatar.cc/100?img=5',
    notes: 'Aceita dividir pedágio.',
  ),
  RideRequest(
    passengerName: 'Larissa Melo',
    time: '08:00',
    origin: 'Mooca',
    destination: 'Escritório HQ',
    photoUrl: 'https://i.pravatar.cc/100?img=12',
    notes: 'Leva café para compartilhar.',
  ),
];

final mockRoutes = [
  RideRoute(
    id: 'R1',
    origin: 'Vila Mariana',
    destination: 'Escritório HQ',
    departureTime: '07:15',
    returnTime: '18:10',
    days: const ['Seg', 'Ter', 'Qua', 'Qui'],
    spots: 3,
  ),
  RideRoute(
    id: 'R2',
    origin: 'Brooklin',
    destination: 'Campus Tech',
    departureTime: '08:00',
    returnTime: '17:30',
    days: const ['Seg', 'Qua', 'Sex'],
    spots: 2,
  ),
];

final mockDrivers = [
  DriverProfilePreview(
    name: 'Ana Martins',
    rating: 4.9,
    completedRides: 132,
    photoUrl: 'https://i.pravatar.cc/100?img=15',
    car: 'Toyota Corolla Híbrido • Azul',
    departure: 'Saída às 07:20 - Vila Olímpia',
    arrival: 'Chegada 08:05 - Escritório HQ',
    distance: 2.1,
    tags: const ['Híbrido', 'Silêncio', 'Flexível'],
  ),
  DriverProfilePreview(
    name: 'Carlos Lima',
    rating: 4.7,
    completedRides: 96,
    photoUrl: 'https://i.pravatar.cc/100?img=18',
    car: 'Chevrolet Bolt EV • Branco',
    departure: 'Saída às 07:40 - Moema',
    arrival: 'Chegada 08:15 - Escritório HQ',
    distance: 3.4,
    tags: const ['Elétrico', 'Conversa', 'Café'],
  ),
  DriverProfilePreview(
    name: 'Juliana Prado',
    rating: 5.0,
    completedRides: 210,
    photoUrl: 'https://i.pravatar.cc/100?img=31',
    car: 'Honda HR-V • Verde',
    departure: 'Saída às 07:10 - Alto da Lapa',
    arrival: 'Chegada 08:00 - Escritório HQ',
    distance: 4.2,
    tags: const ['Preferência música', 'Pontual', 'Sem pets'],
  ),
];

final mockPerks = [
  'Vouchers de combustível',
  'Créditos em mobilidade urbana',
  'Vaga preferencial no estacionamento',
  'Recompensas em marketplace parceiro',
];

final mockBonuses = [
  'Créditos em restaurante corporativo',
  'Cashback mensal',
  'Dias de home office extra',
  'Pontos no clube de benefícios',
];

const sustainabilityHighlights = [
  'Menos emissões de CO₂ por colaborador',
  'Compartilhamento inteligente reduz congestionamento',
  'Incentivos ESG para equipes alinhadas às metas da empresa',
];

const safetyHighlights = [
  'Perfis verificados e avaliações após cada carona',
  'Cobertura corporativa e suporte 24/7',
  'Roteiro monitorado e histórico de viagens',
];