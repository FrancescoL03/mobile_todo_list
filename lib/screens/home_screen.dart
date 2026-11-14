
import 'package:flutter/material.dart';

import '../models/attivita.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Elenco delle attività
  final List<Attivita> _attivita = [];

  // Numero di attività completate
  int get completate {
    return _attivita.where((a) => a.completata).length;
  }

  // Apertura della schermata di creazione
  Future<void> _aggiungiAttivita() async {
    final nuovaAttivita = await Navigator.push<Attivita>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTaskScreen(),
      ),
    );

    // Se l'utente torna indietro senza salvare
    if (!mounted || nuovaAttivita == null) {
      return;
    }

    // Aggiorniamo l'elenco
    setState(() {
      _attivita.add(nuovaAttivita);
    });

    // Messaggio temporaneo di conferma
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attività aggiunta con successo!'),
      ),
    );
  }

  // Cambia lo stato di un'attività
  void _cambiaStato(Attivita attivita) {
    setState(() {
      attivita.completata = !attivita.completata;
    });
  }

  // Eliminazione di un'attività con conferma
  Future<void> _eliminaAttivita(Attivita attivita) async {

    // Chiediamo conferma all'utente
    final conferma = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminare attività?'),
        content: Text(
          'Vuoi eliminare "${attivita.titolo}"?',
        ),
        actions: [

          // Annulla l'eliminazione
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Annulla'),
          ),

          // Conferma l'eliminazione
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    // Se l'utente annulla, non eliminiamo nulla
    if (!mounted || conferma != true) {
      return;
    }

    // Rimuoviamo l'attività
    setState(() {
      _attivita.remove(attivita);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le mie attività'),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // Conteggio delle attività
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Attività completate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$completate / ${_attivita.length}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),

          // Elenco oppure messaggio di lista vuota
          Expanded(
            child: _attivita.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Nessuna attività',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 8),
                        Text('Premi + per aggiungerne una'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _attivita.length,
                    itemBuilder: (context, index) {
                      final attivita = _attivita[index];

                      // Colore del bordo in base alla priorità
                      Color coloreBordo = Colors.green.shade400;

                      if (attivita.priorita == Priorita.alta) {
                        coloreBordo = Colors.red.shade400;
                      } else if (attivita.priorita == Priorita.media) {
                        coloreBordo = Colors.amber.shade600;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),

                        // Contorno colorato
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: coloreBordo,
                            width: 1.5,
                          ),
                        ),

                        child: ListTile(

                          // Checkbox per cambiare lo stato
                          leading: Checkbox(
                            value: attivita.completata,
                            onChanged: (valore) {
                              _cambiaStato(attivita);
                            },
                          ),

                          // Titolo dell'attività
                          title: Text(
                            attivita.titolo,
                            style: TextStyle(
                              decoration: attivita.completata
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),

                          // Stato, priorità e importanza
                          subtitle: Text(
                            'Stato: ${attivita.completata ? 'Completata' : 'Da fare'}\n'
                            'Priorità: ${attivita.priorita.name} - '
                            '${attivita.importante ? 'Importante' : 'Non importante'}',
                          ),

                          isThreeLine: true,

                          // Toccando la riga cambia lo stato
                          onTap: () {
                            _cambiaStato(attivita);
                          },

                          // Pulsante di eliminazione
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Elimina attività',
                            onPressed: () {
                              _eliminaAttivita(attivita);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Pulsante per aggiungere una nuova attività
      floatingActionButton: FloatingActionButton(
        onPressed: _aggiungiAttivita,
        tooltip: 'Aggiungi attività',
        child: const Icon(Icons.add),
      ),
    );
  }
}
