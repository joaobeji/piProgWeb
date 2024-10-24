const express = require("express");
const bodyParser = require("body-parser");
const path = require("path");
const bcrypt = require("bcrypt");
const session = require("express-session");
const nodemailer = require("nodemailer");
const crypto = require("crypto");
const db = require("./db");

const app = express();
const PORT = process.env.PORT || 3000; // Porta fornecida pelo host ou 3000
const HOST = "0.0.0.0"; // Aceitar conexões de qualquer lugar

// Configuração do express-session
app.use(
  session({
    secret: process.env.SECRET_KEY, // Use uma string segura para a chave secreta
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false }, // `secure: true` se for usar HTTPS em produção
  })
);

// Configuração do motor de visualização EJS
app.set("view engine", "ejs");
app.set("views", [
  path.join(__dirname, "views"), // diretório padrão
  path.join(__dirname, "views/page-menu"), // primeiro diretório adicional
  path.join(__dirname, "views/ultimas-receitas"), // primeiro diretório adicional
]);
app.use("/img", express.static(path.join(__dirname, "/img")));

// Rota principal para renderizar os cards
app.get("/", (req, res) => {
  const query = `
    SELECT c.id, c.titulo, c.descricao, c.categoria, c.imagem_url, c.tempo_preparo, c.rendimento,
           GROUP_CONCAT(DISTINCT mp.descricao ORDER BY mp.passo_numero ASC SEPARATOR '|') AS passos,
           GROUP_CONCAT(DISTINCT CONCAT(i.descricao, '|', i.quantidade, '|', i.unidade) ORDER BY i.id ASC SEPARATOR '||') AS ingredientes
    FROM comidas c
    LEFT JOIN modos_preparo mp ON c.id = mp.comida_id
    LEFT JOIN ingredientes i ON c.id = i.comida_id
    GROUP BY c.id LIMIT 15;
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error("Erro ao buscar as receitas:", err);
      res.status(500).send("Erro ao buscar as receitas");
      return;
    }

    // Adiciona os ingredientes separados em cada receita
    results.forEach((comida) => {
      comida.listaIngredientes = comida.ingredientes
        ? comida.ingredientes.split("||")
        : [];
    });

    res.render("index", { comidas: results });
  });
});

app.get("/dashboard", (req, res) => {
  // Verifique se o usuário está autenticado
  if (req.session.user) {
    // Query para obter as últimas 10 comidas do usuário
    const query = `
      SELECT id, titulo, descricao, imagem_url
      FROM comidas
      WHERE usuario_id = ?
      ORDER BY id DESC
      LIMIT 10
    `;

    db.query(query, [req.session.user.id], (err, comidas) => {
      if (err) {
        console.error("Erro ao buscar comidas:", err);
        return res.status(500).send("Erro ao buscar comidas");
      }

      res.render("dashboard", { user: req.session.user, comidas });
    });
  } else {
    res.redirect("/");
  }
});

app.get("/ultimas-receitas/receita/:id", (req, res) => {
  const comidaId = req.params.id;

  const query = `
    SELECT c.id, c.titulo, c.descricao, c.categoria, c.imagem_url, c.tempo_preparo, c.rendimento,
           GROUP_CONCAT(DISTINCT i.descricao ORDER BY i.id ASC SEPARATOR '||') AS ingredientes,
           GROUP_CONCAT(DISTINCT mp.descricao ORDER BY mp.passo_numero ASC SEPARATOR '|') AS modos_preparo
    FROM comidas c
    LEFT JOIN ingredientes i ON c.id = i.comida_id
    LEFT JOIN modos_preparo mp ON c.id = mp.comida_id
    WHERE c.id = ?
    GROUP BY c.id;
  `;

  db.query(query, [comidaId], (err, results) => {
    if (err) {
      console.error("Erro ao buscar comida:", err);
      return res.status(500).send("Erro ao buscar comida");
    }

    if (results.length === 0) {
      return res.status(404).send("Comida não encontrada");
    }

    const comida = results[0];
    comida.listaIngredientes = comida.ingredientes
      ? comida.ingredientes.split("||")
      : [];
    comida.listaModosPreparo = comida.modos_preparo
      ? comida.modos_preparo.split("|")
      : [];

    res.render("comidaDetalhes", { comida, user: req.session.user });
  });
});

// Rota para renderizar páginas de categorias do menu
app.get("/page-menu/:page", (req, res) => {
  const page = req.params.page;
  const categoriaMap = {
    comida_caseira: "Comida Caseira",
    lanches: "Lanches",
    doces: "Doces",
    bolos_e_tortas: "Bolos e Tortas",
    massas: "Massas",
    bebidas: "Bebidas",
  };

  const categoria = categoriaMap[page];
  if (!categoria) {
    return res.status(404).send("Página não encontrada");
  }

  const query = `
    SELECT c.id, c.titulo, c.descricao, c.categoria, c.imagem_url, c.tempo_preparo, c.rendimento,
           GROUP_CONCAT(DISTINCT mp.descricao ORDER BY mp.passo_numero ASC SEPARATOR '|') AS passos,
           GROUP_CONCAT(DISTINCT CONCAT(i.descricao, '|', i.quantidade, '|', i.unidade) ORDER BY i.id ASC SEPARATOR '||') AS ingredientes
    FROM comidas c
    LEFT JOIN modos_preparo mp ON c.id = mp.comida_id
    LEFT JOIN ingredientes i ON c.id = i.comida_id
    WHERE c.categoria = ?
    GROUP BY c.id;
  `;

  db.query(query, [categoria], (err, results) => {
    if (err) {
      console.error("Erro ao buscar comidas:", err);
      return res.status(500).send("Erro no servidor");
    }

    // Adiciona os ingredientes separados em cada receita
    results.forEach((comida) => {
      comida.listaIngredientes = comida.ingredientes
        ? comida.ingredientes.split("||")
        : [];
    });

    res.render(`page-menu/${page}`, {
      pageTitle: categoria,
      comidas: results,
    });
  });
});

// Middleware para processar os dados do formulário
app.use(bodyParser.urlencoded({ extended: true }));

// Rota para exibir o formulário de cadastro de receitas
app.get("/cadastrar", (req, res) => {
  res.render("cadastrar"); // renderiza a página cadastrar.ejs
});

// Rota para processar o cadastro de receitas
app.post("/cadastrar", (req, res) => {
  const {
    titulo,
    descricao,
    categoria,
    imagem_url,
    tempo_preparo,
    rendimento,
  } = req.body;

  // Verifique se o usuário está autenticado
  const usuarioId = req.session.user ? req.session.user.id : null;

  const query = `
    INSERT INTO comidas (titulo, descricao, categoria, imagem_url, tempo_preparo, rendimento, usuario_id)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(
    query,
    [
      titulo,
      descricao,
      categoria,
      imagem_url,
      tempo_preparo,
      rendimento,
      usuarioId,
    ],
    (err) => {
      if (err) {
        console.error("Erro ao cadastrar a receita:", err);
        res.status(500).send("Erro ao cadastrar a receita");
        return;
      }
      res.redirect("/listar-receitas");
    }
  );
});

