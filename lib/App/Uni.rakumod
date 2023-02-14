unit class App::Uni:ver<1.0.1>;

# Given a single character, output hex, char itself, name, and props
multi sub uni-gist(Str $char) is export {
    my $props = ' [' ~ $char.uniprops ~ ']';
    ($char, "U+" ~ $char.ord.fmt('%06X'), $char.uninames).join(' - ') ~ $props
}

multi sub uni-gist(Int $code) is export {
    uni-gist($code.chr);
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
