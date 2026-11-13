// import 'package:flutter/material.dart';
// import 'curriculo_api.dart';
// import 'curriculo.dart';
// void main(){
//   runApp(const MyApp());
// }
// class MyApp extends StatefulWidget{
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }
// class _MyAppState extends State<MyApp>{

//   final api = CurriculoApi('http://10.0.2.2:3000');

//   String nome = '';
//   String email = '';
//   String telefone = '';

//   @override
//   void initState(){
//     super.initState();
//     carregarCurriculo();
//   }

//   Future<void> carregarCurriculo() async{
//     try{
//       final dados = await api.buscarCurriculo(1);
//       if(!mounted) return;

//       setState(() {
//         nome = dados['nome']?.toString() ?? '';
//         email = dados['email']?.toString() ?? '';
//        telefone = dados['telefone']?.toString() ?? '';
//       });
//     }catch(erro){
//       debugPrint('Erro:$erro');
//     }
//   } 

//   @override
// Widget build(BuildContext context){
//   return MaterialApp(
//     home: Scaffold(
//       body: Column(
//         children: [
//           Text('Nome:$nome'),
//            Text('Email:$email'),
//             Text('Telefone:$telefone'),
//         ],
//       ),
//     ),

     
//   );
// }

import 'package:flutter/material.dart';
import 'curriculo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurriloScreen(),
    );
  }
}