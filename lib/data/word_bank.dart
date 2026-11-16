import 'dart:math';

import '../models/word_entry.dart';

class WordBank {
  static const entries = <WordEntry>[
    WordEntry(word: 'Elephant', category: 'Animals', hint: 'A large land mammal'),
    WordEntry(word: 'Dolphin', category: 'Animals', hint: 'An intelligent sea mammal'),
    WordEntry(word: 'Penguin', category: 'Animals', hint: 'A flightless bird'),
    WordEntry(word: 'Pizza', category: 'Food', hint: 'A baked dish with toppings'),
    WordEntry(word: 'Pancake', category: 'Food', hint: 'A flat breakfast dish'),
    WordEntry(word: 'Sushi', category: 'Food', hint: 'A popular Japanese dish'),
    WordEntry(word: 'Guitar', category: 'Musical Instruments', hint: 'A string instrument'),
    WordEntry(word: 'Piano', category: 'Musical Instruments', hint: 'An instrument with keys'),
    WordEntry(word: 'Drums', category: 'Musical Instruments', hint: 'An instrument played by striking'),
    WordEntry(word: 'Volcano', category: 'Nature', hint: 'A mountain that can erupt'),
    WordEntry(word: 'Rainbow', category: 'Nature', hint: 'A colourful arc in the sky'),
    WordEntry(word: 'Waterfall', category: 'Nature', hint: 'Falling water in a natural setting'),
    WordEntry(word: 'Bicycle', category: 'Transport', hint: 'A two-wheeled vehicle'),
    WordEntry(word: 'Helicopter', category: 'Transport', hint: 'An aircraft with rotating blades'),
    WordEntry(word: 'Submarine', category: 'Transport', hint: 'A vessel that travels underwater'),
    WordEntry(word: 'Telescope', category: 'Science', hint: 'An instrument for viewing distant objects'),
    WordEntry(word: 'Microscope', category: 'Science', hint: 'An instrument for viewing tiny objects'),
    WordEntry(word: 'Smartphone', category: 'Technology', hint: 'A handheld electronic device'),
    WordEntry(word: 'Lighthouse', category: 'Places', hint: 'A tower near the sea'),
    WordEntry(word: 'Airport', category: 'Places', hint: 'A place where aircraft arrive and depart'),
  ];

  static WordEntry pickRandom({Random? random}) {
    final source = random ?? Random();
    return entries[source.nextInt(entries.length)];
  }
}