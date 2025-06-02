import 'package:flutter/material.dart';
import '../../../core/constants/ranks.dart';

class RankSelector extends StatelessWidget {
  final String? selectedTier;
  final String? selectedDivision;
  final Function(String?) onTierChanged;
  final Function(String?) onDivisionChanged;

  const RankSelector({
    Key? key,
    this.selectedTier,
    this.selectedDivision,
    required this.onTierChanged,
    required this.onDivisionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // etiqueta para indicar que seccion es el selector de tier
        const Text(
          'rango',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // contenedor que envuelve el dropdown de tiers
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            // color de fondo segun el tema
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2C2C2E)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedTier,
            decoration: const InputDecoration(
              // quitar borde predeterminado y mostrar texto de ayuda
              border: InputBorder.none,
              hintText: 'selecciona tu rango',
            ),
            items: Ranks.allTiers.map((tier) {
              return DropdownMenuItem<String>(
                value: tier,
                child: Row(
                  children: [
                    // icono que representa el tier
                    Text(
                      Ranks.getRankIcon(tier),
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    // texto con el nombre del tier
                    Text(tier),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              // notificar cambio de tier
              onTierChanged(value);
              // resetear division al cambiar tier
              if (value != selectedTier) {
                onDivisionChanged(null);
              }
            },
          ),
        ),

        const SizedBox(height: 16),

        // si ya se selecciono un tier, mostrar selector de division
        if (selectedTier != null) ...[
          const Text(
            'division',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // contenedor que envuelve el dropdown de divisiones
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              // color de fondo segun el tema
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2C2C2E)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonFormField<String>(
              value: selectedDivision,
              decoration: const InputDecoration(
                // quitar borde y mostrar texto de ayuda
                border: InputBorder.none,
                hintText: 'selecciona tu division',
              ),
              items: Ranks.getDivisionsForTier(selectedTier!).map((division) {
                return DropdownMenuItem<String>(
                  value: division,
                  // texto mostrara "tier division"
                  child: Text('$selectedTier $division'),
                );
              }).toList(),
              onChanged: onDivisionChanged,
            ),
          ),
        ],

        // vista previa del rango completo si tier y division estan seleccionados
        if (selectedTier != null && selectedDivision != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // color de fondo semitransparente en base al color del tier
              color: Ranks.getRankColor(selectedTier!).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Ranks.getRankColor(selectedTier!),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // icono que representa el tier seleccionado
                Text(
                  Ranks.getRankIcon(selectedTier!),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                // texto que muestra "tier division"
                Text(
                  '$selectedTier $selectedDivision',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Ranks.getRankColor(selectedTier!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
