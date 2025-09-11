import 'package:flutter/material.dart';

class FitTrackerTermsPage extends StatelessWidget {
  final Function? onAccepted;
  final Function? onRejected;

  const FitTrackerTermsPage({super.key, required this.onAccepted, required this.onRejected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Termos de Uso & Política de Privacidade"),
      ),
      bottomNavigationBar: RequestBottom(
        onPressed: (accepted) {
          if (accepted) {
            if(onAccepted != null) onAccepted!();
          } else {
            if(onRejected != null) onRejected!();
          }
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 32),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(Theme.of(context).colorScheme),
                  const SizedBox(height: 20),
                  
                  // Termos de Uso
                  _buildTermsSection(Theme.of(context).colorScheme),
                  const SizedBox(height: 18),
                  
                  // Política de Privacidade
                  _buildPrivacySection(Theme.of(context).colorScheme),
                  const SizedBox(height: 18),
                  
                  // Licenças
                  _buildLicensesSection(Theme.of(context).colorScheme),
                  const SizedBox(height: 18),
                  
                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme scheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            
          ),
          child: const Center(
            child: Text(
              'FT',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Header Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FitTracker — Termos de Uso & Política de Privacidade',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Documento público para uso na Play Store / App Store — Última atualização: 11/09/2025',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildChip('Login: Google Sign-In', scheme),
                  _buildChip('Armazenamento: Firebase (Google Cloud)', scheme),
                  _buildChip('Idade mínima: 13+', scheme),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String text, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.03),
          width: 3
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildSection(ColorScheme scheme, {required String title, required String emoji, String? subtitle, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$emoji $title',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildTermsSection(ColorScheme scheme) {
    return _buildSection(
      scheme,
      title: 'Termos de Uso',
      emoji: '📜',
      subtitle: 'Leia com atenção — o uso do aplicativo implica aceitação destes termos.',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderedListItem('1', 'Aceitação dos Termos', 'Ao usar o FitTracker, você concorda com estes Termos. Caso não concorde, não utilize o aplicativo.'),
          _buildOrderedListItem('2', 'Objetivo do Aplicativo', 'O FitTracker é uma ferramenta de acompanhamento de treinos e progresso físico. Não substitui orientação médica ou profissional de educação física.'),
          _buildOrderedListItem('3', 'Login e Conta', 'O login no FitTracker é feito exclusivamente por meio da sua conta Google. Não solicitamos criação de conta própria dentro do app. A responsabilidade pelo acesso à sua conta Google é exclusivamente sua.'),
          _buildOrderedListItem('4', 'Uso Responsável', 'Você é responsável pelas informações e dados inseridos no app. Não utilize o FitTracker para práticas ilegais ou que possam comprometer sua saúde.'),
          _buildOrderedListItem('5', 'Idade Mínima', 'O FitTracker é destinado a usuários com 13 anos ou mais.'),
          _buildOrderedListItem('6', 'Limitação de Responsabilidade', 'O FitTracker não garante resultados de saúde ou condicionamento físico. Ele serve apenas como ferramenta de registro e acompanhamento.'),
          _buildOrderedListItem('7', 'Modificações', 'Podemos atualizar estes Termos a qualquer momento. O uso contínuo do app significa que você aceita as mudanças.'),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(ColorScheme scheme) {
    return _buildSection(
      scheme,
      title: 'Política de Privacidade',
      emoji: '🔒',
      subtitle: 'Transparência sobre quais dados coletamos e como são usados.',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubSection('1. Dados Coletados', [
            'O FitTracker coleta apenas os seguintes dados:',
            '• ID de usuário do Google (fornecida pelo login via Google Sign-In).',
            '• Dados gerados pelo uso do app (ex.: treinos, metas, progresso, estatísticas de uso dentro do app).',
            '',
            'Não coletamos nome, e-mail, telefone ou outros dados pessoais diretamente.',
          ]),
          
          _buildSubSection('2. Uso das Informações', [
            '• Identificar sua conta dentro do aplicativo.',
            '• Salvar e sincronizar seus treinos e progresso entre dispositivos.',
            '• Melhorar a experiência e corrigir problemas técnicos.',
          ]),
          
          _buildSubSection('3. Serviços de Terceiros', [
            'O FitTracker utiliza serviços do Google para autenticação e armazenamento:',
            '• Google Sign-In — usado apenas para autenticação.',
            '• Firebase (Google Cloud) — usado para armazenar os dados do app.',
            '',
            'O uso desses serviços está sujeito à Política de Privacidade do Google.',
          ]),
          
          _buildSubSection('4. Compartilhamento de Dados', [
            'Os dados não são vendidos nem compartilhados com terceiros, exceto quando exigido por lei ou para cumprir ordens judiciais.',
          ]),
          
          _buildSubSection('5. Armazenamento e Segurança', [
            'As informações são armazenadas em servidores do Firebase (Google Cloud). Empregamos medidas técnicas e organizacionais para proteger os dados, mas nenhum sistema é 100% seguro.',
          ]),
          
          _buildSubSection('6. Exclusão de Conta e Dados', [
            'Você pode solicitar a exclusão da sua conta e dos seus dados a qualquer momento. Para isso, envie um e-mail para:',
          ]),
          
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'lucas.prokalil2020@outlook.com',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
              ),
            ),
          ),
          
          const Text(
            'Após a solicitação podemos levar até 30 dias para remover backups e réplicas, conforme práticas técnicas e legais.',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
          
          _buildSubSection('7. Alterações nesta Política', [
            'Podemos atualizar esta Política. Notificaremos os usuários por meio do app ou por e-mail quando mudanças relevantes ocorrerem.',
          ]),
          
          _buildSubSection('8. Contato', [
            'Dúvidas ou solicitações sobre privacidade: lucas.prokalil2020@outlook.com',
          ]),
        ],
      ),
    );
  }

  Widget _buildLicensesSection(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Licenças das Bibliotecas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildLicenseSection('Licença MIT', [
            'cupertino_icons',
            'provider',
            'uuid',
            'flutter_slidable',
            'flutter_staggered_grid_view',
            'fl_chart',
            'synchronized',
            'logger',
            'archive',
            'flutter_svg',
            'sqflite_sqlcipher',
          ]),
          
          _buildLicenseSection('Licença BSD de 2 cláusulas', [
            'sqflite',
            'sqflite_common_ffi',
            'percent_indicator',
            'sqflite_common_ffi_web',
            'tuple',
            'sqflite_common',
          ]),
          
          _buildLicenseSection('Licença BSD de 3 cláusulas', [
            'path',
            'shimmer',
            'share_plus',
            'path_provider',
            'intl',
            'firebase_core',
            'firebase_auth',
            'google_sign_in',
            'loading_animation_widget',
            'cloud_firestore',
            'crypto',
            'connectivity_plus',
            'flutter_secure_storage',
          ]),
          
          _buildLicenseSection('Licença Apache 2.0', [
            'receive_sharing_intent',
          ]),
        ],
      ),
    );
  }

  Widget _buildLicenseSection(String title, List<String> packages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ...packages.map((package) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              const Text('• '),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: package,
                      ),
                      TextSpan(
                        text: ' – $title',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildOrderedListItem(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubSection(String title, List<String> content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...content.map((text) => text.isEmpty ? const SizedBox(height: 4) : Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Text(
        '© 2025 FitTracker',
        style: TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }
}

class RequestBottom extends StatefulWidget {
  final Function(bool) onPressed;
  final int waitTimeSeconds;

  const RequestBottom({
    super.key, required this.onPressed, this.waitTimeSeconds = 5,
  });

  @override
  State<RequestBottom> createState() => _RequestBottomState();
}

class _RequestBottomState extends State<RequestBottom> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late DateTime startTime;
  late int secondsLest;

  @override
  void initState() {
    startTime = DateTime.now();
    secondsLest = widget.waitTimeSeconds;
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.waitTimeSeconds),
    );
    _controller.addListener(() {
      setState(() {
        secondsLest = widget.waitTimeSeconds - DateTime.now().difference(startTime).inSeconds;
        if(secondsLest <= 0) _controller.dispose();
      });
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    if(_controller.isDismissed) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Leia e aceite os termos de serviço para continuar."),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => widget.onPressed(false),
                  child: const Text("Rejeitar"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondsLest <= 0 ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => widget.onPressed(true),
                  child: secondsLest <= 0 ? Text("Aceitar") : Text("$secondsLest segundos"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}