// Rota para exibir o formulário de cadastro de ingredientes
app.get("/cadastrar-ingrediente", (req, res) => {
  // Verifique se o usuário está autenticado
  const usuarioId = req.session.user ? req.session.user.id : null;

  if (!usuarioId) {
    // Se o usuário não estiver autenticado, redirecione ou envie uma mensagem de erro
    return res
      .status(403)
      .send(
        "Acesso negado. Você precisa estar logado para cadastrar ingredientes."
      );
  }

  const query = "SELECT id, titulo FROM comidas WHERE usuario_id = ?";
  db.query(query, [usuarioId], (err, results) => {
    if (err) {
      console.error("Erro ao buscar as receitas:", err);
      res.status(500).send("Erro ao buscar as receitas");
      return;
    }
    res.render("cadastrar_ingrediente", { comidas: results });
  });
});

// Rota para processar o cadastro de múltiplos ingredientes
app.post("/cadastrar-ingrediente", (req, res) => {
  const { comida_id, descricao, quantidade, unidade } = req.body;

  // Verifique se o usuário está autenticado e obtenha o usuario_id
  const usuarioId = req.session.user ? req.session.user.id : null;

  // Se não há dados válidos, retorna erro
  if (!descricao || !quantidade || !unidade || !comida_id || !usuarioId) {
    res.status(400).send("Dados inválidos");
    return;
  }

  const query = `
    INSERT INTO ingredientes (comida_id, descricao, quantidade, unidade, usuario_id)
    VALUES ?
  `;

  // Criando uma matriz de valores para enviar para a consulta
  const values = descricao.map((desc, index) => [
    comida_id,
    desc,
    quantidade[index],
    unidade[index],
    usuarioId, // Adicionando o usuario_id
  ]);

  // Usando bulk insert para inserir todos os ingredientes de uma só vez
  db.query(query, [values], (err) => {
    if (err) {
      console.error("Erro ao cadastrar o ingrediente:", err);
      res.status(500).send("Erro ao cadastrar o ingrediente");
      return;
    }
    res.redirect("/listar-ingredientes"); // Redireciona após o cadastro
  });
});

