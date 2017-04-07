use Test;

plan 8;

sub test-run($expected, *@args) {
    my $proc = run('./bin/uni', |@args, :out);
    my $out = $proc.out.lines.join("\n") ~ "\n";
    is $out, $expected, @args.join(' ');
}

# DWIM

test-run(q:to/EOUT/, '∞');
    U+221E ∞ INFINITY [Sm]
    EOUT

test-run(q:to/EOUT/, 'heart', 'shaped');
    U+1F60D 😍 SMILING FACE WITH HEART-SHAPED EYES [So]
    U+1F63B 😻 SMILING CAT FACE WITH HEART-SHAPED EYES [So]
    EOUT

test-run(q:to/EOUT/, '2e', ');
    U+002E . FULL STOP [Po]
    EOUT


# -s
test-run(q:to/EOUT/, '-s', '•');
    U+2022 • BULLET [Po]
    EOUT

# -n
test-run(q:to/EOUT/, '-n', 'modeﬆy');
    U+4DCE ䷎ HEXAGRAM FOR MODESTY [So]
    EOUT

test-run(q:to/EOUT/, '-n', 'stroke', 'dotl', 'modifier');
    U+1DA1 ᶡ MODIFIER LETTER SMALL DOTLESS J WITH STROKE [Lm]
    EOUT

# too slow yet
#test-run(q:to/EOUT/, '-n', '/"rev".*"pilcr"/');
    #U+204B ⁋ REVERSED PILCROW SIGN [Po]
    #EOUT
#

# -w
test-run(q:to/EOUT/, '-w', 'cat', 'eyes');
    U+1F638 😸 GRINNING CAT FACE WITH SMILING EYES [So]
    U+1F63B 😻 SMILING CAT FACE WITH HEART-SHAPED EYES [So]
    U+1F63D 😽 KISSING CAT FACE WITH CLOSED EYES [So]
    EOUT

# -c
test-run(q:to/EOUT/, '-c', 'as', '£¢…');
    U+0061 a LATIN SMALL LETTER A [Ll]
    U+0073 s LATIN SMALL LETTER S [Ll]

    U+00A3 £ POUND SIGN [Sc]
    U+00A2 ¢ CENT SIGN [Sc]
    U+2026 … HORIZONTAL ELLIPSIS [Po]
    EOUT

# -u
test-run(q:to/EOUT/, '-u', '221E', '00A7');
    U+221E ∞ INFINITY [Sm]
    U+00A7 § SECTION SIGN [Po]
    EOUT
