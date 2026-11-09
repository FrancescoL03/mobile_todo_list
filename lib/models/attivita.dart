enum Priorita {
  bassa,
  media,
  alta
}

class Attivita {
  final String titolo;
  final Priorita priorita;
  bool completata;

  Attivita({
    required this.titolo,
    this.priorita = Priorita.bassa,
    this.completata = false,
  });

  bool get importante => priorita == Priorita.alta;
}