
# gitFood

Aplicação para gerenciamento de receitas onde os usuários podem cadastrar comidas, ingredientes e modos de preparo, visualizando apenas seus próprios registros. O sistema oferece uma navegação intuitiva e organizada, permitindo também a inclusão de favoritos.

## Índice

1. [Descrição](#descrição)
2. [Instalação](#instalação)
3. [Uso](#uso)
4. [Funcionalidades](#funcionalidades)
5. [Tecnologias](#tecnologias)
6. [Contribuição](#contribuição)
7. [Autores](#autores)

## Descrição

O **gitFood** permite que os usuários possam cadastrar suas próprias receitas, ingredientes e modos de preparo, organizados e vinculados às suas contas. O objetivo é fornecer uma ferramenta prática para armazenar e consultar receitas de maneira personalizada e fácil de navegar.

As funcionalidades incluem:
- Autenticação e login de usuários;
- Adição e consulta de receitas, ingredientes e modos de preparo;
- Listagem personalizada por usuário;
- Favoritos para receitas mais acessadas.

A interface é desenvolvida com **Bootstrap** e a aplicação é dividida entre frontend e backend, com banco de dados para gerenciar os relacionamentos entre usuários, receitas, ingredientes e modos de preparo.

## Instalação

Para configurar o projeto localmente, siga os passos abaixo:

1. Clone o repositório:
   ```bash
   git clone https://github.com/joaobeji/piProgWeb.git
   ```
   Ou clique em **Code -> Download ZIP** para baixar o projeto.

2. Instale o **NodeJS** (caso ainda não tenha) acessando: [NodeJS Download](https://nodejs.org/en)

3. Instale o **MySQL** (caso ainda não tenha) acessando: [MySQL Download](https://dev.mysql.com/downloads/)
   - Baixe a versão **MySQL Installer for Windows**.
   - Abra o **MySQL Workbench 8.0 CE** e crie o banco de dados:
     - Nome do banco de dados: `receitas_db`
     - Importe o arquivo `receitas_db.sql`, localizado na pasta clonada ou baixada.

4. Acesse a pasta clonada ou baixada via terminal e execute o comando abaixo para instalar as dependências:
   ```bash
   npm install
   ```

5. Após a instalação, inicie o projeto com o comando:
   ```bash
   node app.js
   ```

## Uso

- A aplicação estará em execução na porta indicada no terminal (normalmente, [http://localhost:3000](http://localhost:3000)).
- Caso prefira, o projeto também pode ser acessado online: [GitFood Online](https://gitfood-by9b.onrender.com/)

## Funcionalidades

1. **Cadastro e Login de Usuários** – Permite o cadastro seguro de novos usuários e login com credenciais.
2. **Gerenciamento de Receitas** – Cadastro, edição e exclusão de receitas, ingredientes e modos de preparo.
3. **Favoritos** – Adicionar e consultar receitas favoritas.
4. **Visualização Personalizada** – Listagem de conteúdos restrita ao usuário logado.
5. **Segurança de Dados** – Proteção de senhas com bcrypt e uso de express-session para sessões de login.

## Tecnologias

- **JavaScript**
- **NodeJS**
- **MySQL**
- **Express**
- **EJS**
- **bcrypt**
- **dotenv**
- **express-session**
- **mysql2**
- **nodemailer**
- **Render** (Hospedagem)
- **Freedb.tech** (Banco de Dados Online)

## Autores

1. Gabriel Santos da Silva Barbosa
2. Karoline dos Santos Pereira
3. Maria Vitória Ferreira dos Santos
4. Mateus Lucas da Silva Santos
5. Maurício Ferro da Silva
6. Nataniel Barboza da Silva
