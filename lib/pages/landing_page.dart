import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pragma_prueba/models/cat_breed.dart';
import 'package:pragma_prueba/pages/details_page.dart';
import 'package:pragma_prueba/pages/widgets/platform_alert_dialog.dart';
import 'package:pragma_prueba/pages/widgets/platform_button.dart';
import 'package:pragma_prueba/pages/widgets/platform_loading_indicator.dart';
import 'package:pragma_prueba/pages/widgets/platform_scaffold.dart';
import 'package:pragma_prueba/pages/widgets/platform_search_field.dart';
import 'package:pragma_prueba/services/cat_api_service.dart';
import 'package:pragma_prueba/theme/app_colors.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<CatBreed> breeds = [];
  List<CatBreed> filteredBreeds = [];
  bool isLoading = true;
  String? error;
  CatApiService? _catApiService;

  // Controladores para el buscador
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    final apiKey = dotenv.env['API_KEY']!;
    _catApiService = CatApiService(apiKey: apiKey);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await _loadBreeds();

      _searchController.addListener(_onSearchChanged);
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterBreeds();
    });
  }

  void _filterBreeds() {
    if (_searchQuery.isEmpty) {
      filteredBreeds = List.from(breeds);
    } else {
      filteredBreeds = breeds.where((breed) {
        final query = _searchQuery.toLowerCase();
        return breed.name.toLowerCase().contains(query) ||
            breed.origin.toLowerCase().contains(query) ||
            breed.temperament.toLowerCase().contains(query);
      }).toList();
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _filterBreeds();
    });
  }

  Future<void> _loadBreeds() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedBreeds = await _catApiService!.getBreeds();

      setState(() {
        breeds = fetchedBreeds;
        filteredBreeds = fetchedBreeds;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });

      // Mostrar error con componente nativo
      PlatformAlertDialog.show(
        context: context,
        title: 'Error',
        message: 'No se pudieron cargar las razas: $e',
      );
    }
    if (context.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      title: 'Catbreeds',
      actions: [
        Platform.isIOS
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _loadBreeds,
                child: const Icon(CupertinoIcons.refresh),
              )
            : IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadBreeds,
              ),
      ],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        
        PlatformSearchField(
          controller: _searchController,
          hintText: Platform.isIOS
              ? 'Search cat breeds...'
              : 'Buscar razas de gatos...',
          onClear: _clearSearch,
          onChanged: (value) {
          },
        ),

        // Resultados de búsqueda
        if (_searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${filteredBreeds.length} resultado${filteredBreeds.length != 1 ? 's' : ''} para "$_searchQuery"',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: _clearSearch,
                    child: Text(
                      'Limpiar',
                      style: TextStyle(
                        color: Platform.isIOS
                            ? CupertinoColors.activeBlue
                            : Theme.of(context).primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Lista o estados
        Expanded(
          child: _buildListContent(),
        ),
      ],
    );
  }

  Widget _buildListContent() {
    if (isLoading) {
      return const Center(child: PlatformLoadingIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Platform.isIOS
                  ? CupertinoIcons.exclamationmark_triangle
                  : Icons.error,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text('Error al cargar datos'),
            const SizedBox(height: 16),
            PlatformButton(
              text: 'Reintentar',
              onPressed: _loadBreeds,
            ),
          ],
        ),
      );
    }

    // Si no hay resultados de búsqueda
    if (filteredBreeds.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Platform.isIOS ? CupertinoIcons.search : Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron razas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta con otro término de búsqueda',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            PlatformButton(
              text: 'Limpiar búsqueda',
              onPressed: _clearSearch,
              isPrimary: false,
            ),
          ],
        ),
      );
    }

    // Lista con resultados
    return RefreshIndicator(
      onRefresh: _loadBreeds,
      child: ListView.builder(
        physics: Platform.isIOS
            ? const BouncingScrollPhysics()
            : const ClampingScrollPhysics(),
        itemCount: filteredBreeds.length,
        itemBuilder: (context, index) {
          final breed = filteredBreeds[index];
          return _buildBreedCard(breed, index, context);
        },
      ),
    );
  }

  Widget _buildBreedCard(CatBreed breed, int index, BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.3,
      child: Card(
          margin: const EdgeInsets.all(32),
          child: Stack(
            children: [
              // Centro
              Align(
                alignment: Alignment.center,
                child: breed.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          breed.imageUrl!,
                          width: double.infinity, //90,
                          height: size.height * 0.6,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey[300],
                            child: Icon(
                              Platform.isIOS
                                  ? CupertinoIcons.photo
                                  : Icons.image,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey[300],
                        child: Icon(
                          Platform.isIOS ? CupertinoIcons.photo : Icons.image,
                        ),
                      ),
              ),
              // Abajo derecha
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      breed.intelligence.toString(),
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              // Arriba izquierda
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      breed.name,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),

              // Arriba derecha
              Transform.translate(
                offset: const Offset(0, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            Platform.isIOS
                                ? CupertinoPageRoute(
                                    builder: (context) =>
                                        DetailPage(breed: breed),
                                  )
                                : MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(breed: breed),
                                  ),
                          );
                        },
                        child: Icon(
                          Platform.isIOS
                              ? CupertinoIcons.chevron_right
                              : Icons.chevron_right,
                          color: AppColors.white,
                        ),
                      ), 
                    ),
                  ),
                ),
              ),

              // Abajo izquierda
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      breed.origin,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
