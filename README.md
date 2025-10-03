# 📱 FitTracker

![Flutter](https://img.shields.io/badge/Flutter-3.7.2-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue?logo=dart)
![Platform](https://img.shields.io/badge/Plataforma-Android%20%7C%20iOS-green)
![Firebase](https://img.shields.io/badge/Firebase-Integrado-orange?logo=firebase)
![Version](https://img.shields.io/badge/Vers%C3%A3o-1.0.1-blue)
![License](https://img.shields.io/badge/Licen%C3%A7a-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Lan%C3%A7ado-brightgreen)

**FitTracker é um aplicativo criado com o objetivo de auxiliar no planejamento e na execução de treinos, com foco principal em academias. A ideia surgiu por motivação pessoal, e todas as funcionalidades foram pensadas por um desenvolvedor que realmente utiliza o app no dia a dia. O app foi lançado em sua primeira versão estável (v1.0.1), com todas as funcionalidades principais implementadas, sistema de backup em nuvem e conformidade com LGPD.**

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
- [🔒 Privacidade e Segurança](#-privacidade-e-segurança)
- [🌍 Internacionalização](#-internacionalização)
- [📈 Roadmap](#-roadmap)
- [📄 Licença](#-licença)
- [✒️ Autor](#️-autor)

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

**Na tela de configurações, existem quatro áreas principais:**

1. Tema: permite ao usuário escolher entre os modos claro, escuro ou seguir o tema do sistema, ajustando o esquema de cores para melhor visualização em diferentes situações.

2. Idioma: suporte completo para Português (Brasil) e Inglês, com troca dinâmica do idioma em tempo real.

3. Dados: oferece a opção de importar e exportar os dados do aplicativo em formato .json, facilitando backups locais ou migração. Integração com Firebase para backup automático em nuvem.

4. Conta: gerenciamento de autenticação com Google, visualização de termos de uso e políticas de privacidade.

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
- [x] Suporte completo para Português (Brasil) e Inglês
- [x] Armazenamento local utilizando SQLite
- [x] Autenticação com Google (Firebase Auth)
- [x] Backup em nuvem com Firebase Firestore
- [x] Sincronização automática de dados entre dispositivos
- [x] Página inicial (Home) personalizada
- [x] Conformidade com LGPD
- [x] Termos de uso e políticas de privacidade
- [ ] Compartilhamento de treinos e exercícios

## 📦 Instalação

Siga os passos abaixo para rodar o projeto localmente:

### Pré-requisitos
- Flutter instalado 3.7.2 ou superior
- Dispositivo físico ou emulador configurado
- Conta Firebase configurada (para funcionalidades de autenticação e backup)

### Passos

```bash
# Clone o repositório
git clone https://github.com/LucasKalil-Programador/fit_tracker.git

# Acesse o diretório do projeto
cd fit_tracker

# Instale as dependências
flutter pub get

# Configure o Firebase (adicione google-services.json para Android e GoogleService-Info.plist para iOS)

# Execute o app
flutter run
```

Certifique-se de que um dispositivo/emulador está conectado antes de rodar o flutter run.

# 🛠️ Tecnologias Usadas

- **Flutter** – SDK principal para desenvolvimento multiplataforma
- **Provider** – Gerenciamento de estado simples e eficiente
- **Firebase Auth** – Autenticação com Google
- **Cloud Firestore** – Banco de dados em nuvem para backup e sincronização
- **UUID** – Geração de identificadores únicos
- **SQFLite** – Banco de dados local SQLite
- **sqflite_common_ffi** – Suporte ao SQLite em plataformas nativas e de desktop
- **Flutter Slidable** – Ações deslizáveis em listas
- **FL Chart** – Gráficos interativos e customizáveis
- **Logger** – Log estruturado para debugging
- **Share Plus** – Compartilhamento de conteúdo nativo
- **Intl** – Internacionalização e suporte a múltiplos idiomas

# 🔧 Estrutura do Projeto

```bash
lib/
│
├── database/      # Entidades e funções relacionadas ao SQLite
├── states/        # Gerenciamento de estado
├── services/      # Integração com Firebase e outros serviços
├── l10n/          # Arquivos de internacionalização (pt-BR e en)
├── widgets/       # Componentes visuais reutilizáveis
│   ├── common/    # Widgets comuns e genéricos
│   ├── pages/     # Telas do aplicativo
│   └── ...        # Outros widgets específicos
├── main.dart      # Ponto de entrada da aplicação
└── ...            # Outros arquivos e diretórios
```

```bash
test/ # Testes unitários
```

# 🧪 Testes

Este projeto possui cobertura parcial de testes unitários para garantir a qualidade do código.

Para executar os testes, use o comando:

```bash
flutter test
```

# 🔒 Privacidade e Segurança

O FitTracker leva a privacidade dos usuários a sério e está em conformidade com a LGPD (Lei Geral de Proteção de Dados). O aplicativo:

- Coleta apenas dados essenciais para funcionamento (informações de treino, exercícios e progresso)
- Utiliza autenticação segura via Google (Firebase Auth)
- Armazena dados localmente no dispositivo por padrão
- Oferece backup opcional em nuvem com criptografia
- Não compartilha dados com terceiros
- Fornece controle total ao usuário sobre seus dados (exportação e exclusão)

Os Termos de Uso e Políticas de Privacidade estão disponíveis dentro do aplicativo e descrevem detalhadamente como os dados são coletados, armazenados e utilizados.

# 🌍 Internacionalização

O FitTracker oferece suporte completo para dois idiomas:

- 🇧🇷 Português (Brasil)
- 🇺🇸 Inglês (English)

A troca de idioma é dinâmica e pode ser feita em tempo real através das configurações do app, sem necessidade de reiniciar o aplicativo.

# 📈 Roadmap

### Versão 1.0.1 (Atual - Lançamento) ✅
- [x] Todas as funcionalidades básicas implementadas
- [x] Integração completa com Firebase
- [x] Autenticação com Google
- [x] Backup e sincronização em nuvem
- [x] Suporte a PT-BR e EN
- [x] Conformidade com LGPD
- [x] Termos de uso e políticas de privacidade

### Próximas Versões
- [ ] Compartilhamento de treinos e exercícios entre usuários
- [ ] Notificações push para lembretes de treino
- [ ] Integração com wearables (smartwatches)
- [ ] Modo offline aprimorado
- [ ] Testes de UI automatizados
- [ ] Suporte a mais idiomas

# 📄 Licença

MIT © Lucas Guimarães Kalil

# ✒️ Autor

Lucas Guimarães Kalil 

E-Mail - lucas.prokalil2020@outlook.com

[Linkedin](https://www.linkedin.com/in/lucas-kalil-436a6220a/) | [GitHub](https://github.com/LucasKalil-Programador)