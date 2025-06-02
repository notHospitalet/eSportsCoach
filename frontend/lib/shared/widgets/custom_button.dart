import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double height;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // determinar colores basados en el tipo de boton
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (type) {
      case ButtonType.primary:
        // boton principal: fondo del color primario, texto blanco, sin borde
        backgroundColor = theme.colorScheme.primary;
        textColor = Colors.white;
        borderColor = Colors.transparent;
        break;
      case ButtonType.secondary:
        // boton secundario: fondo del color secundario, texto blanco, sin borde
        backgroundColor = theme.colorScheme.secondary;
        textColor = Colors.white;
        borderColor = Colors.transparent;
        break;
      case ButtonType.outline:
        // boton outline: fondo transparente, texto del color primario, borde del color primario
        backgroundColor = Colors.transparent;
        textColor = theme.colorScheme.primary;
        borderColor = theme.colorScheme.primary;
        break;
    }

    return SizedBox(
      // si isFullWidth es verdadero, el ancho ocupa todo el espacio disponible
      // en caso contrario, se usa el ancho especificado (puede ser nulo)
      width: isFullWidth ? double.infinity : width,
      height: height, // altura fija del boton
      child: ElevatedButton(
        // si isLoading es verdadero, deshabilita el boton (onPressed nulo)
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // color de fondo segun el tipo
          foregroundColor: textColor, // color del texto/icono
          side: BorderSide(color: borderColor), // borde segun el tipo
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // esquinas redondeadas
          ),
          elevation: type == ButtonType.outline ? 0 : 0, // sin sombra
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  // indicador de carga pequeño, con color del texto
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    // si se pasa un icono, se muestra antes del texto
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