// Rota para exibir o formulário de cadastro de modos de preparo
app.get("/cadastrar-modo-preparo", (req, res) => {
  // Verifique se o usuário está autenticado
  const usuarioId = req.session.user ? req.session.user.id : null;

  if (!usuarioId) {
    // Se o usuário não estiver autenticado, redirecione ou envie uma mensagem de erro
    return res
      .status(403)
      .send(
        "Acesso negado. Você precisa estar logado para cadastrar modos de preparo."
      );
  }

  const query = "SELECT id, titulo FROM comidas WHERE usuario_id = ?";
  db.query(query, [usuarioId], (err, results) => {
    if (err) {
      console.error("Erro ao buscar as receitas:", err);
      res.status(500).send("Erro ao buscar as receitas");
      return;
    }
    res.render("cadastrar_modo_preparo", { comidas: results });
  });
});

// Rota para processar o cadastro de modos de preparo
app.post("/cadastrar-modo-preparo", (req, res) => {
  const { comida_id, descricao, passo_numero } = req.body;

  // Verifique se o usuário está autenticado e obtenha o usuario_id
  const usuarioId = req.session.user ? req.session.user.id : null;

  // Se não há dados válidos, retorna erro
  if (!descricao || !passo_numero || !comida_id || !usuarioId) {
    res.status(400).send("Dados inválidos");
    return;
  }

  const query = `
    INSERT INTO modos_preparo (comida_id, descricao, passo_numero, usuario_id)
    VALUES ?
  `;

  // Criando uma matriz de valores para enviar para a consulta
  const values = descricao.map((desc, index) => [
    comida_id,
    desc,
    passo_numero[index],
    usuarioId, // Adicionando o usuario_id
  ]);

  // Usando bulk insert para inserir todos os modos de preparo de uma só vez
  db.query(query, [values], (err) => {
    if (err) {
      console.error("Erro ao cadastrar o modo de preparo:", err);
      res.status(500).send("Erro ao cadastrar o modo de preparo");
      return;
    }
    res.redirect("/listar-modos-preparo"); // Redireciona após o cadastro
  });
});

// Rota para listar todas as receitas
app.get("/listar-receitas", (req, res) => {
  // Verifique se o usuário está autenticado
  const usuarioId = req.session.user ? req.session.user.id : null;

  const query = `
    SELECT c.id, c.titulo, c.descricao, c.categoria, c.imagem_url, c.tempo_preparo, c.rendimento,
           GROUP_CONCAT(mp.descricao ORDER BY mp.passo_numero ASC SEPARATOR '|') AS passos
    FROM comidas c
    LEFT JOIN modos_preparo mp ON c.id = mp.comida_id
    WHERE c.usuario_id = ?
    GROUP BY c.id;
  `;

  db.query(query, [usuarioId], (err, results) => {
    if (err) {
      console.error("Erro ao buscar as receitas:", err);
      res.status(500).send("Erro ao buscar as receitas");
      return;
    }
    res.render("listar_receitas", { comidas: results });
  });
});

