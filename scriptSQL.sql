SELECT * FROM receitas_db.comidas;
where usuario_id = 2;

SELECT * FROM receitas_db.ingredientes;
where usuario_id = 2;

SELECT * FROM receitas_db.modos_preparo
where usuario_id = 2;

SELECT * FROM receitas_db.usuarios;



ALTER TABLE usuarios
ADD COLUMN reset_token VARCHAR(255) DEFAULT NULL,
ADD COLUMN reset_token_expires TIMESTAMP DEFAULT NULL;


DESCRIBE ingredientes;
ALTER TABLE ingredientes ADD COLUMN descricao VARCHAR(255);

/*
	INSERÇÃO DE DADOS NAS TABELAS
*/

CREATE DATABASE receitas_db;

USE receitas_db;

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    reset_token VARCHAR(255) DEFAULT NULL,
    reset_token_expira TIMESTAMP DEFAULT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Tabela de comidas
CREATE TABLE
    comidas (
        id INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(255),
        descricao TEXT,
        categoria VARCHAR(100),
        imagem_url VARCHAR(255),
        tempo_preparo INT,
        rendimento VARCHAR(50),
        usuario_id INT,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
    );

-- Tabela de ingredientes
CREATE TABLE
    ingredientes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        comida_id INT,
        descricao VARCHAR(255),
        quantidade VARCHAR(100),
        unidade VARCHAR(50),
        usuario_id INT,
        FOREIGN KEY (comida_id) REFERENCES comidas (id) ON DELETE CASCADE,
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
    );

-- Tabela de modos de preparo
CREATE TABLE
    modos_preparo (
        id INT AUTO_INCREMENT PRIMARY KEY,
        comida_id INT,
        passo_numero INT,
        descricao TEXT,
        usuario_id INT,
        FOREIGN KEY (comida_id) REFERENCES comidas (id) ON DELETE CASCADE,
        FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
    );

INSERT INTO usuarios (nome, email, senha) VALUES 
('Alice Souza', 'alice@example.com', 'senha123'),
('Bruno Silva', 'bruno@example.com', 'senha123'),
('Carla Mendes', 'carla@example.com', 'senha123'),
('Daniel Costa', 'daniel@example.com', 'senha123'),
('Elaine Rocha', 'elaine@example.com', 'senha123'),
('Fernando Lima', 'fernando@example.com', 'senha123'),
('Gabriela Martins', 'gabriela@example.com', 'senha123'),
('Henrique Almeida', 'henrique@example.com', 'senha123'),
('Isabela Nunes', 'isabela@example.com', 'senha123'),
('Júlio Cesar', 'julio@example.com', 'senha123'),
('Karla Santos', 'karla@example.com', 'senha123'),
('Lucas Oliveira', 'lucas@example.com', 'senha123'),
('Marina Souza', 'marina@example.com', 'senha123'),
('Natália Lima', 'natalia@example.com', 'senha123'),
('Otávio Gomes', 'otavio@example.com', 'senha123');


INSERT INTO comidas (titulo, descricao, categoria, imagem_url, tempo_preparo, rendimento, usuario_id) VALUES
('Feijoada', 'Tradicional feijoada brasileira.', 'Comida Caseira', 'feijoada.jpg', 120, '8 porções', 1),
('Bolo de Cenoura', 'Bolo de cenoura com cobertura de chocolate.', 'Bolos e Tortas', 'bolo_cenoura.jpg', 60, '10 fatias', 1),
('Lasanha', 'Lasanha de carne com molho branco.', 'Massas', 'lasanha.jpg', 90, '6 porções', 1),
('Coxinha', 'Coxinha de frango.', 'Lanches', 'coxinha.jpg', 30, '20 unidades', 1),

