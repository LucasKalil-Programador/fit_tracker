import 'package:fittrackr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FitTrackerTermsPage extends StatelessWidget {
  final Function? onAccepted;
  final Function? onRejected;

  const FitTrackerTermsPage({super.key, required this.onAccepted, required this.onRejected});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.termsAndPrivacy),
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
                  _buildHeader(Theme.of(context).colorScheme, localization),
                  const SizedBox(height: 20),
                  
                  // Termos de Uso
                  _buildTermsSection(Theme.of(context).colorScheme, localization),
                  const SizedBox(height: 18),
                  
                  // Política de Privacidade
                  _buildPrivacySection(Theme.of(context).colorScheme, localization),
                  const SizedBox(height: 18),
                  
                  // Licenças
                  _buildLicensesSection(Theme.of(context).colorScheme, localization),
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

  Widget _buildHeader(ColorScheme scheme, AppLocalizations localization) {
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
              "FT", // TODO: Put icon here
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
              Text(
                localization.fitTrackerTermsTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                localization.publicDocumentInfo,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildChip(localization.loginMethod, scheme),
                  _buildChip(localization.storageMethod, scheme),
                  _buildChip(localization.minimumAge, scheme),
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
            "$emoji $title",
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

  Widget _buildTermsSection(ColorScheme scheme, AppLocalizations localization) {
    return _buildSection(
      scheme,
      title: localization.termsOfUse,
      emoji: "📜",
      subtitle: localization.readCarefully,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderedListItem("1", localization.termsAcceptance, localization.termsAcceptanceMessage),
          _buildOrderedListItem("2", localization.appPurpose, localization.appPurposeMessage),
          _buildOrderedListItem("3", localization.loginAndAccount, localization.loginAndAccountMessage),
          _buildOrderedListItem("4", localization.responsibleUse, localization.responsibleUseMessage),
          _buildOrderedListItem("5", localization.minimumAgeTitle, localization.minimumAgeMessage),
          _buildOrderedListItem("6", localization.liabilityLimitation, localization.liabilityLimitationMessage),
          _buildOrderedListItem("7", localization.modifications, localization.modificationsMessage),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(ColorScheme scheme, AppLocalizations localization) {
    return _buildSection(
      scheme,
      title: localization.privacyPolicy,
      emoji: "🔒",
      subtitle: localization.privacyPolicyDescription,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubSection("1. ${localization.collectedData}", localization.collectedDataDescription),
          _buildSubSection("2. ${localization.useOfInformation}", localization.useOfInformationDescription,),
          _buildSubSection("3. ${localization.thirdPartyServices}", localization.thirdPartyServicesDescription),
          _buildSubSection("4. ${localization.dataSharing}", localization.dataNotSold,),
          _buildSubSection("5. ${localization.storageAndSecurity}", localization.dataStorageSecurity,),
          _buildSubSection("6. ${localization.accountAndDataDeletion}", localization.accountDeletionInstructions,),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "lucas.prokalil2020@outlook.com",
              style: TextStyle(
                fontFamily: "monospace",
                fontSize: 13,
              ),
            ),
          ),
          Text(
            localization.deletionTimeframe,
            style: TextStyle(
              fontSize: 13,
            ),
          ),
          _buildSubSection("7. ${localization.policyChanges}", localization.policyUpdates),
          _buildSubSection("8. ${localization.contact}", localization.privacyQuestions("lucas.prokalil2020@outlook.com"),),
        ],
      ),
    );
  }

  Widget _buildLicensesSection(ColorScheme scheme, AppLocalizations localization) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localization.libraryLicenses,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildLicenseSection(localization.mitLicense, [
            "cupertino_icons",
            "provider",
            "uuid",
            "flutter_slidable",
            "flutter_staggered_grid_view",
            "fl_chart",
            "synchronized",
            "logger",
            "archive",
            "flutter_svg",
            "sqflite_sqlcipher",
          ]),
          
          _buildLicenseSection(localization.bsd2ClauseLicense, [
            "sqflite",
            "sqflite_common_ffi",
            "percent_indicator",
            "sqflite_common_ffi_web",
            "tuple",
            "sqflite_common",
          ]),
          
          _buildLicenseSection(localization.bsd3ClauseLicense, [
            "path",
            "shimmer",
            "share_plus",
            "path_provider",
            "intl",
            "firebase_core",
            "firebase_auth",
            "google_sign_in",
            "loading_animation_widget",
            "cloud_firestore",
            "crypto",
            "connectivity_plus",
            "flutter_secure_storage",
          ]),
          
          _buildLicenseSection(localization.apacheLicense, [
            "receive_sharing_intent",
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
              const Text("• "),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: package,
                      ),
                      TextSpan(
                        text: " – $title",
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
            "$number. ",
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

  Widget _buildSubSection(String title, String content) {
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
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Text(
        "© 2025 FitTracker",
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
  bool isDisposed = false;
  bool isSubmited = false;
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
        if(secondsLest <= 0) disposeAnimation();
      });
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    disposeAnimation();
    super.dispose();
  }

  void disposeAnimation() {
    if(!isDisposed) _controller.dispose();
    isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(localization.acceptTermsMessage),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () => onSubmit(false),
                  child: Text(localization.reject),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondsLest <= 0 ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => onSubmit(true),
                  child: secondsLest <= 0 ? Text(localization.accept) : Text(localization.secondsLeft(secondsLest)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onSubmit(bool result) {
    if(isSubmited) return;
    isSubmited = true;
    widget.onPressed(result);
  }
}