// Rota para listar todos os ingredientes
app.get("/listar-ingredientes", (req, res) => {
  // Verifique se o usuário está autenticado
  const usuarioId = req.session.user ? req.session.user.id : null;

  // Query para buscar os ingredientes relacionados ao usuário logado
  const query = `
    SELECT * FROM ingredientes
    WHERE usuario_id = ?;
  `;

  db.query(query, [usuarioId], (err, results) => {
    if (err) {
      console.error("Erro ao buscar os ingredientes:", err);
      res.status(500).send("Erro ao buscar os ingredientes");
      return;
    }
    res.render("listar_ingredientes", { ingredientes: results });
  });
});

// Rota para listar todos os modos de preparo
app.get("/listar-modos-preparo", (req, res) => {
  // Verifique se o usuário está autenticado
  const usuarioId = req.session.user ? req.session.user.id : null;

  // Query para buscar os modos de preparo relacionados ao usuário logado
  const query = `
    SELECT * FROM modos_preparo
    WHERE usuario_id = ?;
  `;

  db.query(query, [usuarioId], (err, results) => {
    if (err) {
      console.error("Erro ao buscar os modos de preparo:", err);
      res.status(500).send("Erro ao buscar os modos de preparo");
      return;
    }
    res.render("listar_modos_preparo", { modosPreparo: results });
  });
});

/* ROTAS DE USUÁRIOS */

// Rota de Cadastrar
app.post("/cadastro", (req, res) => {
  const { nome, email, senha, confirmarSenha } = req.body;

  // Verifica se a senha e a confirmação de senha são iguais
  if (senha !== confirmarSenha) {
    return res.status(400).send("As senhas não coincidem");
  }

  db.query(
    "SELECT * FROM usuarios WHERE email = ?",
    [email],
    (err, results) => {
      if (err) {
        return res.status(500).send("Erro ao verificar usuário");
      }

      if (results.length > 0) {
        return res.status(400).send("Usuário já cadastrado");
      }

      // Criptografa a senha antes de salvar no banco de dados
      bcrypt.hash(senha, 10, (err, hashedPassword) => {
        if (err) {
          return res.status(500).send("Erro ao criptografar a senha");
        }

        db.query(
          "INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)",
          [nome, email, hashedPassword],
          (err, results) => {
            if (err) {
              return res.status(500).send("Erro ao cadastrar");
            }

            // Redireciona após 5 segundos
            res.send(`
              <html>
                <head>
                  <meta http-equiv="refresh" content="5; url=/" />
                </head>
                <body>
                  <h1>Cadastro realizado com sucesso!</h1>
                  <p>Você será redirecionado para a página principal em 5 segundos.</p>
                </body>
              </html>
            `);
          }
        );
      });
    }
  );
});

// Rota de Login
app.post("/login", (req, res) => {
  const { email, senha } = req.body;

  db.query(
    "SELECT * FROM usuarios WHERE email = ?",
    [email],
    (err, results) => {
      if (err) {
        return res.status(500).send("Erro no servidor");
      }

      if (results.length === 0) {
        return res.status(400).send("Usuário não encontrado");
      }

      const user = results[0];

      bcrypt.compare(senha, user.senha, (err, match) => {
        if (err) {
          return res.status(500).send("Erro ao verificar senha");
        }

        if (!match) {
          return res.status(400).send("Senha incorreta");
        }

        // Aqui, armazene o nome do usuário na sessão
        req.session.user = {
          id: user.id,
          nome: user.nome, // Certifique-se de que o campo nome existe na tabela
          email: user.email,
        };

        res.redirect("/dashboard");
      });
    }
  );
});

