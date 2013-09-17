#!/usr/bin/perl

use Net::OpenSoundControl::Server;
use Data::Dumper qw(Dumper);

sub dumpmsg {
	my ($sender, $message) = @_;
	return if $message->[0] eq '/accxyz';

	print "[$sender] ", Dumper $message;
}

my $server = Net::OpenSoundControl::Server->new(
	Port    => 8000,
	Handler => \&dumpmsg)
	or
	die "Could not start server: $@\n";

$server->readloop();
