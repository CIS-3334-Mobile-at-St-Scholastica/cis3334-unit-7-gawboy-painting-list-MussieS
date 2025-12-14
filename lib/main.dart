import 'package:flutter/material.dart';

import 'load_painting_info.dart';
import 'painting_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gawboy Paintings',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PaintingPageViewScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PaintingPageViewScreen extends StatefulWidget {
  const PaintingPageViewScreen({super.key});

  @override
  State<PaintingPageViewScreen> createState() => _PaintingPageViewScreenState();
}

class _PaintingPageViewScreenState extends State<PaintingPageViewScreen> {
  // REQUIRED: controller for PageView
  final PageController ctrl = PageController();

  late Future<List<PaintingInfo>> _futureGawboyPaintings;

  @override
  void initState() {
    super.initState();

    // Load all paintings, then keep just Carl Gawboy's (if category exists).
    // If the filter finds nothing, it shows everything (so your app still works).
    _futureGawboyPaintings = LoadPaintingInfo.load(context).then((all) {
      final filtered = all.where((p) => p.isGawboy).toList();
      return filtered.isNotEmpty ? filtered : all;
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carl Gawboy Paintings'),
      ),
      body: FutureBuilder<List<PaintingInfo>>(
        future: _futureGawboyPaintings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error loading paintings:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final gawboyPaintings = snapshot.data ?? <PaintingInfo>[];
          if (gawboyPaintings.isEmpty) {
            return const Center(child: Text('No paintings found.'));
          }

          // REQUIRED: PageView.builder with itemCount, itemBuilder, controller
          return PageView.builder(
            controller: ctrl,
            itemCount: gawboyPaintings.length,
            itemBuilder: (BuildContext context, int position) {
              final p = gawboyPaintings[position];

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Painting image
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/images/${p.imageFile}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Image not found.\nCheck pubspec.yaml assets path.',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      // Text info
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            if (p.gawboyDescription.trim().isNotEmpty)
                              Text(
                                p.gawboyDescription,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            else
                              Text(
                                'No description available.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.black54),
                              ),
                            const SizedBox(height: 12),
                            Text(
                              'Swipe → for next painting',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