// Rota para recuperação de senha
app.post("/recuperar-senha", (req, res) => {
  const { email } = req.body;

  // Verifica se o e-mail está cadastrado
  db.query(
    "SELECT * FROM usuarios WHERE email = ?",
    [email],
    (err, results) => {
      if (err) {
        return res.status(500).send("Erro ao verificar e-mail");
      }

      if (results.length === 0) {
        return res.status(400).send("E-mail não cadastrado");
      }

      // Gera um token de recuperação de senha
      const token = crypto.randomBytes(20).toString("hex");
      const expiracaoToken = new Date(Date.now() + 3600000); // 1 hora para expirar

      // Salva o token no banco de dados
      db.query(
        "UPDATE usuarios SET reset_token = ?, reset_token_expira = ? WHERE email = ?",
        [token, expiracaoToken, email],
        (err) => {
          if (err) {
            console.log("Erro ao salvar token de recuperação");
            return res.status(500).send("Erro ao salvar token de recuperação");
          }

          // Configuração do transporte do e-mail
          const transporter = nodemailer.createTransport({
            service: "Gmail",
            auth: {
              user: "Joaobejieduardo@gmail.com",
              pass: "vroprwbblrkumpsr",
            },
          });

          // Configuração do e-mail
          const mailOptions = {
            to: email,
            from: "Joaobejieduardo@gmail.com", // Troque por um e-mail válido
            subject: "Recuperação de senha",
            html: `
                      <p>Você está recebendo este e-mail porque solicitou a recuperação de senha. Clique no link a seguir para redefinir sua senha:</p>
                      <p><a href="http://localhost:3000/redefinir-senha/${token}">Redefinir Senha</a></p>
                      <p>Caso não tenha solicitado isso, por favor, ignore este e-mail.</p>
                  `,
          };

          // Envia o e-mail
          transporter.sendMail(mailOptions, (err) => {
            if (err) {
              return res
                .status(500)
                .send("Erro ao enviar e-mail de recuperação");
            }
            res.send(
              "Um e-mail foi enviado com as instruções para redefinir a senha"
            );
          });
        }
      );
    }
  );
});

// Rota para exibir o formulário de redefinição de senha
app.get("/redefinir-senha/:token", (req, res) => {
  const token = req.params.token;

  // Verifica se o token é válido
  db.query(
    "SELECT * FROM usuarios WHERE reset_token = ? AND reset_token_expira > ?",
    [token, new Date()],
    (err, results) => {
      if (err) {
        return res.status(500).send("Erro ao verificar token");
      }

      if (results.length === 0) {
        return res.status(400).send("Token inválido ou expirado");
      }

      // Renderize um formulário de redefinição de senha em um modal
      res.send(`
        <!DOCTYPE html>
        <html lang="pt-BR">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
            <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
            <title>Redefinição de Senha</title>
        </head>
        <body>
            <!-- Modal -->
            <div class="modal fade show" id="resetPasswordModal" tabindex="-1" role="dialog" style="display: block;">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Redefinir Senha</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <form action="/atualizar-senha" method="POST">
                                <input type="hidden" name="token" value="${token}">
                                <div class="form-group">
                                    <label for="novaSenha">Nova Senha:</label>
                                    <input type="password" class="form-control" name="novaSenha" required>
                                </div>
                                <button type="submit" class="btn btn-primary">Redefinir Senha</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.0.7/dist/umd/popper.min.js"></script>
            <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        </body>
        </html>
      `);
    }
  );
});

// Rota para atualizar a senha
app.post("/atualizar-senha", (req, res) => {
  const { token, novaSenha } = req.body;

  // Verifica se o token é válido
  db.query(
    "SELECT * FROM usuarios WHERE reset_token = ? AND reset_token_expira > ?",
    [token, new Date()],
    (err, results) => {
      if (err) {
        return res.status(500).send("Erro ao verificar token");
      }

      if (results.length === 0) {
        return res.status(400).send("Token inválido ou expirado");
      }

      // Hash a nova senha
      const hashedPassword = bcrypt.hashSync(novaSenha, 10); // Use um salt adequado

      // Atualiza a senha no banco de dados e limpa o token
      db.query(
        "UPDATE usuarios SET senha = ?, reset_token = NULL, reset_token_expira = NULL WHERE reset_token = ?",
        [hashedPassword, token],
        (err) => {
          if (err) {
            return res.status(500).send("Erro ao atualizar a senha");
          }

          res.send("Senha atualizada com sucesso!");
        }
      );
    }
  );
});

// Rota para exibir o formulário de alteração de senha
app.get("/alterar-senha", (req, res) => {
  res.render("alterar-senha"); // renderiza a página alterar-senha.ejs
});

