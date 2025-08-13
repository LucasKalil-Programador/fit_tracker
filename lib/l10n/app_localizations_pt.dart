// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get progressStats => 'Progresso & Estatistica';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Deletar';

  @override
  String get selectOrCreateTable => 'Selecione uma tabela ou crie uma';

  @override
  String get createNewTable => 'Criar nova tabela';

  @override
  String get selectTable => 'Selecione uma tabela';

  @override
  String get addedSuccess => 'Adicionado com sucesso!';

  @override
  String get deletedSuccess => 'Deletado com sucesso';

  @override
  String get removedSuccess => 'Removido com sucesso!';

  @override
  String get timer => 'Cronômetro';

  @override
  String get reset => 'Reiniciar';

  @override
  String get start => 'Iniciar';

  @override
  String get resume => 'Retomar';

  @override
  String get pause => 'Pausar';

  @override
  String get exerciseList => 'Lista de Exercicio';

  @override
  String get search => 'Pesquisa';

  @override
  String get editedSuccess => 'Editado com sucesso!';

  @override
  String get editError => 'Error ao editar!';

  @override
  String get createPlan => 'Criação de plano de treino';

  @override
  String get createWorkout => 'Criar treino';

  @override
  String get editWorkout => 'Editar treino';

  @override
  String get selectExercises => 'Selecione os exercícios';

  @override
  String get name => 'Nome';

  @override
  String get invalidName => 'Nome Invalido';

  @override
  String get dark => 'Escuro';

  @override
  String get light => 'Claro';

  @override
  String get system => 'Sistema';

  @override
  String get theme => 'Tema';

  @override
  String get defaultOption => 'Default';

  @override
  String get devTools => 'Dev tools';

  @override
  String get clearAllData => 'Limpar TODOS os dados';

  @override
  String get generateDemoData => 'Gerar dados de demonstração';

  @override
  String get loadWorkoutError => 'Erro ao carregar o treino';

  @override
  String get workout => 'Treino';

  @override
  String get createPlanButton => 'Criar plano';

  @override
  String get finishPlan => 'Finalizar plano';

  @override
  String get noPlansMessage => 'Você ainda não tem nenhum plano de treino. \nToque em \'Criar plano\' para começar.';

  @override
  String get settings => 'Configurações';

  @override
  String get data => 'Dados';

  @override
  String get exportData => 'Exportar dados';

  @override
  String get fittrackerBackup => 'fittracker backup';

  @override
  String get weight => 'Peso';

  @override
  String get kg => 'Kg';

  @override
  String get invalidValue => 'Valor invalido';

  @override
  String get minutes => 'Minutos';

  @override
  String get exercisesLabel => 'Exercícios: ';

  @override
  String get emptyList => 'Lista vazia';

  @override
  String get createExercise => 'Criação de exercício';

  @override
  String get editExercise => 'Editar exercício';

  @override
  String get strength => 'Musculação';

  @override
  String get cardio => 'Cardio';

  @override
  String get weightLoad => 'Carga';

  @override
  String get time => 'Tempo';

  @override
  String get reps => 'Qtd. de repetições';

  @override
  String get sets => 'Qtd. de séries';

  @override
  String get add => 'Adicionar';

  @override
  String get fullTable => 'Tabela completa';

  @override
  String get chartSelectionInfo => 'Os itens selecionados serão exibidos no gráfico';

  @override
  String get date => 'Data';

  @override
  String get dateHint => 'Data em que o valor foi registrado';

  @override
  String get value => 'Valor';

  @override
  String get valueHint => 'Valor registrado';

  @override
  String get note => 'Anotação';

  @override
  String get noteHint => 'Observação adicionada pelo usuário';

  @override
  String get deleteReport => 'Deleta o reporte';

  @override
  String get fullNote => 'Anotação completa';

  @override
  String get close => 'Fechar';

  @override
  String get reportValue => 'Reportar valor';

  @override
  String get notes => 'Notas';

  @override
  String get invalidNote => 'Nota Invalida';

  @override
  String get createProgressTable => 'Criar tabela de progresso';

  @override
  String get description => 'Descrição';

  @override
  String get invalidDescription => 'Descrição invalida';

  @override
  String get valueSuffix => 'Sufixo do valor exemplo: (15 Kg)';

  @override
  String get invalidSuffix => 'Sufixo Invalido';

  @override
  String get interactiveChart => 'Gráfico interativo';

  @override
  String get last7Days => 'Últimos 7 dias';

  @override
  String get last30Days => 'Últimos 30 dias';

  @override
  String get sinceBeginning => 'Desde o início';

  @override
  String get importError => 'Erro ao tentar importar dados';

  @override
  String get importData => 'Importar dados';

  @override
  String get dataLoadedSuccess => 'Dados carregados com sucesso!\n\n';

  @override
  String get totalData => 'Total de dados:\n';

  @override
  String get importReplace => 'Importar substituir';

  @override
  String get importMerge => 'Importar adicionar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get homeNavBar => 'Home';

  @override
  String get timerNavBar => 'Timer';

  @override
  String get trainNavBar => 'Treinar';

  @override
  String get exercisesNavBar => 'Exercícios';

  @override
  String get progressNavBar => 'Progresso';

  @override
  String get configNavBar => 'Config';

  @override
  String importSummary(Object exercises, Object plans, Object tables, Object reports) {
    return '• Exercícios: $exercises\n• Planos: $plans\n• Tabelas: $tables\n• Relatórios: $reports';
  }

  @override
  String get languageTitle => 'Idioma';

  @override
  String get portugueseLanguage => 'Português';

  @override
  String get englishLanguage => 'Inglês';
}
