# 📱 FitTracker

![Flutter](https://img.shields.io/badge/Flutter-3.7.2-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue?logo=dart)
![Platform](https://img.shields.io/badge/Plataforma-Android%20%7C%20iOS-green)
![License](https://img.shields.io/badge/Licen%C3%A7a-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Em%20Desenvolvimento-orange)

**FitTracker é um aplicativo criado com o objetivo de auxiliar no planejamento e na execução de treinos, com foco principal em academias. A ideia surgiu por motivação pessoal, e todas as funcionalidades foram pensadas por um desenvolvedor que realmente utiliza o app no dia a dia. Atualmente, o app já se encontra em um estágio utilizável, embora ainda apresente alguns problemas e falte alguns recursos, e vem sendo testado em uso real por mim.**

# Índice

- [📱 FitTracker](#-fittracker)
- [📸 Demonstrações](#-demonstrações)
  - [🏋️‍♂️ Tela de Treinos](#️-tela-de-treinos)
  - [🧩 Tela de Exercícios](#-tela-de-exercícios)
  - [📈 Tela de Progresso](#-tela-de-progresso)
  - [⏱️ Cronômetro e ⚙️ Configurações](#️-cronômetro-e--configurações)
- [🚀 Funcionalidades](#-funcionalidades)
- [📦 Instalação](#-instalação)
- [🛠️ Tecnologias Usadas](#️-tecnologias-usadas)
- [🔧 Estrutura do Projeto](#-estrutura-do-projeto)
- [🧪 Testes](#-testes)
- [📈 Roadmap](#-roadmap)
- [📄 Licença](#-licença)

# 📸 Demonstrações

## 🏋️‍♂️ Tela de Treinos

**As imagens a seguir demonstram a tela de treino. Nela, o usuário pode iniciar, criar e deletar seus treinos.**

- Primeira imagem (da esquerda para a direita): representa a criação de um novo treino, onde o usuário seleciona os exercícios desejados e define um nome para o treino.

- Segunda imagem: mostra a visualização da lista de treinos já criados, com uma prévia dos exercícios incluídos em cada um.

- Terceira imagem: exibe o treino em andamento; conforme o usuário realiza os exercícios, ele pode marcá-los como concluídos, e o progresso do treino é atualizado automaticamente.

<p align="center">
  <img src="https://github.com/user-attachments/assets/17dd7e0c-514e-4289-9dd6-b79c400b4dab" width="30%" />
  <img src="https://github.com/user-attachments/assets/b27ab233-02b9-4a4a-a633-7a2e156ffeca" width="30%" />
  <img src="https://github.com/user-attachments/assets/f042951f-5bc6-4b40-bc32-25877816475d" width="30%" />
</p>

## 🧩 Tela de Exercícios

**A seguir, são exibidas imagens da tela de exercícios, onde o usuário pode visualizar, adicionar, editar e remover exercícios conforme necessário.**

- Primeira imagem (da esquerda para a direita): mostra a lista de exercícios. Cada item pode ser facilmente editado ou excluído por meio dos botões ocultos, que aparecem ao deslizar o card do exercício.
- Segunda imagem: exibe a tela de criação de um novo exercício. O usuário pode informar o nome, número de repetições, séries e a carga, que varia conforme o tipo do exercício (minutos para cardio e quilogramas para musculação).

<p align="center">
  <img src="https://github.com/user-attachments/assets/413aec09-b3c4-4666-8775-67bf33520a82" width="30%" />
  <img src="https://github.com/user-attachments/assets/7af761a7-2326-4caa-98ab-6dbe5fa01eef" width="30%" />
</p>

## 📈 Tela de Progresso

**A seguir, a tela de progresso, onde o usuário pode acompanhar a evolução de qualquer métrica que desejar registrar.**

- Nesta página, o usuário encontrará uma tabela onde poderá criar e adicionar registros, formando um histórico. Um exemplo de uso seria acompanhar o peso ao longo do tempo: o usuário poderia criar uma tabela chamada "Pesagem Semanal" e registrar seu peso toda semana. Com o passar do tempo, o gráfico se formaria automaticamente, oferecendo uma visão geral do progresso.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d1aef49c-bd66-4f30-b5f2-311538b90c5c" width="30%" />
  <img src="https://github.com/user-attachments/assets/44bb28be-5d54-4bb1-b21e-382045dbd384" width="30%" />
  <img src="https://github.com/user-attachments/assets/4fec9901-9d1a-49ed-ac23-7618159743ab" width="30%" />
</p>

## ⏱️ Cronômetro e ⚙️ Configurações

**As próximas telas mostram o cronômetro interno do app, com funções básicas de controle de tempo, e a tela de configurações, onde o usuário pode ajustar diversos aspectos do aplicativo conforme suas preferências.**

**Na tela de configurações, existem três áreas principais:**

1. Tema: permite ao usuário escolher entre os modos claro, escuro ou seguir o tema do sistema, ajustando o esquema de cores para melhor visualização em diferentes situações.

2. Dados: oferece a opção de importar e exportar os dados do aplicativo em formato .json, facilitando backups ou migração.

3. Ferramentas para desenvolvedor: inclui ações como limpar todos os dados ou gerar dados de demonstração. Essa seção não estará visível na versão final (release) do app.

<p align="center">
  <img src="https://github.com/user-attachments/assets/49710336-6a59-4636-8852-dec1559c3f7e" width="30%" />
  <img src="https://github.com/user-attachments/assets/c3bf9d31-b85d-4040-be2d-67f11ae141a4" width="30%" />
  <img src="https://github.com/user-attachments/assets/78e95b53-42f5-4a2e-8516-ebfda24387d0" width="30%" />
</p>

## 🚀 Funcionalidades

- [x] Criação e edição de exercícios com séries, repetições e carga
- [x] Criação e edição de planos de treino
- [x] Execução de treino com acompanhamento de progresso
- [x] Histórico e visualização gráfica do progresso
- [x] Múltiplos cronômetros integrados
- [x] Tema claro, escuro e sistema
- [x] Armazenamento local utilizando SQLite
- [ ] Página inicial (Home) personalizada
- [ ] Backup em nuvem com Firebase
- [ ] Compartilhamento de treinos e exercícios

## 📦 Instalação

Siga os passos abaixo para rodar o projeto localmente:

### Pré-requisitos
- Flutter instalado 3.7.2 ou superior
- Dispositivo físico ou emulador configurado

### Passos

```bash
# Clone o repositório
git clone https://github.com/LucasKalil-Programador/fit_tracker.git

# Acesse o diretório do projeto
cd fit_tracker

# Instale as dependências
flutter pub get

# Execute o app
flutter run
```

Certifique-se de que um dispositivo/emulador está conectado antes de rodar o flutter run.

# 🛠️ Tecnologias Usadas

- Flutter – SDK principal para desenvolvimento multiplataforma
- Provider – Gerenciamento de estado simples e eficiente
- UUID – Geração de identificadores únicos
- SQFLite – Banco de dados local SQLite
- sqflite_common_ffi – Suporte ao SQLite em plataformas nativas e de desktop
- Flutter Slidable – Ações deslizáveis em listas
- FL Chart – Gráficos interativos e customizáveis
- Logger – Log bonito e estruturado para debugging
- Share Plus – Compartilhamento de conteúdo nativo

# 🔧 Estrutura do Projeto

```bash
lib/
│
├── database/      # Entidades e funções relacionadas ao SQLite
├── states/        # Gerenciamento de estado
├── widgets/       # Componentes visuais reutilizáveis
│   ├── common/    # Widgets comuns e genéricos
│   ├── pages/     # Telas do aplicativo
│   └── ...        # Outros widgets específicos
├── main.dart      # Ponto de entrada da aplicação
└── ...            # Outros arquivos e diretórios
```

```bash
test/ # Testes unitarios
```

# 🧪 Testes

Este projeto possui cobertura parcial de testes unitários para garantir a qualidade do código.

Para executar os testes, use o comando:

```bash
flutter test
```

# 📈 Roadmap

- [ ] Finalizar funcionalidades básicas do app
- [ ] Desenvolver a página Home
- [ ] Implementar testes para UI
- [ ] Integrar com Firebase

# 📄 Licença

MIT © Lucas Guimarães Kalil

