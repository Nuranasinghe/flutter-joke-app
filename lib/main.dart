import 'package:flutter/material.dart';
import 'joke_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const JokeListPage(title: 'Joke App'),
    );
  }
}

class JokeListPage extends StatefulWidget {
  const JokeListPage({super.key, required this.title});

  final String title;

  @override
  State<JokeListPage> createState() => _JokeListPageState();
}

class _JokeListPageState extends State<JokeListPage> {
  final JokeService _jokeService = JokeService();
  List<Map<String, dynamic>> _jokes = [];
  List<Map<String, dynamic>> _filteredJokes = [];
  bool _isLoading = false;
  String _searchQuery = '';

  Future<void> _loadJokes() async {
    setState(() => _isLoading = true);
    try {
      _jokes = await _jokeService.fetchJokesRaw();
      _filteredJokes = _jokes;
    } catch (e) {
      print('Error loading jokes: $e');
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _loadJokes();
  }

  void _filterJokesByCategory(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredJokes = _jokes.where((joke) {
        final jokeCategory = (joke['category'] ?? '').toLowerCase();
        return jokeCategory.contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade300, Colors.orange.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: _filterJokesByCategory,
                decoration: InputDecoration(
                  hintText: 'Search by category...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _loadJokes,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 60),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Fetch Jokes',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildJokeList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJokeList() {
    if (_filteredJokes.isEmpty) {
      return const Center(
        child: Text(
          'No jokes available for this category.',
          style: TextStyle(fontSize: 18, color: Colors.orange),
        ),
      );
    }
    return ListView.builder(
      itemCount: _filteredJokes.length,
      itemBuilder: (context, index) {
        final joke = _filteredJokes[index];
        return _buildJokeCard(joke);
      },
    );
  }

  Widget _buildJokeCard(Map<String, dynamic> joke) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.orange.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                joke['category']?.toUpperCase() ?? 'UNKNOWN CATEGORY',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              joke['setup'] != null
                  ? joke['setup']
                  : (joke['joke'] ?? 'No joke setup'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            if (joke['delivery'] != null)
              Text(
                joke['delivery'],
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            if (joke['delivery'] == null)
              const Text(
                "That's the joke!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
