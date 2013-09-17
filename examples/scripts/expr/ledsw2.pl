#!/usr/bin/perl
use Device::BCM2835;
use strict;
use warnings;
use lib qw|../../modules|;
use RPi::Button;
use RPi::Led;
use Time::HiRes qw/gettimeofday tv_interval/;

exec "sudo $0 " . join(' ', @ARGV) if $<;
$SIG{INT} = sub { exit; };

#Device::BCM2835::set_debug(1);
Device::BCM2835::init() || die "Could not init library";

my $red    = RPi::Led->new(pin => Device::BCM2835::RPI_GPIO_P1_12);
my $yellow = RPi::Led->new(pin => Device::BCM2835::RPI_GPIO_P1_16);
my $green  = RPi::Led->new(pin => Device::BCM2835::RPI_GPIO_P1_18);
my $topButton    = RPi::Button->new(pin => Device::BCM2835::RPI_GPIO_P1_11);
my $middleButton = RPi::Button->new(pin => Device::BCM2835::RPI_GPIO_P1_13);
my $bottomButton = RPi::Button->new(pin => Device::BCM2835::RPI_GPIO_P1_15);

while (1) {
	if ($topButton->getState) {
		$red->on unless $red->getState;
	}
	else {
		$red->off if $red->getState;
	}
	if ($middleButton->getState) {
		$yellow->on unless $yellow->getState;
	}
	else {
		$yellow->off if $yellow->getState;
	}
	if ($bottomButton->getState) {
		$green->on unless $green->getState;
	}
	else {
		$green->off if $green->getState;
	}
	last if $topButton->getState && $bottomButton->getState;
}

print "Done\n";

