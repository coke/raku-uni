unit class App::Uni:ver<1.0.4>;

our %properties;

# Given a single character, output hex, char itself, name, and props
multi sub uni-gist(Str $char, :$verbose=False) is export {
    my $props = ' [' ~ $char.uniprops ~ ']';
    my $result = ($char, "U+" ~ $char.ord.fmt('%06X'), $char.uninames).join(' - ') ~ $props;
    if $verbose {
        my @props = [
            'Script' => 'Unicode Script',
            'Block' => 'Unicode Block',
            'Age' => 'Added in Unicode',
            'white_space' => 'White Space',
            'East_Asian_Width' => 'Width'
        ];

        sub add-line($value, $key, $width) {
            my $line = '';
            $line ~= "\n    $value:";
            $line ~= ' ' x 1 + $width - $value.chars;
            $line ~= $key;
        }
        my $max-width = @props.sort(-*.value.chars)[0].value.chars;

        $result ~= add-line('Properties', (%properties{$char.uniprops}).join('; '), $max-width);

        for @props -> $property {
            $result ~= add-line($property.value, ($char.uniprops: $property.key), $max-width);
        }
    }
    $result;
}

multi sub uni-gist(Int $code) is export {
    uni-gist($code.chr);
}

# Given a single character, output bunny meme
sub uni-bunny(Str $char) is export {
    my $bunny = q:to/EOB/;

(\_/)
(•_•)
/ > 

EOB
    $bunny .= trim;
    $bunny ~= ' ' ~ $char;

    $bunny ~ "\n\n" ~ uni-gist($char);
}

# Search through all codepoint names, optionally as whole word
sub uni-search(@criteria, :$w) is export {
    my @strings;
    my @regexes;
    for @criteria -> $criteria {
        if $criteria.starts-with('/') && $criteria.ends-with('/') {
            my $re = $criteria.substr(1,$criteria.chars-2).fc;
            if $w {
                @regexes.push(/« <$re> »/);
            } else {
                @regexes.push(/<$re>/);
            }
            if $criteria ~~ / '"' $<word>=[ \w*] '"' / {
                @strings.push(~$<word>.fc);
            }
        } else {
            my $string = $criteria.fc;
            if $w {
                @regexes.push(/« <$string> »/);
            }
            @strings.push($string);
        }
    }

    my $sieve = 0..0x10FFFF;
    my $lock = Lock::Async.new;
    # If we can do a search by string first, do so - faster and trims the list for regexes
    @strings.hyper.map: -> $criteria {
        $lock.protect: {
            $sieve .= grep({uniname($_).fc.contains($criteria)});
        }
    }
    @regexes.hyper.map: -> $criteria {
        $lock.protect: {
            $sieve .= grep({uniname($_).fc ~~ $criteria});
        }
    }
    $sieve.sort.unique.map({say uni-gist $_});
}

# List of expanded properties.
%properties = L  => 'Letter',
Lu => 'Letter, uppercase',
Ll => 'Letter, lowercase',
Lt => 'Letter, titlecase',
Lm => 'Letter, modifier',
Lo => 'Letter, other',
M  => 'Mark',
Mn => 'Mark, nonspacing',
Mc => 'Mark, spacing combining',
Me => 'Mark, enclosing',
N  => 'Number',
Nd => 'Number, decimal digit',
Nl => 'Number, letter',
No => 'Number, other',
P  => 'Punctuation',
Pc => 'Punctuation, connector',
Pd => 'Punctuation, dash',
Ps => 'Punctuation, open bracket',
Pe => 'Punctuation, close bracket',
Pi => 'Punctuation, initial quote',
Pf => 'Punctuation, final quote',
Po => 'Punctuation, other',
S  => 'Symbol',
Sm => 'Symbol, math',
Sc => 'Symbol, currency',
Sk => 'Symbol, modifier',
So => 'Symbol, other',
Z  => 'Separator',
Zs => 'Separator, space',
Zl => 'Separator, line',
Zp => 'Separator, paragraph',
C  => 'Other',
Cc => 'Other, control',
Cf => 'Other, format',
Cs => 'Other, surrogate',
Co => 'Other, private use',
Cn => 'Other, not assigned';
