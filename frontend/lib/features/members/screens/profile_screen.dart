import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/user_preferences_provider.dart';
import '../../../data/providers/testimonial_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../widgets/rank_badge.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // clave para el formulario de perfil
  final _formKey = GlobalKey<FormState>();

  // controladores de texto para los campos de usuario
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _riotIdController;

  // variables para almacenar las preferencias seleccionadas
  String? _selectedTier;
  String? _selectedDivision;
  String? _selectedRole;
  List<String> _selectedChampions = [];

  // indicador para alternar entre modo edicion y vista
  bool _isEditing = false;

  // correo del administrador para diferenciar vistas
  final String adminEmail = 'adriannulero@gmail.com';

  // listas de opciones para roles, tiers y divisiones
  final List<String> _roles = ['top', 'jungle', 'mid', 'adc', 'support'];
  final List<String> _tiers = [
    'iron',
    'bronze',
    'silver',
    'gold',
    'platinum',
    'emerald',
    'diamond',
    'master',
    'grandmaster',
    'challenger'
  ];
  final List<String> _divisions = ['iv', 'iii', 'ii', 'i'];

  // lista completa de campeones de league of legends
  final List<String> _allChampions = [
    'aatrox', 'ahri', 'akali', 'akshan', 'alistar', 'ambessa', 'amumu',
    'anivia', 'annie', 'aphelios', 'ashe', 'aurelion sol', 'aurora', 'azir',
    'bard', 'bel\'veth', 'blitzcrank', 'brand', 'braum', 'briar', 'caitlyn',
    'camille', 'cassiopeia', 'cho\'gath', 'corki', 'darius', 'diana',
    'dr. mundo', 'draven', 'ekko', 'elise', 'evelynn', 'ezreal', 'fiddlesticks',
    'fiora', 'fizz', 'galio', 'gangplank', 'garen', 'gnar', 'gragas', 'graves',
    'gwen', 'hecarim', 'heimerdinger', 'hwei', 'illaoi', 'irelia', 'ivern',
    'janna', 'jarvan iv', 'jax', 'jayce', 'jhin', 'jinx', 'k\'sante', 'kai\'sa',
    'kalista', 'karma', 'karthus', 'kassadin', 'katarina', 'kayle', 'kayn',
    'kennen', 'kha\'zix', 'kindred', 'kled', 'kog\'maw', 'leblanc', 'lee sin',
    'leona', 'lillia', 'lissandra', 'lucian', 'lulu', 'lux', 'malphite',
    'malzahar', 'maokai', 'master yi', 'mel', 'milio', 'miss fortune',
    'mordekaiser', 'morgana', 'naafiri', 'nami', 'nasus', 'nautilus', 'neeko',
    'nidalee', 'nilah', 'nocturne', 'nunu & willump', 'olaf', 'orianna', 'ornn',
    'pantheon', 'poppy', 'pyke', 'qiyana', 'quinn', 'rakan', 'rammus',
    'rek\'sai', 'rell', 'renata glasc', 'renekton', 'rengar', 'riven', 'rumble',
    'ryze', 'samira', 'sejuani', 'senna', 'seraphine', 'sett', 'shaco', 'shen',
    'shyvana', 'singed', 'sion', 'sivir', 'skarner', 'smolder', 'sona', 'soraka',
    'swain', 'sylas', 'syndra', 'tahm kench', 'taliyah', 'talon', 'taric',
    'teemo', 'thresh', 'tristana', 'trundle', 'tryndamere', 'twisted fate',
    'twitch', 'udyr', 'urgot', 'varus', 'vayne', 'veigar', 'vel\'koz', 'vex',
    'vi', 'viego', 'viktor', 'vladimir', 'volibear', 'warwick', 'wukong',
    'xayah', 'xerath', 'xin zhao', 'yasuo', 'yone', 'yorick', 'yuumi', 'zac',
    'zed', 'zeri', 'ziggs', 'zilean', 'zoe', 'zyra',
  ];

  // lista filtrada de campeones segun busqueda
  List<String> _filteredChampions = [];
  late TextEditingController _championSearchController;

  @override
  void initState() {
    super.initState();

    // obtener usuario actual desde el provider de autenticacion
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    // inicializar controladores con datos del usuario
    _usernameController = TextEditingController(text: user?.username);
    _emailController = TextEditingController(text: user?.email);
    _riotIdController = TextEditingController();
    _championSearchController = TextEditingController();

    // inicializar lista filtrada de campeones completa
    _filteredChampions = _allChampions;

    // agregar listener para filtrar campeones cuando cambie el texto
    _championSearchController.addListener(_filterChampions);

    // cargar preferencias de usuario despues de que el widget se haya montado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserPreferences();
      // si el usuario es admin, cargar todos los testimonios para administracion
      if (user?.email == adminEmail) {
        Provider.of<TestimonialProvider>(context, listen: false)
            .loadAllTestimonialsAdmin();
      }
    });
  }

  // metodo para cargar preferencias del usuario desde el provider
  void _loadUserPreferences() async {
    final preferencesProvider =
        Provider.of<UserPreferencesProvider>(context, listen: false);
    await preferencesProvider.loadPreferences();

    // si existen preferencias, asignarlas a las variables locales
    if (preferencesProvider.preferences != null) {
      setState(() {
        _riotIdController.text =
            preferencesProvider.preferences?.riotId ?? '';
        _selectedTier = preferencesProvider.preferences?.tier;
        _selectedDivision = preferencesProvider.preferences?.division;
        _selectedRole = preferencesProvider.preferences?.mainRole;
        _selectedChampions =
            preferencesProvider.preferences?.favoriteChampions?.toList() ??
                [];
      });
    }
  }

  // metodo que filtra campeones segun texto de busqueda
  void _filterChampions() {
    final query = _championSearchController.text.toLowerCase();
    setState(() {
      _filteredChampions = _allChampions
          .where((champion) => champion.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    // liberar controladores al destruir el widget
    _usernameController.dispose();
    _emailController.dispose();
    _riotIdController.dispose();
    _championSearchController.dispose();
    super.dispose();
  }

  // alternar modo edicion y guardar perfil si se desactiva edicion
  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _saveProfile();
      } else {
        // al activar edicion, limpiar busqueda y restaurar lista completa
        _championSearchController.clear();
        _filteredChampions = _allChampions;
      }
    });
  }

  // metodo para guardar cambios en perfil y preferencias
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final preferencesProvider =
            Provider.of<UserPreferencesProvider>(context, listen: false);

        // obtener usuario actual para comprobar si es admin
        final user =
            Provider.of<AuthProvider>(context, listen: false).user;
        if (user?.email != adminEmail) {
          // actualizar preferencias solo si no es admin
          final success = await preferencesProvider.updatePreferences(
            tier: _selectedTier,
            division: _selectedDivision,
            riotId: _riotIdController.text,
            mainRole: _selectedRole,
            favoriteChampions: _selectedChampions,
          );

          if (mounted) {
            if (success) {
              // notificacion de exito al guardar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('perfil actualizado correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              // notificacion de error al guardar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(preferencesProvider.error ??
                      'error al actualizar el perfil'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      } catch (e) {
        if (mounted) {
          // notificacion de excepcion
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // metodo para agregar o quitar campeon de la lista de favoritos
  void _toggleChampion(String champion) {
    setState(() {
      if (_selectedChampions.contains(champion)) {
        _selectedChampions.remove(champion);
      } else {
        if (_selectedChampions.length < 5) {
          _selectedChampions.add(champion);
        } else {
          // mensaje si intenta agregar mas de 5 campeones
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('puedes seleccionar un maximo de 5 campeones'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // obtener usuario actual desde provider
    final user = Provider.of<AuthProvider>(context).user;
    final preferencesProvider =
        Provider.of<UserPreferencesProvider>(context);
    final preferences = preferencesProvider.preferences;
    final testimonialProvider =
        Provider.of<TestimonialProvider>(context);

    // mostrar indicador si el usuario no esta cargado aun
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // determinar si el usuario es administrador
    final isAdmin = user.email == adminEmail;

    return Scaffold(
      // color de fondo segun tema
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1C1C1E)
              : Colors.grey.shade50,
      appBar: AppBar(
        // titulo de la pantalla
        title: const Text('mi perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // mostrar boton de edicion si no es admin
          if (!isAdmin)
            IconButton(
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: _toggleEdit,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // contenedor principal con avatar y datos basicos
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness ==
                          Brightness.dark
                      ? const Color(0xFF2C2C2E)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(12),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // avatar circular con imagen de perfil o inicial
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withAlpha(25),
                      backgroundImage:
                          user.profileImage != null
                              ? NetworkImage(user.profileImage!)
                              : null,
                      child: user.profileImage == null
                          ? Text(
                              user.username
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // nombre de usuario
                    Text(
                      user.username,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // correo del usuario
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // seccion de preferencias si no es admin
              if (!isAdmin)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // titulo de la seccion
                    Text(
                      'mis preferencias',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // si no esta en modo edicion, mostrar datos de preferencias
                    if (!_isEditing)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? const Color(0xFF2C2C2E)
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(12),
                              blurRadius: 10,
                              offset:
                                  const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // fila con etiqueta y valor de riot id
                            _buildPreferenceItem(
                                'id de riot',
                                preferences?.riotId ?? 'n/a'),
                            // fila con etiqueta y valor de rango completo
                            _buildPreferenceItem(
                                'rango',
                                preferences?.fullRank ??
                                    'n/a'),
                            // fila con etiqueta y valor de rol principal
                            _buildPreferenceItem(
                                'rol principal',
                                preferences?.mainRole ??
                                    'n/a'),
                            // fila con etiqueta y lista de campeones favoritos
                            _buildPreferenceItem(
                                'campeones favoritos',
                                preferences?.favoriteChampions
                                        ?.join(', ') ??
                                    'n/a'),

                            const SizedBox(height: 16),
                            // mostrar insignia de rango si existe rango
                            if (preferences?.fullRank != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  RankBadge(
                                    rank:
                                        preferences!.fullRank!,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                    // si esta en modo edicion, mostrar campos de edicion
                    if (_isEditing)
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          // campo de texto para riot id
                          CustomTextField(
                            label: 'id de riot',
                            controller: _riotIdController,
                          ),
                          const SizedBox(height: 16),

                          // fila con dropdown para seleccionar tier y division
                          Row(
                            children: [
                              Expanded(
                                child:
                                    DropdownButtonFormField<String>(
                                  decoration:
                                      const InputDecoration(
                                          labelText: 'tier'),
                                  value: _selectedTier,
                                  items: _tiers
                                      .map((tier) =>
                                          DropdownMenuItem(
                                            value: tier,
                                            child: Text(tier),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTier = value;
                                      _selectedDivision =
                                          null;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child:
                                    DropdownButtonFormField<String>(
                                  decoration:
                                      const InputDecoration(
                                          labelText:
                                              'division'),
                                  value: _selectedDivision,
                                  items: _divisions
                                      .map(
                                          (division) =>
                                              DropdownMenuItem(
                                                value: division,
                                                child:
                                                    Text(division),
                                              ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDivision =
                                          value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // dropdown para seleccionar rol principal
                          DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(
                                    labelText:
                                        'rol principal'),
                            value: _selectedRole,
                            items: _roles
                                .map((role) =>
                                    DropdownMenuItem(
                                      value: role,
                                      child: Text(role),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole =
                                    value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),

                          // titulo para seleccion de campeones
                          const Text(
                            'campeones favoritos (max 5)',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold),
                          ),
                          const SizedBox(height: 8),

                          // campo de busqueda de campeones
                          CustomTextField(
                            label: 'buscar campeon',
                            controller:
                                _championSearchController,
                          ),
                          const SizedBox(height: 8),

                          // chips filtrados de campeones para seleccionar
                          Wrap(
                            spacing: 8.0,
                            children: _filteredChampions
                                .map((champion) {
                              final isSelected =
                                  _selectedChampions
                                      .contains(champion);
                              return FilterChip(
                                label: Text(champion),
                                selected: isSelected,
                                onSelected: (selected) {
                                  _toggleChampion(
                                      champion);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                  ],
                ),

              // si es admin, mostrar seccion de gestion de testimonios
              if (isAdmin)
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      'gestion de testimonios',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // indicador de carga para admin
                    testimonialProvider.isAdminLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator())
                        : testimonialProvider.adminError !=
                                null
                            // mostrar mensaje de error si existe
                            ? Center(
                                child: Text(
                                    'error: ${testimonialProvider.adminError}'))
                            // si no hay testimonios, indicar vacio
                            : testimonialProvider
                                    .allTestimonials.isEmpty
                                ? const Center(
                                    child: Text(
                                        'no hay testimonios para revisar.'))
                                // lista de tarjetas con cada testimonio
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: testimonialProvider
                                        .allTestimonials.length,
                                    itemBuilder: (context, index) {
                                      final testimonial =
                                          testimonialProvider
                                              .allTestimonials[
                                                  index];
                                      return Card(
                                        margin: const EdgeInsets.only(
                                            bottom: 16),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // nombre del autor
                                              Text(
                                                testimonial.name,
                                                style:
                                                    const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              // comentario del autor
                                              Text(testimonial.comment),
                                              // fila con estrellas segun rating
                                              Row(
                                                children: List.generate(
                                                  5,
                                                  (starIndex) =>
                                                      Icon(
                                                    starIndex <
                                                            testimonial
                                                                .rating
                                                                .floor()
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color:
                                                        Colors.amber,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              // estado del testimonio (aprobado o pendiente)
                                              Text(
                                                'estado: ${testimonial.isApproved ? "aprobado" : "pendiente"}',
                                                style: TextStyle(
                                                  color: testimonial
                                                          .isApproved
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: 8),
                                              // botones para aprobar o eliminar
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  // boton para aprobar si no esta aprobado
                                                  if (!testimonial
                                                      .isApproved)
                                                    TextButton(
                                                      onPressed:
                                                          () async {
                                                        final success =
                                                            await testimonialProvider
                                                                .approveTestimonial(
                                                                    testimonial
                                                                        .id);
                                                        if (success) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                  'testimonio aprobado'),
                                                            ),
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'error al aprobar: ${testimonialProvider.adminError}'),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: const Text(
                                                          'aprobar'),
                                                    ),
                                                  // boton para eliminar testimonio
                                                  TextButton(
                                                    onPressed:
                                                        () async {
                                                      final success =
                                                          await testimonialProvider
                                                              .deleteTestimonial(
                                                                  testimonial
                                                                      .id);
                                                      if (success) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content:
                                                                Text('testimonio eliminado'),
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                                'error al eliminar: ${testimonialProvider.adminError}'),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      'eliminar',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                  ],
                ),

              const SizedBox(height: 24),

              // boton para cerrar sesion
              Center(
                child: CustomButton(
                  text: 'cerrar sesion',
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context,
                            listen: false)
                        .logout();
                    if (mounted) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(
                              '/login', (route) => false);
                    }
                  },
                  isLoading: Provider.of<AuthProvider>(context)
                          .status ==
                      AuthStatus.authenticating,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // widget auxiliar para mostrar una fila de preferencia con etiqueta y valor
  Widget _buildPreferenceItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
