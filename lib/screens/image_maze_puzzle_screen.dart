import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/birthday_config.dart';
import '../widgets/music_control_button.dart';
import '../widgets/sparkle_overlay.dart';
import 'surprise_hub_screen.dart';

class ImageMazePuzzleScreen extends StatefulWidget {
  final BirthdayConfig config;

  const ImageMazePuzzleScreen({super.key, required this.config});

  @override
  State<ImageMazePuzzleScreen> createState() => _ImageMazePuzzleScreenState();
}

class _ImageMazePuzzleScreenState extends State<ImageMazePuzzleScreen> {
  final Random _random = Random();
  int _round = 1;
  int _moves = 0;
  int? _selectedTile;
  List<int> _tiles = [];

  int get _tileCount => _round <= 7 ? 8 : 10;
  double get _photoAspectRatio => const {
    1: 1086 / 1448,
    2: 4096 / 3072,
    3: 900 / 1600,
    4: 899 / 1599,
    5: 1080 / 1095,
    6: 900 / 1600,
    7: 720 / 1600,
    8: 4160 / 3119,
    9: 1280 / 1080,
    10: 1600 / 1066,
  }[_round]!;
  bool get _isLandscape => _photoAspectRatio >= 1;
  int get _columns {
    if (_tileCount == 8) return _isLandscape ? 4 : 2;
    return _isLandscape ? 5 : 2;
  }

  int get _rows => _tileCount ~/ _columns;
  static const double _tileSpacing = 3;
  int get _shuffleMoves => 8 + (_round * 3);
  String get _imagePath => 'assets/puzzles/p$_round.jpg';

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  void _startRound() {
    final shuffled = List<int>.generate(_tileCount, (index) => index);
    for (var index = 0; index < _shuffleMoves; index++) {
      final first = _random.nextInt(_tileCount);
      var second = _random.nextInt(_tileCount);
      while (second == first) {
        second = _random.nextInt(_tileCount);
      }
      final tile = shuffled[first];
      shuffled[first] = shuffled[second];
      shuffled[second] = tile;
    }
    if (List.generate(
      _tileCount,
      (index) => index,
    ).every((index) => shuffled[index] == index)) {
      final tile = shuffled[0];
      shuffled[0] = shuffled[1];
      shuffled[1] = tile;
    }
    setState(() {
      _tiles = shuffled;
      _moves = 0;
      _selectedTile = null;
    });
  }

  void _tapTile(int index) {
    if (_selectedTile == null) {
      setState(() => _selectedTile = index);
      return;
    }
    if (_selectedTile == index) {
      setState(() => _selectedTile = null);
      return;
    }
    final first = _selectedTile!;
    setState(() {
      final tile = _tiles[first];
      _tiles[first] = _tiles[index];
      _tiles[index] = tile;
      _selectedTile = null;
      _moves++;
    });
    if (_tiles.asMap().entries.every((entry) => entry.value == entry.key)) {
      _completeRound();
    }
  }

  void _useHint() {
    final misplaced = <int>[];
    for (var index = 0; index < _tiles.length; index++) {
      if (_tiles[index] != index) misplaced.add(index);
    }
    if (misplaced.isEmpty) return;
    final targetIndex = misplaced.first;
    final sourceIndex = _tiles.indexOf(targetIndex);
    setState(() {
      final tile = _tiles[targetIndex];
      _tiles[targetIndex] = _tiles[sourceIndex];
      _tiles[sourceIndex] = tile;
      _moves++;
      _selectedTile = null;
    });
    if (_tiles.asMap().entries.every((entry) => entry.value == entry.key)) {
      _completeRound();
    }
  }

  void _completeRound() {
    if (_round == 10) {
      _showFinishedDialog();
      return;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF42182D),
        title: Text(
          'Round $_round complete!',
          style: GoogleFonts.greatVibes(
            fontSize: 30,
            color: const Color(0xFFFFD1DC),
          ),
        ),
        content: Text(
          'Beautiful work. The next photo has more pieces to solve.',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _round++);
              _startRound();
            },
            child: const Text(
              'Next photo',
              style: TextStyle(color: Color(0xFFFFB6C1)),
            ),
          ),
        ],
      ),
    );
  }

  void _showFinishedDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF42182D),
        title: Text(
          'Congratulations, Liki! 🎉',
          style: GoogleFonts.greatVibes(
            fontSize: 32,
            color: const Color(0xFFFFD1DC),
          ),
        ),
        content: Text(
          'You solved all 10 puzzles!',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SurpriseHubScreen(config: widget.config),
                ),
              );
            },
            child: const Text(
              'Return to Surprise World',
              style: TextStyle(color: Color(0xFFFFB6C1)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SparkleOverlay(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E0A17), Color(0xFF5A1E3B), Color(0xFF25101E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white70,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Image Maze Puzzle',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.greatVibes(
                            fontSize: 34,
                            color: const Color(0xFFFFD1DC),
                          ),
                        ),
                      ),
                      const MusicControlButton(size: 38),
                    ],
                  ),
                ),
                Text(
                  'Photo $_round of 10  •  $_tileCount blocks',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap two pieces to swap them into place',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boardWidth = min(
                        constraints.maxWidth - 28,
                        constraints.maxHeight * _photoAspectRatio,
                      );
                      final boardHeight = boardWidth / _photoAspectRatio;
                      final tileWidth =
                          (boardWidth - (_columns - 1) * _tileSpacing) /
                          _columns;
                      final tileHeight =
                          (boardHeight - (_rows - 1) * _tileSpacing) / _rows;
                      return Center(
                        child: SizedBox(
                          width: boardWidth,
                          height: boardHeight,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _columns,
                                  crossAxisSpacing: _tileSpacing,
                                  mainAxisSpacing: _tileSpacing,
                                  childAspectRatio: tileWidth / tileHeight,
                                ),
                            itemCount: _tileCount,
                            itemBuilder: (context, index) =>
                                _buildTile(index, boardWidth, boardHeight),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Moves: $_moves',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _useHint,
                        icon: const Icon(
                          Icons.lightbulb_outline_rounded,
                          size: 18,
                        ),
                        label: const Text('Hint'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE05688),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildTile(int index, double boardWidth, double boardHeight) {
    final sourceIndex = _tiles[index];
    final sourceColumn = sourceIndex % _columns;
    final sourceRow = sourceIndex ~/ _columns;
    final tileWidth = (boardWidth - (_columns - 1) * _tileSpacing) / _columns;
    final tileHeight = (boardHeight - (_rows - 1) * _tileSpacing) / _rows;
    final isSelected = _selectedTile == index;
    return GestureDetector(
      onTap: () => _tapTile(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFFFD700) : Colors.white24,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [const BoxShadow(color: Color(0xFFFFD700), blurRadius: 12)]
              : null,
        ),
        child: ClipRect(
          child: Stack(
            children: [
              Positioned(
                left: -sourceColumn * tileWidth,
                top: -sourceRow * tileHeight,
                width: boardWidth,
                height: boardHeight,
                child: Image.asset(_imagePath, fit: BoxFit.fill),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
