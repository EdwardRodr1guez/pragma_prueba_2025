import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pragma_prueba/models/cat_breed.dart';
import 'package:pragma_prueba/pages/widgets/platform_scaffold.dart';

class DetailPage extends StatelessWidget {
  final CatBreed breed;

  const DetailPage({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      title: breed.name,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          if (breed.imageUrl != null)
            ClipRRect(
              //borderRadius: BorderRadius.circular(12),
              child: Image.network(
                breed.imageUrl!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: Icon(
                    Platform.isIOS ? CupertinoIcons.photo : Icons.image,
                    size: 64,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Información
          Expanded(
            child: SingleChildScrollView(
                // Physics nativo
                physics: Platform.isIOS
                    ? const BouncingScrollPhysics()
                    : const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Descripción',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      breed.description,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Origen',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      breed.origin,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Temperamento',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      breed.temperament,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Nivel de energía',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      breed.energyLevel.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Nivel de afecto',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      breed.affectionLevel.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                  ],
                )),
          ),
        ],
      ),
    );
  }

}
