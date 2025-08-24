import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pragma_prueba/models/cat_breed.dart';
import 'package:pragma_prueba/pages/widgets/breed_card.dart';
import 'package:pragma_prueba/pages/widgets/platform_alert_dialog.dart';
import 'package:pragma_prueba/pages/widgets/platform_button.dart';
import 'package:pragma_prueba/pages/widgets/platform_loading_indicator.dart';
import 'package:pragma_prueba/pages/widgets/platform_scaffold.dart';
import 'package:pragma_prueba/pages/widgets/platform_search_field.dart';
import 'package:pragma_prueba/services/cat_api_service.dart';

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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    final apiKey = dotenv.env['API_KEY']!;
    _catApiService = CatApiService(apiKey: apiKey);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
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
                child: const Icon(Icons.refresh),
              )
            : IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadBreeds,
              ),
      ],
      body: GestureDetector(
        behavior:
            HitTestBehavior.translucent, // detecta taps en espacios vacíos
        onTap: () {
          FocusScope.of(context).unfocus(); // cierra el teclado
        },
        child: Column(
          children: [
            PlatformSearchField(
              controller: _searchController,
              hintText: Platform.isIOS
                  ? 'Search cat breeds...'
                  : 'Buscar razas de gatos...',
              onClear: _clearSearch,
            ),
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
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            Expanded(child: _buildListContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildListContent() {
    if (isLoading) return const Center(child: PlatformLoadingIndicator());

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text('Error al cargar datos'),
            const SizedBox(height: 16),
            PlatformButton(text: 'Reintentar', onPressed: _loadBreeds),
          ],
        ),
      );
    }

    if (filteredBreeds.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
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
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
            const SizedBox(height: 16),
            PlatformButton(
                text: 'Limpiar búsqueda',
                onPressed: _clearSearch,
                isPrimary: false),
          ],
        ),
      );
    }

    // Cross-platform pull-to-refresh
    if (Platform.isIOS) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: _loadBreeds),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => BreedCard(breed: filteredBreeds[index]),
              childCount: filteredBreeds.length,
            ),
          ),
        ],
      );
    } else {
      return RefreshIndicator(
        onRefresh: _loadBreeds,
        child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: filteredBreeds.length,
          itemBuilder: (context, index) =>
              BreedCard(breed: filteredBreeds[index]),
        ),
      );
    }
  }
}
