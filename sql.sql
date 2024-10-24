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
        imagem_url VARCHAR(500),
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

CREATE TABLE favoritos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    comida_id INT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (comida_id) REFERENCES comidas(id) ON DELETE CASCADE
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
('Otávio Gomes', 'otavio@example.com', 'senha123'),
('João Silva', 'joao.silva@email.com', 'senha123'),
('Maria Oliveira', 'maria.oliveira@email.com', 'senha456'),
('Carlos Pereira', 'carlos.pereira@email.com', 'senha789'),
('Ana Souza', 'ana.souza@email.com', 'senha321'),
('Beatriz Lima', 'beatriz.lima@email.com', 'senha654');




INSERT INTO comidas (titulo, descricao, categoria, imagem_url, tempo_preparo, rendimento, usuario_id) VALUES
('Feijoada', 'Tradicional feijoada brasileira.', 'Comida Caseira', 'https://cozinhamundi.com/wp-content/uploads/2023/09/feijoada-brasileira.jpg', 120, '8 porções', 1),
('Bolo de Cenoura', 'Bolo de cenoura com cobertura de chocolate.', 'Bolos e Tortas', 'https://static.itdg.com.br/images/1200-630/f2a06c2a3f1f470b00387776c30addb5/bolo-de-cenoura-com-cobertura-de-chocolate.jpg', 60, '10 fatias', 1),
('Lasanha', 'Lasanha de carne com molho branco.', 'Massas', 'https://static.itdg.com.br/images/1200-675/f72fedc5f0c8206a812b51d475fcaa8e/40048-328930-original.jpg', 90, '6 porções', 1),
('Coxinha', 'Coxinha de frango.', 'Lanches', 'https://www.sabornamesa.com.br/media/k2/items/cache/a2d776612246d598c744792a62711a11_XL.jpg', 30, '20 unidades', 1),

('Moqueca de Peixe', 'Moqueca de peixe com leite de coco.', 'Comida Caseira', 'https://www.sumerbol.com.br/uploads/images/2017/11/moqueca-de-peixe-590-1510656991.jpg', 80, '5 porções', 2),
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



------------------------------------------------------
-- Inserção de usuários
INSERT INTO usuarios (nome, email, senha) VALUES
('João Silva', 'joao.silva@email.com', 'senha123'),
('Maria Oliveira', 'maria.oliveira@email.com', 'senha456'),
('Carlos Pereira', 'carlos.pereira@email.com', 'senha789'),
('Ana Souza', 'ana.souza@email.com', 'senha321'),
('Beatriz Lima', 'beatriz.lima@email.com', 'senha654');

-- Inserção de comidas na categoria "Doces"
INSERT INTO comidas (titulo, descricao, categoria, imagem_url, tempo_preparo, rendimento, usuario_id) VALUES
('Bolo de Chocolate', 'Bolo de chocolate fofinho com cobertura cremosa.', 'Doces', 'https://exemplo.com/bolo-chocolate.jpg', 60, '10 porções', 1),
('Brigadeiro', 'Docinho tradicional brasileiro feito com leite condensado e chocolate.', 'Doces', 'https://exemplo.com/brigadeiro.jpg', 30, '25 unidades', 2),
('Pudim de Leite', 'Pudim clássico com calda de caramelo.', 'Doces', 'https://exemplo.com/pudim-leite.jpg', 90, '8 porções', 3),
('Mousse de Maracujá', 'Sobremesa cremosa e refrescante.', 'Doces', 'https://exemplo.com/mousse-maracuja.jpg', 20, '6 porções', 4),
('Torta de Limão', 'Torta com base crocante e recheio de limão.', 'Doces', 'https://exemplo.com/torta-limao.jpg', 45, '8 porções', 5);

