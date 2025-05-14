O objetivo deste arquivo é documentar todo o processo de criação do app com codinome FitTracker.

**Início do projeto: 22/04/2025**

A ideia surgiu a partir de uma necessidade pessoal. Sempre fui muito à academia e, com o tempo, percebi uma deficiência na forma como eu acompanhava meu progresso. Até então, usava o bloco de notas para gerenciar meus treinos — o que, além de ineficiente, dificultava a análise de evolução de carga, frequência de treinos, entre outros. Com o desenvolvimento deste app, além de aprender uma nova stack (Flutter/Dart), estou criando algo que será útil no meu dia a dia.

**Por que optei por Flutter (Dart)?**
Considerei vários fatores, mas o principal foi a facilidade de portar o app para múltiplas plataformas (iOS, Android, Windows, macOS, etc.). Isso torna o projeto mais acessível no futuro, caso eu decida lançá-lo oficialmente. Além disso, o Flutter já entrega um visual moderno, minimalista e leve, o que me agrada bastante.

**Por que não Android Studio (Java)?**
Minha primeira opção foi Android Studio com Java, já que tenho conhecimento avançado na linguagem e já usei essa stack em um projeto da faculdade. Nesse projeto, eu e minha equipe criamos um ciclo computador, que exibia informações como velocidade instantânea, velocidade média, distância percorrida, etc., utilizando GPS.
Repositório do projeto: [CicloComputer](https://github.com/LucasKalil-Programador/CicloComputer)

No entanto, tive uma experiência ruim com a verbosidade do Java e com a estrutura do Android Studio. Isso me motivou a experimentar uma nova linguagem e, assim, expandir meus conhecimentos.

**Situação atual (26/04/2025)**
- O app está parcialmente funcional. Já implementei 4 telas:

- Formulário de criação de exercício

- Formulário de criação de plano de treino

- Tela de treino (exibe o treino ativo)

- Lista de exercícios criados (com opção de editar ou deletar)

**Sobre a persistência de dados**
Implementei um sistema com SQLite, que estava funcionando bem. No entanto, enfrentei problemas por estar implementando o banco de dados ao mesmo tempo que desenvolvia a UI e o controle de estado. Isso gerava dores de cabeça quando precisava de uma nova tabela e já a usava diretamente no código.

Então, dei um passo atrás: irei reescrever todo o banco de dados, com todas as tabelas planejadas e com testes para a maioria dos casos de uso. Com isso, espero ter mais fluidez ao voltar para a parte de UI, já que poderei me concentrar melhor.

## Abaixo estão as tabelas no novo sistema de banco de dados:

- exercise: Representa um exercício individual.

- training_plan: Representa um plano de treino, contendo uma lista de exercícios.

- tag: Cada exercício ou plano de treino pode ser marcado com tags para facilitar a organização.

- metadata: Armazena dados de configuração do sistema.

- report_exercise: Quando um exercício é concluído, o usuário pode registrar seu desempenho, permitindo acompanhar o progresso.

- report_training_plan: Registra o horário de início e fim de um treino, juntamente com informações relacionadas.

- exercise_training_plan: Tabela relacional N:N entre exercícios e planos de treino.

- exercise_tag: Tabela relacional N:N entre exercícios e tags.

- training_plan_tag: Tabela relacional N:N entre planos de treino e tags.

# Dia 26/04/2025

Implementei parte do novo banco de dados e os testes unitários para cada tabela.

- exercise        Implementado
- training_plan   Implementado
- tag             Implementado
- metadata        Implementado
- report_exercise Implementado

Os métodos básicos implementados são:

Insert
delete
update
selectAll
selectOne(id)

# Dia 27/04/2025

Percebi semelhança entre report_exercise e report_training_plan; na prática, são muito similares, diferenciando-se apenas pelo fato de um armazenar um exercício e o outro um plano de treino. Por isso, decidi seguir um caminho unificado, criando apenas um `Report<T>` Nesse modelo, T pode ser Exercise ou TrainingPlan, tornando o código mais flexível e enxuto.

# Dia 29/04/2025

O projeto tem evoluído bem. Atualmente, já temos uma tela onde o usuário pode criar um treino, e é possível ativá-lo ou desativá-lo de forma eficiente. No entanto, tenho enfrentado bastante complexidade ao gerenciar o banco de dados, que é baseado em funções assíncronas. Isso tem causado diversos problemas de sincronização entre os estados e o que é exibido para o usuário. Por isso, decidi criar uma branch separada para testar uma abordagem diferente: usar um banco de dados baseado em um grande JSON que armazene todos os dados. A ideia é reduzir a complexidade. Se essa solução se mostrar vantajosa, pretendo seguir por esse caminho.

# 01/05/2025
Atualmente, o projeto já conta com duas telas totalmente implementadas:

1. Tela de Exercícios – permite listar, adicionar, editar e deletar exercícios. Também inclui um sistema de busca por nome, número de séries, peso e outros critérios.

2. Tela de Plano de Treinamento – o usuário pode montar um plano completo, selecionar os exercícios desejados e iniciar o treino. Um cronômetro integrado auxilia no controle do tempo de treino.

Tudo isso já está funcionando com persistência de dados, utilizando um banco de dados para salvar e carregar as informações.

Neste momento, estou pesquisando pacotes para personalizar ainda mais o app, como bibliotecas de gráficos, animações personalizadas, etc.

Lista de bibliotecas relevantes:

- [shimmer](https://pub.dev/packages/shimmer) efeito de carregamento com animação de brilho 
- [fl_chart](https://pub.dev/packages/fl_chart) exibição de gráficos leves e customizáveis
- [syncfusion_flutter_charts](https://pub.dev/packages/syncfusion_flutter_charts) gráficos avançados e completos
- [lottie](https://pub.dev/packages/lottie) animações vetoriais em JSON de alta qualidade
- [google_fonts](https://pub.dev/packages/google_fonts) fácil uso de fontes do Google
- [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) criação de grids com layouts irregulares
- [flutter_animate](https://pub.dev/packages/flutter_animate)  animações simples, suaves e fáceis de usar
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) notificações locais ricas e customizáveis
- [percent_indicator](https://pub.dev/packages/percent_indicator) barras circulares e lineares de progresso
- [flutter_slidable](https://pub.dev/packages/flutter_slidable) ações deslizáveis em listas
- [image_picker](https://pub.dev/packages/image_picker) captura ou seleção de imagens da galeria/câmera

Essa foi uma pesquisa rápida, e até agora os pacotes que mais chamaram minha atenção foram:

- Bibliotecas de gráficos: uma das funcionalidades que quero no projeto é permitir que o usuário acompanhe seu progresso ao longo do tempo. A melhor forma de fazer isso é através de visualizações gráficas, então com certeza vou utilizar uma das bibliotecas que encontrei.

- Shimmer: apesar de o app não ter problemas de carregamento, adicionar uma animação de placeholder deixa a experiência mais polida e agradável.

- Flutter Staggered Grid: permite criar layouts irregulares. Achei interessante para a tela principal (home), pois pode deixar o visual mais dinâmico e atrativo.

- 03/05/2025

Implementei algumas das bibliotecas mencionadas anteriormente para o treino. Usei o flutter_slidable para criar uma interface mais bonita e fácil de usar, com os botões delete, edit e start ocultos atrás do card. Também implementei o percent_indicator, que exibe uma barra de progresso atualizada conforme o usuário completa os exercícios durante o treino. Além disso, embora ainda não tenha implementado, já preparei um modelo padrão com o fl_chart, incluindo todos os elementos necessários para o sistema. O design foi baseado no Sample 5 do site oficial, com algumas adaptações para melhor atender ao meu caso.

- 07/05/2025

Criei a tela de estatísticas. Ela possui:

- Um DropdownButton para selecionar a tabela a ser exibida;
- Um gráfico com os dados da tabela selecionada;
- Três botões de filtro (7 dias, 30 dias e "lifetime") para definir o intervalo de dados exibidos;
- Uma tabela com ordenação por coluna e seleção manual de dados a serem exibidos.

Próximos passos para essa tela:

- Adicionar botão para nova entrada;
- Criar formulário para adicionar entrada;
- Criar formulário para criar e editar tabelas.

- 14/05/2025

Diversas alterações foram feitas, entre elas a separação da tela de cronômetro da tela de treino. Anteriormente, o cronômetro ficava posicionado acima do treino. Para melhorar o layout e a funcionalidade, optei por colocá-lo em uma tela separada, o que possibilitou a implementação de um sistema mais eficiente.