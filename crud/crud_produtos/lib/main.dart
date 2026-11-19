

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';
 
// Inicializa o Firebase antes de abrir o aplicativo

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );
 
  runApp(const MyApp());

}
 
// Aplicativo principal

class MyApp extends StatelessWidget {

  const MyApp({super.key});
 
  @override

  Widget build(BuildContext context) {

    return const MaterialApp(

      debugShowCheckedModeBanner: false,

      home: TelaProdutos(),

    );

  }

}
 
// Tela de produtos

class TelaProdutos extends StatefulWidget {

  const TelaProdutos({super.key});
 
  @override

  State<TelaProdutos> createState() => _TelaProdutosState();

}
 
class _TelaProdutosState extends State<TelaProdutos> {
 
  // Controladores dos campos

  final nomeController = TextEditingController();

  final precoController = TextEditingController();
 
  // Referência à coleção produtos do Firebase

  final produtos =

      FirebaseFirestore.instance.collection('produtos');
 
  // ID do produto que está sendo editado

  String? idEdicao;
 
  // CREATE e UPDATE

  Future<void> salvarProduto() async {
 
    String nome = nomeController.text.trim();

    String preco = precoController.text.trim();
 
    if (nome.isEmpty || preco.isEmpty) {

      return;

    }
 
    try {

      if (idEdicao == null) {
 
        // CREATE: adiciona um produto no Firebase

        await produtos.add({

          'nome': nome,

          'preco': preco,

        });
 
      } else {
 
        // UPDATE: atualiza o produto pelo ID

        await produtos.doc(idEdicao).update({

          'nome': nome,

          'preco': preco,

        });

      }
 
      if (!mounted) return;
 
      // Limpa os campos

      nomeController.clear();

      precoController.clear();
 
      setState(() {

        idEdicao = null;

      });
 
    } catch (erro) {

      if (!mounted) return;
 
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text('Erro ao salvar: $erro')),

      );

    }

  }
 
  // Carrega os dados para edição

  void editarProduto(

    String id,

    String nome,

    String preco,

  ) {
 
    setState(() {

      idEdicao = id;
 
      nomeController.text = nome;

      precoController.text = preco;

    });

  }
 
  // DELETE: exclui o produto do Firebase

  Future<void> excluirProduto(String id) async {
 
    try {

      await produtos.doc(id).delete();
 
      if (!mounted) return;
 
      if (idEdicao == id) {

        nomeController.clear();

        precoController.clear();
 
        setState(() {

          idEdicao = null;

        });

      }
 
    } catch (erro) {

      if (!mounted) return;
 
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text('Erro ao excluir: $erro')),

      );

    }

  }
 
  @override

  void dispose() {

    nomeController.dispose();

    precoController.dispose();

    super.dispose();

  }
 
  @override

  Widget build(BuildContext context) {
 
    return Scaffold(
 
      appBar: AppBar(

        title: const Text('Cadastro de Produtos'),

      ),
 
      body: Padding(

        padding: const EdgeInsets.all(16),
 
        child: Column(

          children: [
 
            // Campo nome

            TextField(

              controller: nomeController,

              decoration: const InputDecoration(

                labelText: 'Nome do produto',

              ),

            ),
 
            // Campo preço

            TextField(

              controller: precoController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(

                labelText: 'Preço',

              ),

            ),
 
            const SizedBox(height: 20),
 
            // Botão cadastrar ou atualizar

            ElevatedButton(

              onPressed: salvarProduto,
 
              child: Text(

                idEdicao == null

                    ? 'Cadastrar'

                    : 'Atualizar',

              ),

            ),
 
            const SizedBox(height: 20),
 
            // READ: listagem em tempo real do Firebase

            Expanded(

              child: StreamBuilder<QuerySnapshot>(
 
                // Observa alterações na coleção produtos

                stream: produtos.snapshots(),
 
                builder: (context, snapshot) {
 
                  // Enquanto os dados carregam

                  if (snapshot.connectionState ==

                      ConnectionState.waiting) {
 
                    return const Center(

                      child: CircularProgressIndicator(),

                    );

                  }
 
                  // Caso ocorra algum erro

                  if (snapshot.hasError) {

                    return const Center(

                      child: Text('Erro ao carregar produtos'),

                    );

                  }
 
                  // Lista de documentos do Firebase

                  final documentos =

                      snapshot.data?.docs ?? [];
 
                  if (documentos.isEmpty) {

                    return const Center(

                      child: Text('Nenhum produto cadastrado'),

                    );

                  }
 
                  return ListView.builder(
 
                    itemCount: documentos.length,
 
                    itemBuilder: (context, index) {
 
                      // Recupera o documento

                      final documento = documentos[index];
 
                      // Recupera os dados do produto

                      final dados = documento.data()

                          as Map<String, dynamic>;
 
                      String nome = dados['nome'] ?? '';

                      String preco = dados['preco'] ?? '';
 
                      return ListTile(
 
                        title: Text(nome),
 
                        subtitle: Text('R\$ $preco'),
 
                        trailing: Row(

                          mainAxisSize: MainAxisSize.min,

                          children: [
 
                            // Editar

                            IconButton(

                              icon: const Icon(Icons.edit),
 
                              onPressed: () {

                                editarProduto(

                                  documento.id,

                                  nome,

                                  preco,

                                );

                              },

                            ),
 
                            // Excluir

                            IconButton(

                              icon: const Icon(Icons.delete),
 
                              onPressed: () {

                                excluirProduto(documento.id);

                              },

                            ),
 
                          ],

                        ),

                      );

                    },

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

 