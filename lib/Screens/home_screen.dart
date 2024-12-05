import 'package:flutter/material.dart';
import '../Services/api/movie_service.dart';
import '../Widgets/movie_card.dart';
import '../Services/api/logs_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> items = [];
  bool isLoading = false;
  String errorMessage = '';
  int pageNum = 1;
  int totalPages = 10;
  int totalResults = 0;

  Future<void> _searchMovies() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final results = await fetchData(_controller.text, pageNum);

      setState(() {
        items = results['items'];
        totalPages = (int.parse(results['count']) + 10 - 1) ~/ 10;
        totalResults = int.parse(results['count']);
      });

      createLog({
        'id': '0',
        'movieTitle': _controller.text,
        'numOfResults': totalResults.toString(),
        'queryDate': DateTime.now().toIso8601String(),
      });
      
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Search Box Section-----------------------------------------------------------------
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: TextField(
                    controller: _controller,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Search For Movies...',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _searchMovies();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Search'),
                  ),
                ),
              ],
            ),
          ),
          // Results Section-----------------------------------------------------------------
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
          
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  final movie = items[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    height: 120,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          movie['Poster'],
                          height: 100,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              print(movie);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  MovieCard(movieId: movie['imdbID'])),
                              );
                            },
                            child: Text(
                              movie['Title'] ?? 'Title',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue, 
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          // Pagination Controls Section-----------------------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (pageNum > 1 && items.isNotEmpty) {
                        pageNum--;
                      }
                    });
                    _searchMovies();
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
                  tooltip: "Previous Page",
                ),
                SizedBox(width: 16),
                Text('$pageNum'),
                SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (pageNum < totalPages && items.isNotEmpty) {
                        pageNum++;
                      }
                    });
                    _searchMovies();
                  },
                  icon: Icon(Icons.arrow_forward),
                  color: Colors.black,
                  tooltip: "Next Page",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}