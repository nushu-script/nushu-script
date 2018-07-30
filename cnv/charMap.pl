#!/usr/bin/env perl
use strict;
use warnings;
use Encode;
use 5.010;
binmode STDIN, ':utf8';
binmode STDOUT, ':utf8';

my @arr_chars;
my @arr_nushu;
my $chars;
my $nushu;
Encode::_utf8_on($nushu);
Encode::_utf8_on($chars);

sub insert {
    if ($nushu) {
        for (0 .. $#arr_chars) {
            if ($arr_chars[$_] eq $&) {
                $arr_nushu[$_] .= '|' . $nushu;
                return;
            }
        }
        push @arr_chars, $&;
        push @arr_nushu, $nushu;
    }
}

<STDIN>;  # Skip heading

while (<STDIN>) {
    /^[^\t]*?\t[^\t]*?\t([^\t]*?)\t[^\t]*?\t([^\t]*?)\t[^\t]*?\t[^\t]*?$/;
    $nushu = $1;
    $chars = $2;

    while ($chars =~ /./) {
        insert();
        $chars = $';
    }
}

print << 'EOF';
var charMap=
{
EOF

print '"', shift @arr_chars, '":"', shift @arr_nushu, '"';

while (@arr_chars) {
    print ",\n\"", shift @arr_chars, '":"', shift @arr_nushu, '"';
}

print << 'EOF';

}
EOF