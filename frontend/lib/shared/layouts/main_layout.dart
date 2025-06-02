import 'package:flutter/material.dart';
import '../widgets/persistent_bottom_navigation.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final Widget? floatingActionButton;

  const MainLayout({
    Key? key,
    required this.child,
    required this.currentIndex,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // cuerpo principal de la pantalla
      body: SafeArea(
        // garantiza que el contenido no quede debajo de areas del sistema (notch, barra de estado, etc)
        child: child,
      ),
      // barra de navegacion inferior persistente
      bottomNavigationBar: PersistentBottomNavigation(
        // indice actual seleccionado en la barra de navegacion
        currentIndex: currentIndex,
      ),
      // boton flotante opcional, por ejemplo para acciones rapidas
      floatingActionButton: floatingActionButton,
    );
  }
}
