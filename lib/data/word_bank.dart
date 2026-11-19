import 'dart:math';

import '../models/word_entry.dart';

class WordBank {
  static const entries = <WordEntry>[
    WordEntry(word: 'Elephant', category: 'Animals', lowerCategory: 'Large mammals', hint: 'A familiar face on many safari postcards', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Dolphin', category: 'Animals', lowerCategory: 'Marine mammals', hint: 'Some holiday photos include an unexpected visitor beside the boat', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Penguin', category: 'Animals', lowerCategory: 'Flightless birds', hint: 'A crowd that looks ready for a formal event', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Pizza', category: 'Food', lowerCategory: 'Baked dishes', hint: 'The argument can get surprisingly serious over one topping', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Pancake', category: 'Food', lowerCategory: 'Breakfast foods', hint: 'A stack that rarely survives long on the breakfast table', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Sushi', category: 'Food', lowerCategory: 'Japanese dishes', hint: 'A meal where chopsticks sometimes become part of the challenge', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Guitar', category: 'Musical Instruments', lowerCategory: 'String instruments', hint: 'A song can start before anyone has found the lyrics', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Piano', category: 'Musical Instruments', lowerCategory: 'Keyboard instruments', hint: 'Some people learn it one hand at a time', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Drums', category: 'Musical Instruments', lowerCategory: 'Percussion instruments', hint: 'The rhythm is often noticed before the melody', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Volcano', category: 'Nature', lowerCategory: 'Geological features', hint: 'Locals may keep an eye on the mountain', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Rainbow', category: 'Nature', lowerCategory: 'Atmospheric phenomena', hint: 'A brief reason to stop walking and look up', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Waterfall', category: 'Nature', lowerCategory: 'Water features', hint: 'The sound often reaches you before the view', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Bicycle', category: 'Transport', lowerCategory: 'Two-wheeled transport', hint: 'A short trip can become a race without anyone planning it', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Helicopter', category: 'Transport', lowerCategory: 'Aircraft', hint: 'A rescue scene in a film often includes this arrival', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Submarine', category: 'Transport', lowerCategory: 'Watercraft', hint: 'A crew can spend weeks without seeing the horizon', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Telescope', category: 'Science', lowerCategory: 'Optical instruments', hint: 'A backyard can feel much bigger on a clear night', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Microscope', category: 'Science', lowerCategory: 'Laboratory instruments', hint: 'A drop of water may contain more than it seems', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Smartphone', category: 'Technology', lowerCategory: 'Personal electronics', hint: 'A low battery can change the plans for the day', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Lighthouse', category: 'Places', lowerCategory: 'Navigation structures', hint: 'Its job matters most when visibility is poor', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Airport', category: 'Places', lowerCategory: 'Transport hubs', hint: 'A board full of changing numbers decides where people go next', difficulty: WordDifficulty.medium),

    WordEntry(word: 'Cat', category: 'Animals', lowerCategory: 'Domestic animals', hint: 'The internet has made this animal unexpectedly famous', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Dog', category: 'Animals', lowerCategory: 'Domestic animals', hint: 'Often knows someone has arrived before the door opens', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Lion', category: 'Animals', lowerCategory: 'Wild cats', hint: 'Its voice is often used as an introduction in movies and shows', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Tiger', category: 'Animals', lowerCategory: 'Wild cats', hint: 'Its appearance is hard to mistake in a crowd', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Giraffe', category: 'Animals', lowerCategory: 'African wildlife', hint: 'A familiar sight in children''s picture books', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Camel', category: 'Animals', lowerCategory: 'Desert animals', hint: 'It has a long history in trade and travel', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Owl', category: 'Animals', lowerCategory: 'Birds', hint: 'Frequently appears alongside wise characters in stories', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Fox', category: 'Animals', lowerCategory: 'Wild mammals', hint: 'Usually gets the clever role in stories', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Rabbit', category: 'Animals', lowerCategory: 'Small mammals', hint: 'A magician''s classic surprise guest', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Shark', category: 'Animals', lowerCategory: 'Sea creatures', hint: 'Even a harmless-looking scene can feel tense when one appears', difficulty: WordDifficulty.medium),

    WordEntry(word: 'Burger', category: 'Food', lowerCategory: 'Fast food', hint: 'Keeping everything together for the first bite can be a challenge', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Sandwich', category: 'Food', lowerCategory: 'Quick meals', hint: 'Often the easiest choice when you''re in a hurry', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Ice Cream', category: 'Food', lowerCategory: 'Frozen desserts', hint: 'Choosing just one flavour is sometimes the hardest part', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Chocolate', category: 'Food', lowerCategory: 'Sweets', hint: 'A small piece can somehow turn into the whole bar disappearing', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Popcorn', category: 'Food', lowerCategory: 'Movie snacks', hint: 'It tends to disappear before the main event is over', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Noodles', category: 'Food', lowerCategory: 'Quick meals', hint: 'The meal can get surprisingly noisy', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Donut', category: 'Food', lowerCategory: 'Baked sweets', hint: 'A classic snack in old police-station scenes', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Cake', category: 'Food', lowerCategory: 'Desserts', hint: 'Usually gets attention before anyone starts eating', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Watermelon', category: 'Food', lowerCategory: 'Fruits', hint: 'Summer gatherings often involve a messy slice', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Mango', category: 'Food', lowerCategory: 'Fruits', hint: 'People can have surprisingly strong opinions about the best variety', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Coffee', category: 'Drinks', lowerCategory: 'Hot drinks', hint: 'Some people have a very particular way of ordering it', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Tea', category: 'Drinks', lowerCategory: 'Hot drinks', hint: 'Often accompanies a conversation that lasts longer than expected', difficulty: WordDifficulty.medium),

    WordEntry(word: 'Umbrella', category: 'Everyday objects', lowerCategory: 'Weather accessories', hint: 'You rarely think about it until the weather changes', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Sunglasses', category: 'Everyday objects', lowerCategory: 'Wearable accessories', hint: 'Often make an appearance in holiday photos', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Mirror', category: 'Everyday objects', lowerCategory: 'Personal care items', hint: 'Usually gets one last look before someone leaves', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Clock', category: 'Everyday objects', lowerCategory: 'Household accessories', hint: 'Some people wish it would move faster', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Camera', category: 'Everyday objects', lowerCategory: 'Electronics', hint: 'Everyone suddenly becomes an expert when a special moment arrives', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Backpack', category: 'Everyday objects', lowerCategory: 'Bags', hint: 'Usually gets heavier as the day goes on', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Key', category: 'Everyday objects', lowerCategory: 'Small accessories', hint: 'A tiny object can decide whether you get inside', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Wallet', category: 'Everyday objects', lowerCategory: 'Personal accessories', hint: 'Its absence can ruin an otherwise ordinary outing', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Pillow', category: 'Everyday objects', lowerCategory: 'Bedroom items', hint: 'The choice can make or break a good night''s sleep', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Blanket', category: 'Everyday objects', lowerCategory: 'Bedroom items', hint: 'Suddenly becomes everyone''s favourite during a cold night', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Fan', category: 'Everyday objects', lowerCategory: 'Home appliances', hint: 'Its familiar sound often becomes background noise', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Book', category: 'Everyday objects', lowerCategory: 'Reading materials', hint: 'A good one can make a long journey feel short', difficulty: WordDifficulty.medium),

    WordEntry(word: 'Desert', category: 'Nature', lowerCategory: 'Landscapes', hint: 'Days and nights can feel like two different worlds', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Glacier', category: 'Nature', lowerCategory: 'Ice formations', hint: 'It can take centuries to notice how much it has changed', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Forest', category: 'Nature', lowerCategory: 'Natural habitats', hint: 'Getting lost here is a common story in films', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Thunder', category: 'Nature', lowerCategory: 'Weather events', hint: 'Sometimes the sound arrives after the most dramatic part', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Lightning', category: 'Nature', lowerCategory: 'Weather events', hint: 'For a brief moment, the entire sky can look different', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Moon', category: 'Nature', lowerCategory: 'Space objects', hint: 'People have found countless ways to include it in songs and stories', difficulty: WordDifficulty.medium),

    WordEntry(word: 'Football', category: 'Sports', lowerCategory: 'Team ball sports', hint: 'One moment can change the mood of an entire crowd', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Cricket', category: 'Sports', lowerCategory: 'Field sports', hint: 'A quiet afternoon can suddenly become very loud', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Tennis', category: 'Sports', lowerCategory: 'Racket sports', hint: 'A long rally can make spectators forget to blink', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Badminton', category: 'Sports', lowerCategory: 'Racket sports', hint: 'It looks much easier until you try to keep up', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Chess', category: 'Games', lowerCategory: 'Board games', hint: 'One careless decision can undo a long plan', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Carrom', category: 'Games', lowerCategory: 'Board games', hint: 'A little powder can make all the difference', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Basketball', category: 'Sports', lowerCategory: 'Team ball sports', hint: 'The final few seconds can be the most exciting', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Volleyball', category: 'Sports', lowerCategory: 'Team ball sports', hint: 'A rally can continue long after everyone expects it to end', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Table Tennis', category: 'Sports', lowerCategory: 'Racket sports', hint: 'The ball can disappear from sight during a fast exchange', difficulty: WordDifficulty.medium),
    WordEntry(word: 'Hide and Seek', category: 'Games', lowerCategory: 'Group games', hint: 'The best strategy sometimes involves staying completely still', difficulty: WordDifficulty.medium),
  ];

  static List<WordEntry> entriesFor(WordDifficulty difficulty) {
    return entries
        .where((entry) => entry.difficulty == difficulty)
        .toList();
  }

  static bool hasWordsFor(WordDifficulty difficulty) {
    return entries.any((entry) => entry.difficulty == difficulty);
  }

  static WordEntry pickRandom({
    required WordDifficulty difficulty,
    Random? random,
  }) {
    final availableEntries = entriesFor(difficulty);

    if (availableEntries.isEmpty) {
      throw StateError('No words available for this difficulty.');
    }

    final source = random ?? Random();
    return availableEntries[source.nextInt(availableEntries.length)];
  }
}