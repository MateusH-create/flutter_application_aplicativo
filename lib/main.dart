import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: FormularioExemplo()));

class Pet {
  final String nome;
  final String especie;
  final int idade;
  final bool eCastrado;

  Pet({
    required this.nome,
    required this.especie,
    required this.idade,
    required this.eCastrado,
  });
}

class FormularioExemplo extends StatefulWidget {
  const FormularioExemplo({super.key});

  @override
  State<FormularioExemplo> createState() => _FormularioExemploState();
}

class _FormularioExemploState extends State<FormularioExemplo> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();
  String? _especie;
  bool _castrado = false;
  final List<Pet> _petsCadastrados = [];

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    super.dispose();
  }

  void _limparFormulario() {
    _formKey.currentState!.reset();
    _nomeController.clear();
    _idadeController.clear();
    setState(() {
      _especie = null;
      _castrado = false;
    });
  }

  void _adicionarPet() {
    if (_formKey.currentState!.validate()) {
      final pet = Pet(
        nome: _nomeController.text.trim(),
        especie: _especie!,
        idade: int.parse(_idadeController.text),
        eCastrado: _castrado,
      );

      setState(() => _petsCadastrados.add(pet));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pet ${pet.nome} (${pet.especie}, ${pet.idade} anos) cadastrado!',
          ),
        ),
      );

      _limparFormulario();
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Cadastro do Pet')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Pet',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o nome do pet!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _especie,
                  decoration: const InputDecoration(
                    labelText: 'Espécie',
                    border: OutlineInputBorder(),
                  ),
                  items: const ['Cão', 'Gato', 'Outro']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => setState(() => _especie = value),
                  validator: (value) =>
                      value == null ? 'Selecione a espécie!' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _idadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Idade em Anos',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final idade = int.tryParse(value ?? '');
                    if (idade == null || idade <= 0) {
                      return 'A idade deve ser maior que 0!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Termo de Castração (já é castrado?)'),
                  value: _castrado,
                  onChanged: (value) =>
                      setState(() => _castrado = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _adicionarPet,
                  child: const Text('Cadastrar Pet'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Pets cadastrados',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _petsCadastrados.length,
              itemBuilder: (context, index) {
                final pet = _petsCadastrados[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(pet.especie[0]),
                    ),
                    title: Text(pet.nome),
                    subtitle: Text('${pet.especie} • ${pet.idade} ano(s)'),
                    trailing: Icon(
                      pet.eCastrado ? Icons.check_circle : Icons.cancel,
                      color: pet.eCastrado ? Colors.green : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}