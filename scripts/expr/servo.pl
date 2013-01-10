#!/usr/bin/perl
use strict;
use warnings;
use lib qw|../../modules|;
use RPi::Button;
use RPi::PWM::Servo;
use Time::HiRes qw/usleep/;

exec "sudo $0 " . join(' ', @ARGV) if $<;
$SIG{INT} = sub { exit; };

Device::BCM2835::init() || die "Could not init library";

my $servo = RPi::PWM::Servo->new(servoMax => 180, angle => 0, activate => 1);

my $delay = 500000;
$servo->center;
usleep($delay);
$servo->right;
usleep($delay);
$servo->center;
usleep($delay);
$servo->left;
usleep($delay);

# Handle buttons
my $leftButton = RPi::Button->new(
	name => 'Go Left',
	pin => Device::BCM2835::RPI_GPIO_P1_11,
);
my $centerButton = RPi::Button->new(
	name => 'Center',
	pin => Device::BCM2835::RPI_GPIO_P1_13,
);
my $rightButton = RPi::Button->new(
	name => 'Go Right',
	pin => Device::BCM2835::RPI_GPIO_P1_15,
);

my $incrementAngle = 5;
while (1) {
	last if $leftButton->getState && $rightButton->getState;
	if ($leftButton->getState) {
		$servo->incLeft($incrementAngle);
		usleep($delay);
	}
	if ($centerButton->getState) {
		$servo->center;
		usleep($delay);
	}
	if ($rightButton->getState) {
		$servo->incRight($incrementAngle);
		usleep($delay);
	}
}

$servo->left;
usleep($delay);

