import 'package:flutter/material.dart';
import '../../config/routes.dart';

class PersistentBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const PersistentBottomNavigation({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // contenedor que agrega sombra en la parte superior de la barra
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // color de la sombra con transparencia
            color: Colors.black.withAlpha(20),
            // radio de difuminado de la sombra
            blurRadius: 10,
            // desplazamiento de la sombra hacia arriba
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        // indice del elemento seleccionado actualmente
        currentIndex: currentIndex,
        // tipo fijo para mostrar siempre las etiquetas
        type: BottomNavigationBarType.fixed,
        // color del elemento seleccionado
        selectedItemColor: Theme.of(context).colorScheme.primary,
        // color de los elementos no seleccionados
        unselectedItemColor: Colors.grey,
        // mostrar etiquetas incluso si no estan seleccionadas
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            // icono cuando no esta activo
            icon: Icon(Icons.home_outlined),
            // icono cuando esta activo
            activeIcon: Icon(Icons.home),
            // etiqueta que aparece debajo del icono
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Servicios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Contenido',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            activeIcon: Icon(Icons.star),
            label: 'Testimonios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Sobre mí',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_support_outlined),
            activeIcon: Icon(Icons.contact_support),
            label: 'Contacto',
          ),
        ],
        onTap: (index) {
          // si el indice seleccionado es el mismo, no hacer nada
          if (index == currentIndex) return;

          // segun el indice, navegar a la ruta correspondiente
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.services);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.content);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.testimonials);
              break;
            case 4:
              Navigator.pushReplacementNamed(context, AppRoutes.about);
              break;
            case 5:
              Navigator.pushReplacementNamed(context, AppRoutes.contact);
              break;
          }
        },
      ),
    );
  }
}