app.post("/alterar-senha", (req, res) => {
  const { email, senhaAtual, novaSenha } = req.body;

  // Verifica se o e-mail está cadastrado
  db.query(
    "SELECT * FROM usuarios WHERE email = ?",
    [email],
    (err, results) => {
      if (err) {
        return res.status(500).send("Erro ao verificar e-mail");
      }

      if (results.length === 0) {
        return res.status(400).send("E-mail não cadastrado");
      }

      const usuario = results[0];

      // Verifica se a senha atual está correta
      if (!bcrypt.compareSync(senhaAtual, usuario.senha)) {
        return res.status(400).send("Senha atual incorreta");
      }

      // Gera o hash da nova senha
      const senhaHash = bcrypt.hashSync(novaSenha, 10);

      // Atualiza a senha no banco de dados
      db.query(
        "UPDATE usuarios SET senha = ? WHERE email = ?",
        [senhaHash, email],
        (err) => {
          if (err) {
            return res.status(500).send("Erro ao atualizar a senha");
          }
          res.send("Senha alterada com sucesso");
        }
      );
    }
  );
});

// Rota para editar uma receita
app.get("/editar-receita/:id", (req, res) => {
  const { id } = req.params;

  // Verifique se o usuário está autenticado
  const usuarioId = req.session.user ? req.session.user.id : null;

  const query = "SELECT * FROM comidas WHERE id = ? AND usuario_id = ?";

  db.query(query, [id, usuarioId], (err, results) => {
    if (err) {
      console.error("Erro ao buscar a receita para editar:", err);
      res.status(500).send("Erro ao buscar a receita");
      return;
    }

    if (results.length === 0) {
      return res
        .status(403)
        .send("Você não tem permissão para editar esta receita");
    }

    res.render("editar_receita", { receita: results[0] });
  });
});

// Rota para atualizar uma receita
app.post("/atualizar-receita/:id", (req, res) => {
  const { id } = req.params;
  const {
    titulo,
    descricao,
    categoria,
    imagem_url,
    tempo_preparo,
    rendimento,
  } = req.body;

  const query = `
    UPDATE comidas SET titulo = ?, descricao = ?, categoria = ?, imagem_url = ?, tempo_preparo = ?, rendimento = ?
    WHERE id = ?
  `;

  db.query(
    query,
    [titulo, descricao, categoria, imagem_url, tempo_preparo, rendimento, id],
    (err) => {
      if (err) {
        console.error("Erro ao atualizar a receita:", err);
        res.status(500).send("Erro ao atualizar a receita");
        return;
      }
      res.redirect("/listar-receitas"); // Redireciona após a atualização
    }
  );
});

// Rota para deletar uma receita
app.post("/deletar-receita/:id", (req, res) => {
  const id = req.params.id;

  const query = `DELETE FROM comidas WHERE id = ?`;
  db.query(query, [id], (err) => {
    if (err) {
      console.error("Erro ao deletar a receita:", err);
      res.status(500).send("Erro ao deletar a receita");
      return;
    }

    res.redirect("/listar-receitas"); // Redireciona para a lista de receitas após a exclusão
  });
});

// Rota para editar um ingrediente
app.get("/editar-ingrediente/:id", (req, res) => {
  const { id } = req.params;
  const query = "SELECT * FROM ingredientes WHERE id = ?";

  db.query(query, [id], (err, results) => {
    if (err) {
      console.error("Erro ao buscar o ingrediente para editar:", err);
      res.status(500).send("Erro ao buscar o ingrediente");
      return;
    }
    res.render("editar_ingrediente", { ingrediente: results[0] }); // Crie um arquivo editar_ingrediente.ejs
  });
});

// Rota para atualizar um ingrediente
app.post("/atualizar-ingrediente/:id", (req, res) => {
  const { id } = req.params;
  const { comida_id, descricao, quantidade, unidade } = req.body;

  const query = `
    UPDATE ingredientes SET comida_id = ?, descricao = ?, quantidade = ?, unidade = ?
    WHERE id = ?
  `;

  db.query(query, [comida_id, descricao, quantidade, unidade, id], (err) => {
    if (err) {
      console.error("Erro ao atualizar o ingrediente:", err);
      res.status(500).send("Erro ao atualizar o ingrediente");
      return;
    }
    res.redirect("/listar-ingredientes"); // Redireciona após a atualização
  });
});

