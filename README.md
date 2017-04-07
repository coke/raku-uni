# NAME

uni - command-line utility to find or display Unicode characters

# DESCRIPTION

    $ uni ¶
    U+0000B6 ¶ PILCROW SIGN [Po]
    
```uni``` will output information from the Unicode DB in Perl 6; The hex code, the character itself, the characters name, and the properties of the character(s) are output.

This verison of uni is *heavily* inspired by the Perl 5 module of the same name. H/T to RJBS.

Since it's in Perl 6 - you get the latest Unicode DB in the compiler (currently 9) and regexes are Perl 6-style.
    
# MODES

## Default

If you pass a single character to ```uni```, then details of that character are printed; Otherwise the codepoint names are searched.

## -s (Single Character)

A single character is processed.

    $ uni -s •
    U+002022 • BULLET [Po]
    
## -n (Name Search)

The text following -n is used to search (case insensitively) through all the codepoints. Parameters that start and end with ```/``` are considered regular expressions.

    $ uni -n modeﬆy # note the ﬆ ligature
    U+004DCE ䷎ HEXAGRAM FOR MODESTY [So]

    $ uni -n stroke dotl modifier
    U+001DA1 ᶡ MODIFIER LETTER SMALL DOTLESS J WITH STROKE [Lm]

    $ uni -n /"rev".*"pilcr"/ # note, has to be one shell arg
    U+00204B ⁋ REVERSED PILCROW SIGN [Po]

## -w (Word Search)

Same as -n, except each parameter must match an entire word.

    $ uni -w cat eyes
    U+001F638 😸 GRINNING CAT FACE WITH SMILING EYES [So]
    U+001F63B 😻 SMILING CAT FACE WITH HEART-SHAPED EYES [So]
    U+001F63D 😽 KISSING CAT FACE WITH CLOSED EYES [So]
    
## -c (Multiple Characters)

Output multiple characters' information at once:

    $uni -c £¢…
    U+0000A3 £ POUND SIGN [Sc]
    U+0000A2 ¢ CENT SIGN [Sc]
    U+002026 … HORIZONTAL ELLIPSIS [Po]
    
## -u (Codepoint)

Search by hex codepoint:

    $ uni -u 221E 00A7
    U+00221E ∞ INFINITY [Sm]
    U+0000A7 § SECTION SIGN [Po]

# ACKNOWLEDGEMENTS

This is a re-implementation of the Perl 5 module of the same name, by RJBS: Check out his module for the continued history.
