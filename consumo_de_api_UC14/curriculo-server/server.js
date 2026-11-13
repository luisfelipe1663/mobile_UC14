
 // Carrega as variáveis do arquivo .env
require('dotenv').config();

// Importa o Express
const express = require('express');

// Importa o CORS
const cors = require('cors');

// Importa a conexão com o banco MySQL
const pool = require('./db');

// Cria a aplicação Express
const app = express();

// Define a porta do servidor
const PORT = Number(process.env.PORT || 3000);

// Habilita o CORS
app.use(cors());

// Permite receber dados em JSON
app.use(express.json());


// Rota inicial para verificar se a API funciona
app.get('/', (req, res) => {

  res.json({
    mensagem: 'API de curriculos funcionando',
    endpoint: '/api/curriculos/1'
  });

});


// GET: consultar currículo pelo ID
// CORREÇÃO: curriculos no plural
app.get('/api/curriculos/:id', async (req, res) => {

  // Recupera o ID informado na URL
  // Number converte o texto para número
  const id = Number(req.params.id);

  // Verifica se o ID é um inteiro positivo
  if (!Number.isSafeInteger(id) || id <= 0) {

    return res.status(400).json({
      erro: 'ID deve ser um inteiro positivo'
    });

  }

  try {

  
    const [curriculos] = await pool.execute(
      `SELECT
        id,
        nome,
        email,
        telefone,
        cidade,
        profissao,
        objetivo,
        resumo
       FROM curriculos
       WHERE id = ?`,
      [id]
    );



    if (curriculos.length === 0) {

      return res.status(404).json({
        erro: 'Curriculo não encontrado.'
      });

    }


  
    const [experiencias] = await pool.execute(
      `SELECT
        id,
        empresa,
        cargo,
        periodo,
        atividades
       FROM experiencias
       WHERE curriculo_id = ?
       ORDER BY id`,
      [id]
    );



    const [formacoes] = await pool.execute(
      `SELECT
        id,
        escolaridade,
        curso,
        instituicao,
        conclusao
       FROM formacoes
       WHERE curriculo_id = ?
       ORDER BY id`,
      [id]
    );



    const [habilidades] = await pool.execute(
      `SELECT
        id,
        nome
       FROM habilidades
       WHERE curriculo_id = ?
       ORDER BY id`,
      [id]
    );


  
    const [idiomas] = await pool.execute(
      `SELECT *
       FROM idiomas
       WHERE curriculo_id = ?
       ORDER BY id`,
      [id]
    );


   
    return res.json({
      ...curriculos[0],
      experiencias,
      formacoes,
      habilidades,
      idiomas
    });


  } catch (erro) {

    // Exibe o erro no terminal do Node.js
    console.error('Erro ao consultar curriculo:', erro);

    // Retorna erro HTTP 500
    return res.status(500).json({
      erro: 'Erro interno ao consultar o curriculo'
    });

  }

});


// Trata rotas inexistentes
app.use((req, res) => {

  res.status(404).json({
    erro: 'Rota não encontrada'
  });

});


// Inicializa o servidor
app.listen(PORT, '0.0.0.0', () => {

  console.log(`API disponivel em http://localhost:${PORT}`);

});
