
import 'package:flutter/material.dart';
import 'curriculo_api.dart';

class CurriloScreen extends StatefulWidget {
  const CurriloScreen({super.key});

  @override
  State<CurriloScreen> createState() {
    return _CurriloScreenState();
  }
}

class _CurriloScreenState extends State<CurriloScreen> {

  // CONEXÃO COM A API
  final api = CurriculoApi('http://10.0.2.2:3000');

  // VARIÁVEIS DO CURRÍCULO
  String nome = '';
  String email = '';
  String telefone = '';
  String cidade = '';
  String profissao = '';
  String objetivo = '';
  String resumo = '';

  bool carregando = true;
  String erro = '';

  // INICIALIZAÇÃO DA TELA
  @override
  void initState() {
    super.initState();
    carregarCurriculo();
  }

  // FUNÇÃO PARA CARREGAR OS DADOS DA API
  Future<void> carregarCurriculo() async {
    try {
      final dados = await api.buscarCurriculo(1);

      if (!mounted) return;

      setState(() {
        nome = dados['nome']?.toString() ?? '';
        email = dados['email']?.toString() ?? '';
        telefone = dados['telefone']?.toString() ?? '';
        cidade = dados['cidade']?.toString() ?? '';
        profissao = dados['profissao']?.toString() ?? '';
        objetivo = dados['objetivo']?.toString() ?? '';
        resumo = dados['resumo']?.toString() ?? '';

        carregando = false;
      });

    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = 'Não foi possível carregar o currículo.';
        carregando = false;
      });

      debugPrint('Erro ao carregar currículo: $e');
    }
  }

  // FUNÇÃO PARA CRIAR AS HABILIDADES
  Widget habilidade(String nome) {
    return Chip(
      label: Text(nome),
      backgroundColor: Colors.white,
      side: const BorderSide(
        color: Color(0xFFD0D7DE),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : erro.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(erro),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            carregando = true;
                            erro = '';
                          });

                          carregarCurriculo();
                        },
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )

              : SingleChildScrollView(

                  child: Column(
                    children: [

                      // PRIMEIRO CONTAINER - CABEÇALHO

                      Container(
                        width: double.infinity,
                        color: const Color(0xFF173451),
                        padding: const EdgeInsets.all(25),

                        child: Column(
                          children: [

                            const SizedBox(height: 20),

                            const Text(
                              'Meu Curriculo',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Color(0xFF173451),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              nome,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              profissao,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              cidade,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              telefone,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                          ],
                        ),
                      ),

                      // SEGUNDO CONTAINER

                      Transform.translate(
                        offset: const Offset(0, 0),

                        child: Container(
                          width: double.infinity,

                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F3F7),

                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                          ),

                          padding: const EdgeInsets.all(20),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              // SOBRE MIM

                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    color: Colors.blue,
                                    size: 30,
                                  ),

                                  const SizedBox(width: 10),

                                  const Text(
                                    'Sobre mim',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF173451),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              Text(
                                resumo,
                              ),

                              const SizedBox(height: 15),

                              const Text(
                                'Objetivo profissional',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF173451),
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(objetivo),

                              const SizedBox(height: 25),

                              // EXPERIÊNCIA PROFISSIONAL

                              Row(
                                children: [
                                  const Icon(
                                    Icons.work_outline,
                                    color: Colors.blue,
                                    size: 30,
                                  ),

                                  const SizedBox(width: 10),

                                  const Expanded(
                                    child: Text(
                                      'Experiência Profissional',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF173451),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              const Text(
                                'Desenvolvedor Mobile',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 3),

                              const Text(
                                'Tech Solutions | 2023 - Atual',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                'Desenvolvimento de interfaces e aplicativos utilizando Flutter e linguagem Dart.',
                              ),

                              const SizedBox(height: 25),

                              // FORMAÇÃO ACADÊMICA

                              Row(
                                children: [
                                  const Icon(
                                    Icons.school_outlined,
                                    color: Colors.blue,
                                    size: 30,
                                  ),

                                  const SizedBox(width: 10),

                                  const Expanded(
                                    child: Text(
                                      'Formação Acadêmica',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF173451),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                'Análise e Desenvolvimento de Sistemas',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const Text(
                                'Faculdade de Tecnologia | 2022 - 2024',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 25),

                              // HABILIDADES

                              Row(
                                children: [
                                  const Icon(
                                    Icons.code,
                                    color: Colors.blue,
                                    size: 30,
                                  ),

                                  const SizedBox(width: 10),

                                  const Expanded(
                                    child: Text(
                                      'Habilidades',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF173451),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Wrap(
                                spacing: 8,
                                runSpacing: 12,

                                children: [
                                  habilidade('Flutter'),
                                  habilidade('Dart'),
                                  habilidade('Python'),
                                  habilidade('HTML'),
                                  habilidade('CSS'),
                                  habilidade('Git'),
                                ],
                              ),

                              const SizedBox(height: 25),

                              // IDIOMAS

                              Row(
                                children: [
                                  const Icon(
                                    Icons.language,
                                    color: Colors.blue,
                                    size: 30,
                                  ),

                                  const SizedBox(width: 10),

                                  const Expanded(
                                    child: Text(
                                      'Idiomas',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF173451),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                'Português - Nativo',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                              const Text(
                                'Inglês - intermediário',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
    );
  }
}
