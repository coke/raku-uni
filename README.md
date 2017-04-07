# NAME

uni - command-line utility to find or display Unicode characters

# DESCRIPTION

    $ uni ¶
    U+00B6 ¶ PILCROW SIGN [Po]
    
```uni``` will output information from the Unicode DB in Perl 6; The hex code, the character itself, the characters name, and the properties of the character(s) are output.

This verison of uni is *heavily* inspired by the Perl 5 module of the same name. H/T to RJBS.

Since it's in Perl 6 - you get the latest Unicode DB in the compiler (currently 9) and regexes are Perl 6-style.
    
# MODES

## Default

If you pass a single character to ```uni```, then details of that character are printed; Otherwise the codepoint names are searched.

## -s (Single Character)

A single character is processed.

    $ uni -s •
    U+2022 • BULLET [Po]
    
## -n (Name Search)

The text following -n is used to search (case insensitively) through all the codepoints. Note that because we're using Perl 6 case insenstive searches, this works (note the ﬆ ligature). Parameters that start and end with ```/``` are considered regular expressions.

    $ uni -n modeﬆy
    U+4DCE ䷎ HEXAGRAM FOR MODESTY [So]
    
    $ uni -n stroke dotl modifier
    U+1DA1 ᶡ MODIFIER LETTER SMALL DOTLESS J WITH STROKE [Lm]    
    
    $ uni -n /"rev".*"pilcr"/
    U+204B ⁋ REVERSED PILCROW SIGN [Po]
    
## -w (Word Search)

Same as -n, except each parameter must match an entire word.

    $ uni -n cat eyes
    U+1F638 😸 GRINNING CAT FACE WITH SMILING EYES [So]
    U+1F63B 😻 SMILING CAT FACE WITH HEART-SHAPED EYES [So]
    U+1F63D 😽 KISSING CAT FACE WITH CLOSED EYES [So]
    
## -c (Multiple Characters)

Output multiple characters' information at once:

    $uni -c £¢…
    U+00A3 £ POUND SIGN [Sc]
    U+00A2 ¢ CENT SIGN [Sc]
    U+2026 … HORIZONTAL ELLIPSIS [Po]
    
## -n (Codepoint)

Search by hex codepoint:

    $ uni -u 221E 00A7
    U+221E ∞ INFINITY [Sm]
    U+00A7 § SECTION SIGN [Po]

# ACKNOWLEDGEMENTS

This is a re-implementation of the Perl 5 module of the same name, by RJBS: Check out his module for the continued history.
