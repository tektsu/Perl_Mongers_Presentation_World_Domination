#!/usr/bin/perl
use strict;
use warnings;
use lib qw|../../modules|;
use Device::BCM2835;
use RPi::MCP3008;
use RPi::PWM::PWM;

exec "sudo $0 " . join(' ', @ARGV) if $<;

Device::BCM2835::init() || die "Could not init library";
$SIG{INT} = sub { exit; };

use constant MAX_VALUE => 1023;
use constant JITTER    => 5;

my $pwm = RPi::PWM::PWM->new(dutyCycle => 0, frequency => 100, activate => 1);

my $adc = RPi::MCP3008->new;

my $oldValue = MAX_VALUE + (2 * JITTER);
while (1) {

	# Read the value on CH0
	my $value = $adc->readChannel(0);

	# De-jitter - don't recognize changes of < abt 16mV
	if (abs($value - $oldValue) <= JITTER) {
		next unless $value != $oldValue && ($value == 0 || $value == MAX_VALUE);
	}

	# Print the value
	my $dutyCycle = int(100 * ($value / MAX_VALUE));
	print "$dutyCycle\n";
	$pwm->setDutyCycle($dutyCycle);

	# Look for next value
	$oldValue = $value;
	Device::BCM2835::delay(100); # Milliseconds
}

