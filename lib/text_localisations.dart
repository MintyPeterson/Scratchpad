import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provides text localisations for multi-language support.
class TextLocalisations {
  TextLocalisations(this.locale);

  final Locale locale;

  static TextLocalisations of(BuildContext context) {
    return Localizations.of<TextLocalisations>(context, TextLocalisations)!;
  }

  static const _localisedValues = <String, Map<String, String>>{
    'en': {
      'title': 'Scratchpad',
      'clearScratchpadTitle': 'Clear scratchpad?',
      'clearScratchpadDescription': 'All notes will be deleted.',
      'cancelButton': 'CANCEL',
      'clearButton': 'CLEAR',
      'notesCopiedMessage': 'Notes copied to clipboard.',
      'clipboardMenuItem': 'Clipboard',
      'copyMenuItem': 'Copy',
      'pasteMenuItem': 'Paste',
      'formattingMenuItem': 'Formatting',
      'removeEmptyLinesMenuItem': 'Remove empty lines',
      'trimWhitespaceMenuItem': 'Trim whitespace',
    },
  };

  static List<String> languages() => _localisedValues.keys.toList();

  String get title {
    return _localisedValues[locale.languageCode]!['title']!;
  }

  String get clearScratchpadTitle {
    return _localisedValues[locale.languageCode]!['clearScratchpadTitle']!;
  }

  String get clearScratchpadDescription {
    return _localisedValues[locale.languageCode]![
        'clearScratchpadDescription']!;
  }

  String get cancelButton {
    return _localisedValues[locale.languageCode]!['cancelButton']!;
  }

  String get clearButton {
    return _localisedValues[locale.languageCode]!['clearButton']!;
  }

  String get notesCopiedMessage {
    return _localisedValues[locale.languageCode]!['notesCopiedMessage']!;
  }

  String get clipboardMenuItem {
    return _localisedValues[locale.languageCode]!['clipboardMenuItem']!;
  }

  String get copyMenuItem {
    return _localisedValues[locale.languageCode]!['copyMenuItem']!;
  }

  String get pasteMenuItem {
    return _localisedValues[locale.languageCode]!['pasteMenuItem']!;
  }

  String get formattingMenuItem {
    return _localisedValues[locale.languageCode]!['formattingMenuItem']!;
  }

  String get removeEmptyLinesMenuItem {
    return _localisedValues[locale.languageCode]!['removeEmptyLinesMenuItem']!;
  }

  String get trimWhitespaceMenuItem {
    return _localisedValues[locale.languageCode]!['trimWhitespaceMenuItem']!;
  }
}

/// A delegate for [TextLocalisations].
class TextLocalisationsDelegate
    extends LocalizationsDelegate<TextLocalisations> {
  const TextLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      TextLocalisations.languages().contains(locale.languageCode);

  @override
  Future<TextLocalisations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async load operation
    // isn't needed to produce an instance of TextLocalisations.
    return SynchronousFuture<TextLocalisations>(TextLocalisations(locale));
  }

  @override
  bool shouldReload(TextLocalisationsDelegate old) => false;
}