-- Inserção de comidas na categoria "Bebidas"
INSERT INTO comidas (titulo, descricao, categoria, imagem_url, tempo_preparo, rendimento, usuario_id) VALUES
('Suco de Laranja', 'Suco natural de laranja.', 'Bebidas', 'https://exemplo.com/suco-laranja.jpg', 10, '4 copos', 1),
('Smoothie de Morango', 'Smoothie refrescante de morango e banana.', 'Bebidas', 'https://exemplo.com/smoothie-morango.jpg', 5, '2 copos', 2),
('Café Gelado', 'Café com gelo e leite condensado.', 'Bebidas', 'https://exemplo.com/cafe-gelado.jpg', 15, '2 copos', 3),
('Chá de Hortelã', 'Chá natural de hortelã com limão.', 'Bebidas', 'https://exemplo.com/cha-hortela.jpg', 10, '4 xícaras', 4),
('Milkshake de Chocolate', 'Milkshake cremoso de chocolate.', 'Bebidas', 'https://exemplo.com/milkshake-chocolate.jpg', 8, '3 copos', 5);

-- Inserção de ingredientes para a categoria "Doces"
INSERT INTO ingredientes (comida_id, descricao, quantidade, unidade, usuario_id) VALUES
(17, 'Farinha de trigo', '2', 'xícaras', 1),
(17, 'Açúcar', '1', 'xícara', 1),
(17, 'Chocolate em pó', '1/2', 'xícara', 1),
(18, 'Leite condensado', '1', 'lata', 2),
(18, 'Chocolate granulado', '1', 'xícara', 2),
(19, 'Leite condensado', '1', 'lata', 3),
(19, 'Ovos', '3', 'unidades', 3),
(20, 'Suco de maracujá', '1', 'xícara', 4),
(20, 'Creme de leite', '1', 'lata', 4),
(21, 'Biscoitos de maisena', '200', 'gramas', 5),
(21, 'Leite condensado', '1', 'lata', 5);

-- Inserção de ingredientes para a categoria "Bebidas"
INSERT INTO ingredientes (comida_id, descricao, quantidade, unidade, usuario_id) VALUES
(22,'Laranjas', '6', 'unidades', 1),
(22,'Água gelada', '500', 'ml', 1),
(23,'Morangos', '1', 'xícara', 2),
(23,'Banana', '1', 'unidade', 2),
(24,'Café', '1', 'xícara', 3),
(24,'Leite condensado', '2', 'colheres de sopa', 3),
(25,'Folhas de hortelã', '1', 'punhado', 4),
(25,'Limão', '1', 'unidade', 4),
(26, 'Sorvete de chocolate', '2', 'bolas', 5),
(26, 'Leite', '200', 'ml', 5);

-- Inserção de modos de preparo para a categoria "Doces"
INSERT INTO modos_preparo (comida_id, passo_numero, descricao, usuario_id) VALUES
(17, 1, 'Preaqueça o forno a 180°C.', 1),
(17, 2, 'Misture a farinha, açúcar e chocolate em pó.', 1),
(18, 1, 'Misture o leite condensado e o chocolate em uma panela.', 2),
(18, 2, 'Leve ao fogo baixo, mexendo sempre até desgrudar do fundo.', 2),
(19, 1, 'Bata todos os ingredientes no liquidificador.', 3),
(19, 2, 'Despeje em uma forma caramelizada e asse em banho-maria.', 3),
(20, 1, 'Misture o suco de maracujá com o creme de leite.', 4),
(20, 2, 'Leve à geladeira por 2 horas antes de servir.', 4),
(21, 1, 'Triture os biscoitos e misture com a manteiga para formar a base.', 5),
(21, 2, 'Recheie com o creme de leite condensado e limão.', 5);

-- Inserção de modos de preparo para a categoria "Bebidas"
INSERT INTO modos_preparo (comida_id, passo_numero, descricao, usuario_id) VALUES
(22, 1, 'Esprema as laranjas e misture o suco com a água gelada.', 1),
(22, 2, 'Sirva com gelo.', 1),
(23, 1, 'Bata os morangos e a banana no liquidificador.', 2),
(23, 2, 'Adicione gelo e sirva imediatamente.', 2),
(24, 1, 'Prepare o café e deixe esfriar.', 3),
(24, 2, 'Misture com o leite condensado e sirva com gelo.', 3),
(25, 1, 'Ferva a água e adicione as folhas de hortelã.', 4),
(25, 2, 'Esprema o limão e adicione ao chá.', 4),
(26, 1, 'Bata o sorvete e o leite no liquidificador.', 5),
(26, 2, 'Sirva com cobertura de chocolate.', 5);

