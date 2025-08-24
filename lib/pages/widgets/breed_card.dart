  import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pragma_prueba/models/cat_breed.dart';
import 'package:pragma_prueba/pages/details_page.dart';
import 'package:pragma_prueba/theme/app_colors.dart';

class BreedCard extends StatelessWidget {
  final CatBreed breed;

  const BreedCard({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.3,
      child: Card(
        margin: const EdgeInsets.all(32),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: breed.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        breed.imageUrl!,
                        width: double.infinity,
                        height: size.height * 0.6,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 90,
                          height: 90,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image),
                        ),
                      ),
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
            ),
            // Nombre
            Positioned(
              top: 8,
              left: 8,
              child: _tag(text: breed.name, fontSize: 20, bold: true),
            ),
            // Origen
            Positioned(
              bottom: 8,
              left: 8,
              child: _tag(text: breed.origin, fontSize: 10),
            ),
            // Inteligencia
            Positioned(
              bottom: 8,
              right: 8,
              child: _tag(text: breed.intelligence.toString(), fontSize: 10),
            ),
            // Flecha a detalle
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    Platform.isIOS
                        ? CupertinoPageRoute(
                            builder: (_) => DetailPage(breed: breed))
                        : MaterialPageRoute(
                            builder: (_) => DetailPage(breed: breed)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.chevron_right, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag({required String text, double fontSize = 12, bool bold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: Colors.white,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
