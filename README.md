# 📱 FitTracker

![Flutter](https://img.shields.io/badge/Flutter-3.7.2-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue?logo=dart)
![Platform](https://img.shields.io/badge/Plataforma-Android%20%7C%20iOS-green)
![Firebase](https://img.shields.io/badge/Firebase-Integrado-orange?logo=firebase)
![Version](https://img.shields.io/badge/Vers%C3%A3o-1.0.1-blue)
![License](https://img.shields.io/badge/Licen%C3%A7a-MIT-yellow)
![Status](https://img.shields.io/badge/Status-Lan%C3%A7ado-brightgreen)

**FitTracker é um aplicativo criado com o objetivo de auxiliar no planejamento e na execução de treinos, com foco principal em academias. A ideia surgiu por motivação pessoal, e todas as funcionalidades foram pensadas por um desenvolvedor que realmente utiliza o app no dia a dia. O app foi lançado em sua primeira versão estável (v1.0.1), com todas as funcionalidades principais implementadas, sistema de backup em nuvem e conformidade com LGPD.**

---

# Índice

- [📱 FitTracker](#-fittracker)
- [📸 Demonstrações](#-demonstrações)
  - [🔐 Autenticação](#-autenticação)
  - [🏠 Tela Inicial (Home)](#-tela-inicial-home)
  - [🏋️‍♂️ Gestão de Treinos](#️-gestão-de-treinos)
  - [🧩 Gestão de Exercícios](#-gestão-de-exercícios)
  - [📈 Acompanhamento de Progresso](#-acompanhamento-de-progresso)
  - [⏱️ Cronômetro](#️-cronômetro)
  - [⚙️ Configurações](#️-configurações)
  - [🌓 Temas e 🌍 Idiomas](#-temas-e--idiomas)
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

---

# 📸 Demonstrações

## 🔐 Autenticação

**Sistema completo de autenticação com Google, garantindo segurança e facilidade de acesso.**

<p align="center">
  <img src="https://github.com/user-attachments/assets/1f40cef6-5edd-4a83-ad89-b1a52335843d" width="30%" />
  <img src="https://github.com/user-attachments/assets/a6864d9e-345b-4178-8b73-3b2d157c7c3f" width="30%" />
  <img src="https://github.com/user-attachments/assets/f0db4811-195a-4876-9d29-8951499f6fa1" width="30%" />
</p>

- **Primeira imagem**: Tela inicial com opção de login via Google
- **Segunda imagem**: Processo de autenticação do Google
- **Terceira imagem**: Opções de sincronização com nuvem após login

---

## 🏠 Tela Inicial (Home)

**Dashboard completo com visão geral dos treinos, estatísticas e histórico de atividades.**

<p align="center">
  <img src="https://github.com/user-attachments/assets/8c1aa87a-13c0-4954-9817-a6d4c1b97fae" width="30%" />
  <img src="https://github.com/user-attachments/assets/be78ad43-b112-42ea-b694-2d7c628c609f" width="30%" />
  <img src="https://github.com/user-attachments/assets/2b7cb2ec-2b13-4929-9dd2-5c0b8d05e8a7" width="30%" />
</p>

- **Primeira imagem**: Tela inicial com cards de resumo e acesso rápido
- **Segunda imagem**: Histórico detalhado de treinos realizados
- **Terceira imagem**: Calendário de treinos com visualização mensal

---

## 🏋️‍♂️ Gestão de Treinos

**Criação, edição e execução de treinos personalizados com acompanhamento em tempo real.**

<p align="center">
  <img src="https://github.com/user-attachments/assets/78a24d6e-3520-4bd2-9ad7-1a4ad963a77f" width="30%" />
  <img src="https://github.com/user-attachments/assets/95702933-2b7d-40a7-bd6f-387a6195d06b" width="30%" />
  <img src="https://github.com/user-attachments/assets/119141cd-d5b3-4b55-a1d7-b7b7edd37ca2" width="30%" />
</p>

- **Primeira imagem**: Interface de criação de treino com seleção de exercícios
- **Segunda imagem**: Lista de treinos salvos com prévia dos exercícios
- **Terceira imagem**: Treino em execução com marcação de exercícios concluídos

<p align="center">
  <img src="https://github.com/user-attachments/assets/211615d5-213b-42ff-bbdd-1a24fdc1fc79" width="30%" />
</p>

- **Configuração de sequência**: Define quais dias da semana serão considerados para calcular a sequência de treinos

---

## 🧩 Gestão de Exercícios

**Biblioteca completa de exercícios personalizáveis para musculação e cardio.**

<p align="center">
  <img src="https://github.com/user-attachments/assets/40fdf9be-79ae-4331-bc52-8ec2431d997f" width="30%" />
  <img src="https://github.com/user-attachments/assets/4d63caa8-d6a5-4814-a694-f29f72c96a63" width="30%" />
</p>

- **Primeira imagem**: Lista de exercícios com opções de edição e exclusão (deslize lateral)
- **Segunda imagem**: Formulário de criação de novo exercício com séries, repetições e carga

---

## 📈 Acompanhamento de Progresso

**Sistema completo de tracking com gráficos e tabelas para visualização da evolução.**

<p align="center">
  <img src="https://github.com/user-attachments/assets/16507695-9497-47bc-83c5-c387b0f1d961" width="30%" />
  <img src="https://github.com/user-attachments/assets/da33e819-ca86-403c-99b8-37a2ea795e54" width="30%" />
  <img src="https://github.com/user-attachments/assets/be13040e-d1cf-4aa1-9703-f8b104747383" width="30%" />
</p>

- **Primeira imagem**: Criação de nova tabela de progresso personalizada
- **Segunda imagem**: Visualização detalhada dos registros em tabela
- **Terceira imagem**: Formulário para adicionar novo registro de progresso

<p align="center">
  <img src="https://github.com/user-attachments/assets/f30f4272-8991-4709-bf29-5e6a9ea440dd" width="30%" />
</p>

- **Gráfico de evolução**: Visualização gráfica do progresso ao longo do tempo

---

## ⏱️ Cronômetro

**Cronômetro integrado para controle de intervalos e tempos de treino.**

<p align="center">
  <img src="https://github.com/user-attachments/assets/c0d190df-c1b3-4511-a81a-8a000c7e83a8" width="30%" />
  <img src="https://github.com/user-attachments/assets/47db4618-bdaf-4afa-bed1-af33f5970cc8" width="30%" />
</p>

- **Primeira imagem**: Cronômetro em execução
- **Segunda imagem**: Cronômetro pausado com controles de play/pause/reset

---

## ⚙️ Configurações

**Painel completo de configurações com gerenciamento de conta, dados e preferências.**

<p align="center">
  <img src="https://github.com/user-attachments/assets/c7d8c89b-f540-438a-aa36-85de5fc29d71" width="30%" />
  <img src="https://github.com/user-attachments/assets/0395df17-df42-4d60-b0f8-2624747f1793" width="30%" />
  <img src="https://github.com/user-attachments/assets/2858c9f6-3d6a-45b3-bf37-a83f91f79a1d" width="30%" />
</p>

- **Primeira imagem**: Menu de configurações principal
- **Segunda imagem**: Configurações com conta Google logada e opções de sincronização
- **Terceira imagem**: Termos de uso e políticas de privacidade (conformidade LGPD)

---

## 🌓 Temas e 🌍 Idiomas

**Suporte completo para temas claro/escuro e múltiplos idiomas (PT-BR e EN).**

### Tema Claro

<p align="center">
  <img src="https://github.com/user-attachments/assets/c64ebc36-076c-4c58-8543-0b2dcbe7205a" width="24%" />
  <img src="https://github.com/user-attachments/assets/25894825-f996-4faf-8da2-5b63eda85314" width="24%" />
  <img src="https://github.com/user-attachments/assets/0635b4d3-bb69-45c6-89cc-b247acbec436" width="24%" />
  <img src="https://github.com/user-attachments/assets/a3db51f8-031e-4d24-bb50-99f67c3e8afa" width="24%" />
</p>

### Internacionalização

<p align="center">
  <img src="https://github.com/user-attachments/assets/fb432e0d-6290-4163-b041-37aa343f9b0c" width="30%" />
  <img src="https://github.com/user-attachments/assets/e96a62db-e099-4901-9763-db19f26c5b29" width="30%" />
  <img src="https://github.com/user-attachments/assets/ca9a095d-ddf6-43c0-9010-f62e055510ce" width="30%" />
</p>

- Interface completamente traduzida para Português (Brasil) e Inglês
- Troca de idioma em tempo real sem necessidade de reiniciar o app

---

## 🚀 Funcionalidades

- [x] Criação e edição de exercícios com séries, repetições e carga
- [x] Criação e edição de planos de treino personalizados
- [x] Execução de treino com acompanhamento de progresso em tempo real
- [x] Histórico completo e calendário de treinos
- [x] Sistema de tracking com gráficos e tabelas customizáveis
- [x] Múltiplos cronômetros integrados
- [x] Temas claro, escuro e automático (sistema)
- [x] Suporte completo para Português (Brasil) e Inglês
- [x] Armazenamento local com SQLite
- [x] Autenticação segura com Google (Firebase Auth)
- [x] Backup automático e sincronização em nuvem (Firestore)
- [x] Import/Export de dados em JSON
- [x] Página inicial (Home) com dashboard personalizado
- [x] Conformidade com LGPD
- [x] Termos de uso e políticas de privacidade detalhados
- [ ] Compartilhamento de treinos e exercícios entre usuários

---

## 📦 Instalação

### Pré-requisitos
- Flutter 3.7.2 ou superior
- Dispositivo físico ou emulador configurado
- Conta Firebase (para autenticação e backup)

### Passos

```bash
# Clone o repositório
git clone https://github.com/LucasKalil-Programador/fit_tracker.git

# Acesse o diretório do projeto
cd fit_tracker

# Instale as dependências
flutter pub get

# Configure o Firebase
# Adicione google-services.json (Android) em android/app/
# Adicione GoogleService-Info.plist (iOS) em ios/Runner/

# Execute o app
flutter run
```

**Nota**: Para configurar o Firebase, você precisará criar um projeto no [Firebase Console](https://console.firebase.google.com/) e baixar os arquivos de configuração específicos da plataforma.

---

## 🛠️ Tecnologias Usadas

### Core
- **Flutter** – SDK multiplataforma (v3.7.2+)
- **Dart** – Linguagem de programação (v3.0+)

### Gerenciamento de Estado
- **Provider** – State management simples e eficiente

### Backend & Cloud
- **Firebase Auth** – Autenticação com Google
- **Cloud Firestore** – Banco de dados em nuvem NoSQL
- **Firebase Core** – Integração base do Firebase

### Armazenamento Local
- **SQFLite** – Banco de dados SQLite local
- **sqflite_common_ffi** – Suporte FFI para SQLite em desktop

### UI/UX
- **Flutter Slidable** – Ações deslizáveis em listas
- **FL Chart** – Gráficos interativos e customizáveis

### Utilitários
- **UUID** – Geração de identificadores únicos
- **Logger** – Sistema de logs estruturado
- **Share Plus** – Compartilhamento nativo de conteúdo
- **Intl** – Internacionalização e formatação

---

## 🔧 Estrutura do Projeto

```bash
lib/
│
├── database/          # Camada de persistência (SQLite)
│   ├── entities/      # Modelos de dados
│   └── repositories/  # Lógica de acesso aos dados
│
├── services/          # Serviços externos
│   ├── firebase/      # Integração Firebase (Auth, Firestore)
│   └── storage/       # Gerenciamento de armazenamento
│
├── states/            # Gerenciamento de estado (Provider)
│
├── l10n/              # Internacionalização
│   ├── intl_en.arb    # Strings em Inglês
│   └── intl_pt.arb    # Strings em Português
│
├── widgets/           # Componentes visuais
│   ├── common/        # Widgets reutilizáveis
│   ├── pages/         # Telas principais
│   └── dialogs/       # Diálogos e modals
│
├── utils/             # Utilitários e helpers
│
└── main.dart          # Entry point da aplicação
```

```bash
test/                  # Testes unitários e de integração
```

---

## 🧪 Testes

O projeto possui cobertura de testes unitários para garantir a qualidade e confiabilidade do código.

### Executar testes

```bash
# Todos os testes
flutter test

# Com coverage
flutter test --coverage

# Teste específico
flutter test test/database/entities_test.dart
```

---

## 🔒 Privacidade e Segurança

O FitTracker leva a privacidade dos usuários a sério e está em **total conformidade com a LGPD** (Lei Geral de Proteção de Dados).

### Dados Coletados
- **Informações de treino**: exercícios, séries, repetições, cargas
- **Métricas de progresso**: registros customizados pelo usuário
- **Dados de autenticação**: email e nome (via Google Auth)

### Compromissos
- ✅ Dados armazenados localmente por padrão (SQLite)
- ✅ Backup em nuvem **opcional** e criptografado
- ✅ Autenticação segura via OAuth 2.0 (Google)
- ✅ Nenhum compartilhamento com terceiros
- ✅ Controle total: exportação e exclusão de dados a qualquer momento
- ✅ Transparência: Termos de Uso e Política de Privacidade disponíveis no app

Para mais detalhes, consulte nossos documentos legais dentro do aplicativo.

---

## 🌍 Internacionalização

O FitTracker oferece suporte completo para:

- 🇧🇷 **Português (Brasil)**
- 🇺🇸 **English (United States)**

### Características
- Troca de idioma em tempo real (sem reinicialização)
- Formatação de datas e números localizada
- Interface 100% traduzida
- Detecção automática do idioma do sistema

---

## 📈 Roadmap

### ✅ Versão 1.0.1 (Atual - Lançamento)
- [x] Sistema completo de treinos e exercícios
- [x] Tracking de progresso com gráficos
- [x] Integração completa com Firebase
- [x] Autenticação Google
- [x] Backup e sincronização automática
- [x] Suporte PT-BR e EN
- [x] Conformidade LGPD
- [x] Temas claro/escuro

### 🚧 Próximas Versões

#### v1.1.0 - Social Features
- [ ] Compartilhamento de treinos entre usuários
- [ ] Comunidade de exercícios
- [ ] Sistema de likes/favoritos

#### v1.2.0 - Smart Features
- [ ] Notificações push de lembretes
- [ ] Sugestões de treinos baseadas em histórico
- [ ] Integração com wearables (Wear OS, Apple Watch)

#### v1.3.0 - Enhanced Analytics
- [ ] Relatórios mensais detalhados
- [ ] Comparativo de períodos
- [ ] Metas e objetivos customizáveis

#### Backlog
- [ ] Modo offline aprimorado com sync inteligente
- [ ] Mais idiomas (ES, FR, DE)
- [ ] Integração com apps de saúde (Google Fit, Apple Health)
- [ ] Planos de treino pré-definidos
- [ ] Sistema de conquistas/badges

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Se você encontrou um bug ou tem uma sugestão:

1. Abra uma [Issue](https://github.com/LucasKalil-Programador/fit_tracker/issues)
2. Faça um Fork do projeto
3. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
4. Commit suas mudanças (`git commit -m 'Add: Nova funcionalidade'`)
5. Push para a branch (`git push origin feature/MinhaFeature`)
6. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

```
MIT License

Copyright (c) 2025 Lucas Guimarães Kalil

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## ✒️ Autor

**Lucas Guimarães Kalil**

Desenvolvedor Full Stack apaixonado por criar soluções que realmente fazem diferença no dia a dia das pessoas.

📧 **E-mail**: lucas.prokalil2020@outlook.com  
💼 **LinkedIn**: [lucas-kalil-436a6220a](https://www.linkedin.com/in/lucas-kalil-436a6220a/)  
🐙 **GitHub**: [@LucasKalil-Programador](https://github.com/LucasKalil-Programador)

---

<p align="center">
  Feito com ❤️ e ☕ por Lucas Kalil
</p>

<p align="center">
  Se o FitTracker te ajudou, deixe uma ⭐ no repositório!
</p>