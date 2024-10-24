-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: localhost    Database: receitas_db
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `comidas`
--

DROP TABLE IF EXISTS `comidas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comidas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) DEFAULT NULL,
  `descricao` text,
  `categoria` varchar(100) DEFAULT NULL,
  `imagem_url` varchar(500) DEFAULT NULL,
  `tempo_preparo` int DEFAULT NULL,
  `rendimento` varchar(50) DEFAULT NULL,
  `usuario_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `comidas_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comidas`
--

LOCK TABLES `comidas` WRITE;
/*!40000 ALTER TABLE `comidas` DISABLE KEYS */;
INSERT INTO `comidas` VALUES (1,'Feijoada','Tradicional feijoada brasileira.','Comida Caseira','https://cozinhamundi.com/wp-content/uploads/2023/09/feijoada-brasileira.jpg',120,'8 porções',1),(2,'Bolo de Cenoura','Bolo de cenoura com cobertura de chocolate.','Bolos e Tortas','https://static.itdg.com.br/images/1200-630/f2a06c2a3f1f470b00387776c30addb5/bolo-de-cenoura-com-cobertura-de-chocolate.jpg',60,'10 fatias',1),(3,'Lasanha','Lasanha de carne com molho branco.','Massas','https://static.itdg.com.br/images/1200-675/f72fedc5f0c8206a812b51d475fcaa8e/40048-328930-original.jpg',90,'6 porções',1),(4,'Coxinha','Coxinha de frango.','Lanches','https://www.sabornamesa.com.br/media/k2/items/cache/a2d776612246d598c744792a62711a11_XL.jpg',30,'20 unidades',1),(5,'Moqueca de Peixe','Moqueca de peixe com leite de coco.','Comida Caseira','https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgBisbrqgDGlTHZt8QDIc59hhBoHwf2ocIcb4XvZuihPf1-1XD1HFqRU69PPa_zhZygqSD_nmvpnTnwOzr-OXcmSwXwuq1VU7w2b3TnmQMu1tN5ITs8vbu0wjGBRtW3WTVRHwwU147BsAzSgdhZGmAChFOsHXRBt-mSmRac4YjXqwZLWA2EqRVZiLTx/w1200-h630-p-k-no-nu/receita-de-peixe-ao-leite-de-coco.jpg',80,'5 porções',2),(6,'Torta de Limão','Torta de limão com merengue.','Bolos e Tortas','https://i.panelinha.com.br/i1/228-bk-3690-cp-2019-31-01-6624.webp',45,'8 fatias',2),(7,'Espaguete à Bolonhesa','Espaguete com molho à bolonhesa.','Massas','https://revistasaboresdosul.com.br/wp-content/uploads/2015/08/espaguete-a-bolonhesa.jpeg',50,'4 porções',2),(8,'Pastel','Pastel de queijo.','Lanches','https://receitason.com/wp-content/uploads/2023/05/pastel-de-queijo.jpg',20,'15 unidades',2),(9,'Feijão Tropeiro','Feijão tropeiro mineiro.','Comida Caseira','https://i.ytimg.com/vi/whpvAKQGlKI/maxresdefault.jpg',60,'6 porções',3),(10,'Bolo de Chocolate','Bolo de chocolate fofinho.','Bolos e Tortas','https://d2qcpt1idvpipw.cloudfront.net/recipes/2020/10/bolo-de-chocolate-de-liquidificador-fofinho_22052020153905.jpg',70,'12 fatias',3),(11,'Ravioli','Ravioli recheado com queijo e espinafre.','Massas','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLmosSx9Udhjo5pmI2PdbU9JqNx1M7NCqqYg&s',40,'4 porções',3),(12,'Sanduíche Natural','Sanduíche de frango com salada.','Lanches','https://assets.unileversolutions.com/recipes-v2/99439.jpg',15,'5 unidades',3),(13,'Arroz de Pato','Arroz com pato e linguiça.','Comida Caseira','https://painacozinha.com/wp-content/uploads/2023/09/129.Arroz-de-Pato-com-Linguica-Portuguesa-e-Laranja.jpg',90,'6 porções',4),(14,'Bolo de Fubá','Bolo de fubá cremoso.','Bolos e Tortas','https://p2.trrsf.com/image/fget/cf/942/530/images.terra.com/2023/01/15/2080173883-bolo-fuba-requeijao-cremoso.jpg',50,'10 fatias',4),(15,'Nhoque','Nhoque de batata com molho de tomate.','Massas','https://www.vaisefood.com/wp-content/uploads/2013/07/thegourmetnhoque.jpg',60,'5 porções',4),(16,'Empada','Empada de frango.','Lanches','https://amoreninha.com.br/wp-content/uploads/2023/08/como-fazer-empadinha-de-frango.webp',25,'12 unidades',4),(17,'Bolo de Chocolate','Bolo de chocolate fofinho com cobertura cremosa.','Doces','https://images.mrcook.app/recipe-image/0190e0bb-2031-75ad-af3d-3559d9e423bb',60,'10 porções',1),(18,'Brigadeiro','Docinho tradicional brasileiro feito com leite condensado e chocolate.','Doces','https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiuczBMMN4DhPnLKvMZxKfIFFaltpmMFkxCvULPm6XWK-3L831gCevouwXaZ7bg_rNWZ3iY0zt1aB6izjBykgcehcoD-aTuDf_gyRps0M3b2OgHx3bkJccqDqfeD8BFCqccW1bv1eSOA7e6wCxjt4hPHpzoO_JYPsbPVihnlJYgmaZo4cc6_6Ml35yz3Q/w640-h480/brigadeiro-doce-1.jpg',30,'25 unidades',2),(19,'Pudim de Leite','Pudim clássico com calda de caramelo.','Doces','https://midias.agazeta.com.br/2023/08/07/pudim-de-leite-com-calda-de-balsamico-1828414.jpg',90,'8 porções',3),(20,'Mousse de Maracujá','Sobremesa cremosa e refrescante.','Doces','https://www.guiadasemana.com.br/contentFiles/image/opt_w1280h960/2023/11/FEA/71315_receita-mousse-maracuja.jpg',20,'6 porções',4),(21,'Torta de Limão','Torta com base crocante e recheio de limão.','Doces','https://guiadacozinha.com.br/wp-content/uploads/2018/04/torta-de-limao-facil.jpg',45,'8 porções',5),(22,'Suco de Laranja','Suco natural de laranja.','Bebidas','https://static.itdg.com.br/images/360-240/adfdbbdccfef337f7655712a021367d3/shutterstock-788249257-1-.jpg',10,'4 copos',1),(23,'Smoothie de Morango','Smoothie refrescante de morango e banana.','Bebidas','https://painacozinha.com/wp-content/uploads/2023/11/65.Smoothie-de-Morango-e-Banana.jpg',5,'2 copos',2),(24,'Café Gelado','Café com gelo e leite condensado.','Bebidas','https://images.mrcook.app/recipe-image/01920152-e425-7832-aaf7-82a1d68b19f7',15,'2 copos',3),(25,'Chá de Hortelã','Chá natural de hortelã com limão.','Bebidas','https://www.pensenatural.com.br/wp-content/uploads/2019/01/cha-de-hortela-1-1.jpg',10,'4 xícaras',4),(26,'Milkshake de Chocolate','Milkshake cremoso de chocolate.','Bebidas','https://img.freepik.com/fotos-gratis/mesa-de-sobremesa-com-ia-generativa-de-doces-de-chocolate-gourmet_188544-8506.jpg?size=626&ext=jpg&ga=GA1.1.2008272138.1721692800&semt=ais_user',8,'3 copos',5);
/*!40000 ALTER TABLE `comidas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredientes`
--

DROP TABLE IF EXISTS `ingredientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredientes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comida_id` int DEFAULT NULL,
  `descricao` varchar(255) DEFAULT NULL,
  `quantidade` varchar(100) DEFAULT NULL,
  `unidade` varchar(50) DEFAULT NULL,
  `usuario_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `comida_id` (`comida_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `ingredientes_ibfk_1` FOREIGN KEY (`comida_id`) REFERENCES `comidas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ingredientes_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredientes`
--

LOCK TABLES `ingredientes` WRITE;
/*!40000 ALTER TABLE `ingredientes` DISABLE KEYS */;
INSERT INTO `ingredientes` VALUES (1,1,'Feijão preto','500','g',1),(2,1,'Carne seca','200','g',1),(3,2,'Cenoura','2','unidades',1),(4,2,'Farinha de trigo','3','xícaras',1),(5,3,'Massa para lasanha','500','g',1),(6,3,'Molho de tomate','2','xícaras',1),(7,4,'Frango desfiado','300','g',1),(8,4,'Farinha de rosca','1','xícara',1),(9,5,'Filé de peixe','1','kg',2),(10,5,'Leite de coco','1','lata',2),(11,6,'Limão','3','unidades',2),(12,6,'Leite condensado','1','lata',2),(13,7,'Espaguete','500','g',2),(14,7,'Carne moída','300','g',2),(15,8,'Queijo','200','g',2),(16,8,'Massa para pastel','20','unidades',2),(17,17,'Farinha de trigo','2','xícaras',1),(18,17,'Açúcar','1','xícara',1),(19,17,'Chocolate em pó','1/2','xícara',1),(20,18,'Leite condensado','1','lata',2),(21,18,'Chocolate granulado','1','xícara',2),(22,19,'Leite condensado','1','lata',3),(23,19,'Ovos','3','unidades',3),(24,20,'Suco de maracujá','1','xícara',4),(25,20,'Creme de leite','1','lata',4),(26,21,'Biscoitos de maisena','200','gramas',5),(27,21,'Leite condensado','1','lata',5),(28,22,'Laranjas','6','unidades',1),(29,22,'Água gelada','500','ml',1),(30,23,'Morangos','1','xícara',2),(31,23,'Banana','1','unidade',2),(32,24,'Café','1','xícara',3),(33,24,'Leite condensado','2','colheres de sopa',3),(34,25,'Folhas de hortelã','1','punhado',4),(35,25,'Limão','1','unidade',4),(36,26,'Sorvete de chocolate','2','bolas',5),(37,26,'Leite','200','ml',5);
/*!40000 ALTER TABLE `ingredientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modos_preparo`
--

DROP TABLE IF EXISTS `modos_preparo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modos_preparo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `comida_id` int DEFAULT NULL,
  `passo_numero` int DEFAULT NULL,
  `descricao` text,
  `usuario_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `comida_id` (`comida_id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `modos_preparo_ibfk_1` FOREIGN KEY (`comida_id`) REFERENCES `comidas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `modos_preparo_ibfk_2` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modos_preparo`
--

LOCK TABLES `modos_preparo` WRITE;
/*!40000 ALTER TABLE `modos_preparo` DISABLE KEYS */;
INSERT INTO `modos_preparo` VALUES (1,1,1,'Cozinhe o feijão até ficar macio.',1),(2,1,2,'Adicione a carne seca e cozinhe por mais 30 minutos.',1),(3,2,1,'Bata a cenoura no liquidificador.',1),(4,2,2,'Misture a cenoura com a massa e leve ao forno.',1),(5,3,1,'Cozinhe a massa de lasanha.',1),(6,3,2,'Monte a lasanha com camadas de molho e massa.',1),(7,4,1,'Recheie a massa com o frango desfiado.',1),(8,4,2,'Empane e frite as coxinhas.',1),(9,5,1,'Tempere o peixe com sal e pimenta.',2),(10,5,2,'Cozinhe com leite de coco até engrossar o caldo.',2),(11,6,1,'Misture o suco de limão com o leite condensado.',2),(12,6,2,'Cubra a torta com o merengue e leve ao forno.',2),(13,7,1,'Cozinhe o espaguete.',2),(14,7,2,'Refogue a carne moída com molho.',2),(15,8,1,'Recheie os pastéis e frite até dourar.',2),(16,8,2,'Sirva quente.',2),(17,17,1,'Preaqueça o forno a 180°C.',1),(18,17,2,'Misture a farinha, açúcar e chocolate em pó.',1),(19,18,1,'Misture o leite condensado e o chocolate em uma panela.',2),(20,18,2,'Leve ao fogo baixo, mexendo sempre até desgrudar do fundo.',2),(21,19,1,'Bata todos os ingredientes no liquidificador.',3),(22,19,2,'Despeje em uma forma caramelizada e asse em banho-maria.',3),(23,20,1,'Misture o suco de maracujá com o creme de leite.',4),(24,20,2,'Leve à geladeira por 2 horas antes de servir.',4),(25,21,1,'Triture os biscoitos e misture com a manteiga para formar a base.',5),(26,21,2,'Recheie com o creme de leite condensado e limão.',5),(27,22,1,'Esprema as laranjas e misture o suco com a água gelada.',1),(28,22,2,'Sirva com gelo.',1),(29,23,1,'Bata os morangos e a banana no liquidificador.',2),(30,23,2,'Adicione gelo e sirva imediatamente.',2),(31,24,1,'Prepare o café e deixe esfriar.',3),(32,24,2,'Misture com o leite condensado e sirva com gelo.',3),(33,25,1,'Ferva a água e adicione as folhas de hortelã.',4),(34,25,2,'Esprema o limão e adicione ao chá.',4),(35,26,1,'Bata o sorvete e o leite no liquidificador.',5),(36,26,2,'Sirva com cobertura de chocolate.',5);
/*!40000 ALTER TABLE `modos_preparo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expira` timestamp NULL DEFAULT NULL,
  `criado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Alice Souza','joaobejieduardo@gmail.com','$2b$10$uDQsyo8NxOxsEXQE/b19rOUEfKueLpI53JSBfSA2i67KIUfjpopSW',NULL,NULL,'2024-10-13 20:39:01'),(2,'Bruno Silva','bruno@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(3,'Carla Mendes','carla@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(4,'Daniel Costa','daniel@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(5,'Elaine Rocha','elaine@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(6,'Fernando Lima','fernando@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(7,'Gabriela Martins','gabriela@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(8,'Henrique Almeida','henrique@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(9,'Isabela Nunes','isabela@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(10,'Júlio Cesar','julio@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(11,'Karla Santos','karla@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(12,'Lucas Oliveira','lucas@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(13,'Marina Souza','marina@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(14,'Natália Lima','natalia@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(15,'Otávio Gomes','otavio@example.com','senha123',NULL,NULL,'2024-10-13 20:39:01'),(17,'João Silva','joao.silva@email.com','senha123',NULL,NULL,'2024-10-14 05:47:11'),(18,'Maria Oliveira','maria.oliveira@email.com','senha456',NULL,NULL,'2024-10-14 05:47:11'),(19,'Carlos Pereira','carlos.pereira@email.com','senha789',NULL,NULL,'2024-10-14 05:47:11'),(20,'Ana Souza','ana.souza@email.com','senha321',NULL,NULL,'2024-10-14 05:47:11'),(21,'Beatriz Lima','beatriz.lima@email.com','senha654',NULL,NULL,'2024-10-14 05:47:11');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-14  4:19:13
