import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '', phone = '', date = '', time = '', guests = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réservation'),
        backgroundColor: Colors.orange.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Réservez votre table", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(labelText: 'Nom complet'),
                validator: (val) => val!.isEmpty ? 'Veuillez entrer votre nom' : null,
                onSaved: (val) => name = val!,
              ),
              SizedBox(height: 12),

              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Numéro de téléphone'),
                validator: (val) => val!.isEmpty ? 'Veuillez entrer votre téléphone' : null,
                onSaved: (val) => phone = val!,
              ),
              SizedBox(height: 12),

              TextFormField(
                decoration: InputDecoration(labelText: 'Date (ex: 2025-06-20)'),
                validator: (val) => val!.isEmpty ? 'Veuillez entrer une date' : null,
                onSaved: (val) => date = val!,
              ),
              SizedBox(height: 12),

              TextFormField(
                decoration: InputDecoration(labelText: 'Heure (ex: 19:30)'),
                validator: (val) => val!.isEmpty ? 'Veuillez entrer l\'heure' : null,
                onSaved: (val) => time = val!,
              ),
              SizedBox(height: 12),

              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Nombre de personnes'),
                validator: (val) => val!.isEmpty ? 'Veuillez entrer le nombre de personnes' : null,
                onSaved: (val) => guests = val!,
              ),

              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Réservation Confirmée'),
                        content: Text(
                          'Merci $name ! Votre table pour $guests personnes est réservée pour le $date à $time.\n\nNous vous appellerons au $phone si nécessaire.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Fermer'),
                          )
                        ],
                      ),
                    );
                  }
                },
                icon: Icon(Icons.send),
                label: Text("Envoyer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
