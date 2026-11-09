import 'package:flutter/material.dart';

import '../models/attivita.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  String _titolo = '';
  Priorita _priorita = Priorita.bassa;
  bool _mostraErrore = false;

  // Salvataggio della nuova attività
  void _salva() {
    final titoloPulito = _titolo.trim();

    // Controllo del titolo obbligatorio
    if (titoloPulito.isEmpty) {
      setState(() {
        _mostraErrore = true;
      });
      return;
    }

    // Creiamo una nuova attività
    final nuovaAttivita = Attivita(
      titolo: titoloPulito,
      priorita: _priorita,
    );

    // Torniamo alla Home restituendo l'attività
    Navigator.pop(context, nuovaAttivita);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova attività'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // Campo per il titolo
          TextField(
            textCapitalization: TextCapitalization.sentences,
            onChanged: (valore) {
              setState(() {
                _titolo = valore;

                // Nascondiamo l'errore quando il titolo è valido
                if (_titolo.trim().isNotEmpty) {
                  _mostraErrore = false;
                }
              });
            },
            decoration: InputDecoration(
              labelText: 'Titolo',
              hintText: 'Es. Studiare Flutter',
              border: const OutlineInputBorder(),
              errorText: _mostraErrore
                  ? 'Il titolo è obbligatorio'
                  : null,
            ),
          ),

          const SizedBox(height: 24),

          // Scelta della priorità
          const Text(
            'Priorità',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          DropdownButton<Priorita>(
            value: _priorita,
            isExpanded: true,
            items: const [
              DropdownMenuItem(
                value: Priorita.bassa,
                child: Text('Bassa'),
              ),
              DropdownMenuItem(
                value: Priorita.media,
                child: Text('Media'),
              ),
              DropdownMenuItem(
                value: Priorita.alta,
                child: Text('Alta'),
              ),
            ],
            onChanged: (valore) {
              if (valore != null) {
                setState(() {
                  _priorita = valore;
                });
              }
            },
          ),

          const Text(
            'Le attività con priorità alta sono importanti.',
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 30),

          // Pulsante di salvataggio
          ElevatedButton(
            onPressed: _salva,
            child: const Text('Salva attività'),
          ),
        ],
      ),
    );
  }
}