#!/usr/bin/perl
use strict;
use warnings;
use lib qw|../../modules|;
use RPi::PWM::PWM;
use Time::HiRes qw/usleep/;

exec "sudo $0 " . join(' ', @ARGV) if $<;
$SIG{INT} = sub { exit; };

my $pwm = RPi::PWM::PWM->new(dutyCycle => 0, frequency => 100, activate => 1);
for (1 .. 3) {
	for my $dutyCycle (0 .. 99) {
		$pwm->setDutyCycle($dutyCycle);
		usleep(10000);
	}
	for my $dutyCycle (0 .. 99) {
		$pwm->setDutyCycle(99 - $dutyCycle);
		usleep(5000);
	}
}

