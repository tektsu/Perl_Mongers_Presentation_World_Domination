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

my $red = RPi::Led->new(
	name    => 'Red LED',
	pin     => Device::BCM2835::RPI_GPIO_P1_12,
	onTime  => 750,
	offTime => 250);
my $topButton = RPi::Button->new(
	name => 'Top Button',
	pin  => Device::BCM2835::RPI_GPIO_P1_11);
my $middleButton = RPi::Button->new(
	name => 'Middle Button',
	pin  => Device::BCM2835::RPI_GPIO_P1_13);
my $bottomButton = RPi::Button->new(
	name => 'Bottom Button',
	pin  => Device::BCM2835::RPI_GPIO_P1_15);
my $buttons = [ $topButton, $middleButton, $bottomButton ];

while (1) {
	$red->updateBlink;
	for my $button (@$buttons) {
		my ($changed, $state, $name) = $button->getState;
		if ($changed) {
			print "$name: " . ($state ? "On" : "Off") . "\n";
		}
	}
	last if $topButton->getState && $bottomButton->getState;
}

print "Done\n";

