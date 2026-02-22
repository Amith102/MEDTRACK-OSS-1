class InteractionWarning {
  final String severity; // e.g., 'High', 'Moderate'
  final String description;

  const InteractionWarning({required this.severity, required this.description});
}

class InteractionDictionary {
  // A simplified, offline database of severe drug-drug interactions.
  // Keys are sorted alphabetically to make lookups bidirectional (A+B == B+A).
  static final Map<String, InteractionWarning> _interactions = {
    'ibuprofen_warfarin': const InteractionWarning(
      severity: 'High',
      description: 'Taking an NSAID (Ibuprofen) with a blood thinner (Warfarin) significantly increases the risk of severe gastrointestinal bleeding.',
    ),
    'aspirin_warfarin': const InteractionWarning(
      severity: 'High',
      description: 'Taking Aspirin with Warfarin increases the risk of major bleeding complications.',
    ),
    'lisinopril_spironolactone': const InteractionWarning(
      severity: 'High',
      description: 'Combining an ACE inhibitor (Lisinopril) with a potassium-sparing diuretic (Spironolactone) increases the risk of dangerously high potassium levels (Hyperkalemia).',
    ),
    'amiodarone_simvastatin': const InteractionWarning(
      severity: 'High',
      description: 'Amiodarone can increase the concentration of Simvastatin, raising the risk of severe muscle damage (Rhabdomyolysis).',
    ),
    'sildenafil_nitroglycerin': const InteractionWarning(
      severity: 'High',
      description: 'Combining Sildenafil with Nitrates can cause a sudden, severe, and potentially fatal drop in blood pressure.',
    ),
     'ciprofloxacin_tizanidine': const InteractionWarning(
      severity: 'High',
      description: 'Ciprofloxacin strongly inhibits the metabolism of Tizanidine, causing dangerous hypotension and excessive sedation.',
    ),
  };

  /// Checks if [newMed] has a known severe interaction with any medication in [existingMeds].
  /// Returns an [InteractionWarning] if a match is found, otherwise null.
  static InteractionWarning? checkInteraction(String newMed, List<String> existingMeds) {
    if (newMed.isEmpty || existingMeds.isEmpty) return null;

    final normalizedNewMed = newMed.trim().toLowerCase();

    for (final existing in existingMeds) {
      final normalizedExisting = existing.trim().toLowerCase();
      
      // Sort the two names alphabetically to generate the lookup key
      final combination = [normalizedNewMed, normalizedExisting]..sort();
      final key = '${combination[0]}_${combination[1]}';

      if (_interactions.containsKey(key)) {
        return _interactions[key];
      }
    }

    return null; // Safe
  }
}