// Rota para deletar um ingrediente
app.post("/deletar-ingrediente/:id", (req, res) => {
  const { id } = req.params;

  const query = "DELETE FROM ingredientes WHERE id = ?";
  db.query(query, [id], (err) => {
    if (err) {
      console.error("Erro ao deletar o ingrediente:", err);
      res.status(500).send("Erro ao deletar o ingrediente");
      return;
    }
    res.redirect("/listar-ingredientes"); // Redireciona após a deleção
  });
});

// Rota para editar um modo de preparo
app.get("/editar-modo-preparo/:id", (req, res) => {
  const { id } = req.params;
  const query = "SELECT * FROM modos_preparo WHERE id = ?";

  db.query(query, [id], (err, results) => {
    if (err) {
      console.error("Erro ao buscar o modo de preparo para editar:", err);
      res.status(500).send("Erro ao buscar o modo de preparo");
      return;
    }
    res.render("editar_modo_preparo", { modo: results[0] }); // Crie um arquivo editar_modo_preparo.ejs
  });
});

// Rota para atualizar um modo de preparo
app.post("/atualizar-modo-preparo/:id", (req, res) => {
  const { id } = req.params;
  const { comida_id, descricao, passo_numero } = req.body;

  const query = `
    UPDATE modos_preparo SET comida_id = ?, descricao = ?, passo_numero = ?
    WHERE id = ?
  `;

  db.query(query, [comida_id, descricao, passo_numero, id], (err) => {
    if (err) {
      console.error("Erro ao atualizar o modo de preparo:", err);
      res.status(500).send("Erro ao atualizar o modo de preparo");
      return;
    }
    res.redirect("/listar-modos-preparo"); // Redireciona após a atualização
  });
});

// Rota para deletar um modo de preparo
app.post("/deletar-modo-preparo/:id", (req, res) => {
  const { id } = req.params;

  const query = "DELETE FROM modos_preparo WHERE id = ?";
  db.query(query, [id], (err) => {
    if (err) {
      console.error("Erro ao deletar o modo de preparo:", err);
      res.status(500).send("Erro ao deletar o modo de preparo");
      return;
    }
    res.redirect("/listar-modos-preparo"); // Redireciona após a deleção
  });
});

app.get("/pesquisar", (req, res) => {
  const termoPesquisa = req.query.query;

  const query = `
    SELECT c.id, c.titulo, c.descricao, c.categoria, c.imagem_url, c.tempo_preparo, c.rendimento,
           GROUP_CONCAT(DISTINCT mp.descricao ORDER BY mp.passo_numero ASC SEPARATOR '|') AS passos,
           GROUP_CONCAT(DISTINCT CONCAT(i.descricao, '|', i.quantidade, '|', i.unidade) ORDER BY i.id ASC SEPARATOR '||') AS ingredientes
    FROM comidas c
    LEFT JOIN modos_preparo mp ON c.id = mp.comida_id
    LEFT JOIN ingredientes i ON c.id = i.comida_id
    WHERE c.titulo LIKE ? OR c.categoria LIKE ?
    GROUP BY c.id;
  `;

  const parametros = [`%${termoPesquisa}%`, `%${termoPesquisa}%`];

  db.query(query, parametros, (err, results) => {
    if (err) {
      console.error("Erro ao buscar receitas:", err);
      return res.status(500).send("Erro ao buscar as receitas");
    }

    results.forEach((comida) => {
      comida.ingredientes = comida.ingredientes
        ? comida.ingredientes.split("||")
        : [];
      // A variável passos deve ser inicializada corretamente como uma string
      comida.passos = comida.passos ? comida.passos.split("|") : []; // Agora 'passos' deve ser um array
    });

    res.render("resultados", {
      comidas: results,
      pageTitle: `Resultados da pesquisa para: ${termoPesquisa}`,
    });
  });
});

// Iniciar o servidor
app.listen(PORT, HOST, () => {
  console.log(`Servidor: ${HOST} rodando na porta: ${PORT}`);
});
