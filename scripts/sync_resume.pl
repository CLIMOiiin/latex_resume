#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use File::Spec;

my $input_file = 'content.md';
my $header_out = 'build/content_header.tex';
my $body_out   = 'build/content_body.tex';

if (!-f $input_file) {
    die "Missing $input_file\n";
}

open my $in_fh, '<:encoding(UTF-8)', $input_file or die "Cannot open $input_file: $!\n";
open my $hdr_fh, '>:encoding(UTF-8)', $header_out or die "Cannot open $header_out: $!\n";
open my $body_fh, '>:encoding(UTF-8)', $body_out or die "Cannot open $body_out: $!\n";

my $in_itemize = 0;
my $name       = '姓名';
my $contact    = '手机号 丨 邮箱 丨 城市';
my $profile    = '年龄 丨 专业方向 丨 求职意向';

sub trim {
    my ($s) = @_;
    $s =~ s/^\s+//;
    $s =~ s/\s+$//;
    return $s;
}

sub esc {
    my ($s) = @_;
    $s =~ s/&/\\&/g;
    $s =~ s/%/\\%/g;
    $s =~ s/#/\\#/g;
    $s =~ s/_/\\_/g;
    $s =~ s/\$/\\\$/g;
    $s =~ s/\^/\\textasciicircum{}/g;
    $s =~ s/~/\\textasciitilde{}/g;
    return $s;
}

sub close_itemize {
    my ($fh, $state_ref) = @_;
    if ($$state_ref) {
        print {$fh} "\\end{itemize}\n";
        $$state_ref = 0;
    }
}

while (my $line = <$in_fh>) {
    $line =~ s/\r?\n$//;

    if ($line =~ /^name:\s*(.*)$/) {
        $name = trim($1);
        next;
    }
    if ($line =~ /^contact:\s*(.*)$/) {
        $contact = trim($1);
        next;
    }
    if ($line =~ /^profile:\s*(.*)$/) {
        $profile = trim($1);
        next;
    }

    if ($line =~ /^##\s+(.+)$/) {
        close_itemize($body_fh, \$in_itemize);
        my $sec = esc(trim($1));
        print {$body_fh} "\n";
        print {$body_fh} "\\section{$sec}\n";
        next;
    }

    if ($line =~ /^\@entry\s+(.+)$/) {
        close_itemize($body_fh, \$in_itemize);
        my @a = map { esc(trim($_)) } split /\|/, $1, 4;
        push @a, ('') x (4 - @a);
        print {$body_fh} "\n";
        print {$body_fh} "\\cventry{$a[0]}{$a[1]}{$a[2]}{$a[3]}\n";
        next;
    }

    if ($line =~ /^\@edu\s+(.+)$/) {
        close_itemize($body_fh, \$in_itemize);
        my @a = map { esc(trim($_)) } split /\|/, $1, 4;
        push @a, ('') x (4 - @a);
        print {$body_fh} "\n";
        print {$body_fh} "\\eduentry{$a[0]}{$a[1]}{$a[2]}{$a[3]}\n";
        next;
    }

    if ($line =~ /^\@work\s+(.+)$/) {
        close_itemize($body_fh, \$in_itemize);
        my @a = map { esc(trim($_)) } split /\|/, $1, 4;
        push @a, ('') x (4 - @a);
        print {$body_fh} "\n";
        print {$body_fh} "\\cventry{$a[0]}{$a[2]}{$a[1]}{}\n";
        next;
    }

    if ($line =~ /^\@practice\s+(.+)$/) {
        close_itemize($body_fh, \$in_itemize);
        my @a = map { esc(trim($_)) } split /\|/, $1, 4;
        push @a, ('') x (4 - @a);
        print {$body_fh} "\n";
        print {$body_fh} "\\workentry{$a[0]}{$a[1]}{$a[2]}{$a[3]}\n";
        next;
    }

    if ($line =~ /^-\s+(.+)$/) {
        my $text = esc(trim($1));
        if (!$in_itemize) {
            print {$body_fh} "\\begin{itemize}\n";
            $in_itemize = 1;
        }
        print {$body_fh} "  \\item $text\n";
        next;
    }

    if ($line =~ /^\s*$/) {
        close_itemize($body_fh, \$in_itemize);
        print {$body_fh} "\n";
        next;
    }

    close_itemize($body_fh, \$in_itemize);

    my $trimmed = trim($line);
    if ($trimmed =~ /^\\/) {
        print {$body_fh} "$trimmed\n";
    } else {
        print {$body_fh} esc($line) . "\n";
    }
}

close_itemize($body_fh, \$in_itemize);

print {$hdr_fh} '{\\Large\\bfseries ' . esc($name) . '}\\\\[4pt]' . "\n";
print {$hdr_fh} esc($contact) . '\\\\' . "\n";
print {$hdr_fh} esc($profile) . "\n";

close $in_fh;
close $hdr_fh;
close $body_fh;

print "Generated $header_out and $body_out from $input_file\n";
