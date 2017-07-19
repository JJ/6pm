#!/usr/bin/env perl6
use v6;
use App::six-pm::SixPM;
my $*MAIN-ALLOW-NAMED-ANYWHERE = True;

my $*DEBUG = so %*ENV<_6PM_DEBUG>;

my IO::Path $base-dir   = ".".IO.resolve;
my IO::Path $default-to = $base-dir.child: "perl6-modules";

my $six-pm = SixPM.new: :$base-dir, :$default-to;


multi MAIN("init") {
	$six-pm.init
}

multi MAIN("install", Bool :f(:$force)) {
	$six-pm.install-deps: :$force
}

multi MAIN("install", +@modules, Bool :f(:$force), Bool :$save) {
	$six-pm.install: @modules, :$force, :$save
}

multi MAIN("exec", +@argv, *%pars where *.elems >= 1) is hidden-from-USAGE {
    die "Please, use -- before the command"
}

multi MAIN("exec", +@argv) {
	$six-pm.exec: @argv
}

multi MAIN("exec-file", +@argv) {
	$six-pm.exec: ["perl6", |@argv]
}

multi MAIN("run", Str() $script) {
	$six-pm.run: $script
}

enum Scripts <test start stop>;

multi MAIN(Scripts $script) {
	$six-pm.run: $script.key
}
