import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  // etiqueta que se muestra encima del campo de texto
  final String label;
  // texto de ayuda que se muestra dentro del campo cuando esta vacio
  final String? hint;
  // controlador para manejar el texto ingresado
  final TextEditingController? controller;
  // indica si el texto debe ocultarse (por ejemplo, contrasenas)
  final bool obscureText;
  // tipo de teclado que se muestra (texto, email, numero, etc)
  final TextInputType keyboardType;
  // funcion para validar el valor ingresado
  final String? Function(String?)? validator;
  // funcion que se llama al cambiar el valor del campo
  final void Function(String)? onChanged;
  // icono que aparece al inicio del campo
  final IconData? prefixIcon;
  // icono que aparece al final del campo
  final IconData? suffixIcon;
  // funcion que se llama al presionar el icono al final
  final VoidCallback? onSuffixIconPressed;
  // lista de formateadores para controlar la entrada (por ejemplo, solo numeros)
  final List<TextInputFormatter>? inputFormatters;
  // numero maximo de lineas que puede tener el campo
  final int? maxLines;
  // longitud maxima de caracteres permitidos
  final int? maxLength;
  // indica si el campo esta habilitado o deshabilitado
  final bool enabled;
  // nodo de enfoque para controlar el foco del campo
  final FocusNode? focusNode;
  // capitalizacion de texto (ninguna, palabras, oracion, etc)
  final TextCapitalization textCapitalization;
  // padding interno personalizado del campo
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // etiqueta del campo
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                // color de texto segun modo oscuro
                ? Colors.white70
                // color de texto segun modo claro
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        // campo de formulario con texto
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          enabled: enabled,
          focusNode: focusNode,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark
                // color de texto ingresado en modo oscuro
                ? Colors.white
                // color de texto ingresado en modo claro
                : Colors.black,
          ),
          decoration: InputDecoration(
            // texto de ayuda
            hintText: hint,
            hintStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  // color de hint en modo oscuro
                  ? Colors.white38
                  // color de hint en modo claro
                  : Colors.black38,
            ),
            // padding interno personalizado o valor por defecto
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            // icono al inicio si se proporciona
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            // icono al final con funcionalidad de boton si se proporciona
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
            // borde normal del campo
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    // borde en modo oscuro
                    ? Colors.white24
                    // borde en modo claro
                    : Colors.black12,
              ),
            ),
            // borde cuando el campo esta habilitado pero sin foco
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    // borde habilitado en modo oscuro
                    ? Colors.white24
                    // borde habilitado en modo claro
                    : Colors.black12,
              ),
            ),
            // borde cuando el campo tiene foco
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            // borde cuando hay error de validacion
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            // borde cuando el campo tiene foco y hay error
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
