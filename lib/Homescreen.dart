import 'package:astrotalk/Astrolgers%20list.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class HomeScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String? birthTime;
  final String? birthPlace;

  const HomeScreen({
    super.key,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.birthTime,
    this.birthPlace,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _responseController = TextEditingController();
  GenerativeModel? _model;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAI();
    _generateHoroscope();
  }

  void _initializeAI() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey ?? '',
    );
  }

  Future<void> _generateHoroscope() async {
    if (_model == null || widget.dateOfBirth == null) return;

    setState(() {
      _isLoading = true;
      _responseController.text = '';
    });

    try {
      final prompt = "Generate a detailed horoscope reading based on the following information:\n"
          "Name: ${widget.firstName} ${widget.lastName}\n"
          "Date of Birth: ${widget.dateOfBirth}\n"
          "Birth Time: ${widget.birthTime}\n"
          "Birth Place: ${widget.birthPlace}\n"
          "Please show Zodiac Sign, Career prospects, and life path predictions all in short.";

      final content = [Content.text(prompt)];

      final stream = _model!.generateContentStream(content);

      await for (final chunk in stream) {
        if (chunk.text != null) {
          setState(() {
            _responseController.text += chunk.text!;
          });
        }
      }
    } catch (e) {
      setState(() {
        _responseController.text = 'Error generating horoscope: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF495046),
      appBar: AppBar(
        title: const Text('Your Horoscope', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF495046),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.firstName != null) ...[
              Text('Name: ${widget.firstName} ${widget.lastName}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              Text('Date of Birth: ${widget.dateOfBirth}',
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 8),
              Text('Birth Time: ${widget.birthTime}',
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 8),
              Text('Birth Place: ${widget.birthPlace}',
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 16),
              const Divider(color: Colors.white),
              const SizedBox(height: 16),
            ],
            const Text(
              'Your Personalized Horoscope Reading',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : SingleChildScrollView(
                child: TextField(
                  controller: _responseController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Your horoscope reading will appear here...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  maxLines: null,
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AstrologersList()),
                  );
                },
                child: const Text(
                  'Chat with us',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
