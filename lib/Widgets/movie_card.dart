import 'package:flutter/material.dart';
import '../Services/api/movie_service.dart';

String convertRuntimeToHoursMinutes(String runtime) {
  try {
    final int totalMinutes = int.parse(runtime.split(' ')[0]);

    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;

    return '${hours}h ${minutes}min';
  } catch (e) {
    return 'Invalid runtime format';
  }
}

class MovieCard extends StatefulWidget {
  const MovieCard({
    super.key,
    required this.movieId,
  });

  final String movieId;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  Map<String, dynamic>? movie;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedMovie = await fetchDataById(widget.movieId);
      setState(() {
        movie = fetchedMovie;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load movie data.';
      });
      debugPrint('Error fetching movie: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    if (movie == null || !movie!.containsKey('Title')) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Movie Not Found'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        body: const Center(
          child: Text('No movie data available.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(movie!['Title']),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                movie!['Title'],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              movie!['Poster'] != null
                  ? Image.network(movie!['Poster'])
                  : const Text('No Poster Available'),
              const SizedBox(height: 16),
              Text(
                '${movie!['Year'] ?? 'Unknown'} • ${convertRuntimeToHoursMinutes(movie!['Runtime'])}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Rated: ${movie!['Rated']}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Genres: ${movie!['Genre']}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Actors: ${movie!['Actors']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                '${movie!['Plot']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      )
    );
  }
}