('Moqueca de Peixe', 'Moqueca de peixe com leite de coco.', 'Comida Caseira', 'moqueca.jpg', 80, '5 porções', 2),
('Torta de Limão', 'Torta de limão com merengue.', 'Bolos e Tortas', 'torta_limao.jpg', 45, '8 fatias', 2),
('Espaguete à Bolonhesa', 'Espaguete com molho à bolonhesa.', 'Massas', 'espaguete.jpg', 50, '4 porções', 2),
('Pastel', 'Pastel de queijo.', 'Lanches', 'pastel.jpg', 20, '15 unidades', 2),

('Feijão Tropeiro', 'Feijão tropeiro mineiro.', 'Comida Caseira', 'feijao_tropeiro.jpg', 60, '6 porções', 3),
('Bolo de Chocolate', 'Bolo de chocolate fofinho.', 'Bolos e Tortas', 'bolo_chocolate.jpg', 70, '12 fatias', 3),
('Ravioli', 'Ravioli recheado com queijo e espinafre.', 'Massas', 'ravioli.jpg', 40, '4 porções', 3),
('Sanduíche Natural', 'Sanduíche de frango com salada.', 'Lanches', 'sanduiche_natural.jpg', 15, '5 unidades', 3),

('Arroz de Pato', 'Arroz com pato e linguiça.', 'Comida Caseira', 'arroz_pato.jpg', 90, '6 porções', 4),
('Bolo de Fubá', 'Bolo de fubá cremoso.', 'Bolos e Tortas', 'bolo_fuba.jpg', 50, '10 fatias', 4),
('Nhoque', 'Nhoque de batata com molho de tomate.', 'Massas', 'nhoque.jpg', 60, '5 porções', 4),
('Empada', 'Empada de frango.', 'Lanches', 'empada.jpg', 25, '12 unidades', 4);


INSERT INTO ingredientes (comida_id, descricao, quantidade, unidade, usuario_id) VALUES
(1, 'Feijão preto', '500', 'g', 1),
(1, 'Carne seca', '200', 'g', 1),
(2, 'Cenoura', '2', 'unidades', 1),
(2, 'Farinha de trigo', '3', 'xícaras', 1),
(3, 'Massa para lasanha', '500', 'g', 1),
(3, 'Molho de tomate', '2', 'xícaras', 1),
(4, 'Frango desfiado', '300', 'g', 1),
(4, 'Farinha de rosca', '1', 'xícara', 1),

(5, 'Filé de peixe', '1', 'kg', 2),
(5, 'Leite de coco', '1', 'lata', 2),
(6, 'Limão', '3', 'unidades', 2),
(6, 'Leite condensado', '1', 'lata', 2),
(7, 'Espaguete', '500', 'g', 2),
(7, 'Carne moída', '300', 'g', 2),
(8, 'Queijo', '200', 'g', 2),
(8, 'Massa para pastel', '20', 'unidades', 2);


INSERT INTO modos_preparo (comida_id, passo_numero, descricao, usuario_id) VALUES
(1, 1, 'Cozinhe o feijão até ficar macio.', 1),
(1, 2, 'Adicione a carne seca e cozinhe por mais 30 minutos.', 1),
(2, 1, 'Bata a cenoura no liquidificador.', 1),
(2, 2, 'Misture a cenoura com a massa e leve ao forno.', 1),
(3, 1, 'Cozinhe a massa de lasanha.', 1),
(3, 2, 'Monte a lasanha com camadas de molho e massa.', 1),
(4, 1, 'Recheie a massa com o frango desfiado.', 1),
(4, 2, 'Empane e frite as coxinhas.', 1),

(5, 1, 'Tempere o peixe com sal e pimenta.', 2),
(5, 2, 'Cozinhe com leite de coco até engrossar o caldo.', 2),
(6, 1, 'Misture o suco de limão com o leite condensado.', 2),
(6, 2, 'Cubra a torta com o merengue e leve ao forno.', 2),
(7, 1, 'Cozinhe o espaguete.', 2),
(7, 2, 'Refogue a carne moída com molho.', 2),
(8, 1, 'Recheie os pastéis e frite até dourar.', 2),
(8, 2, 'Sirva quente.', 2);


