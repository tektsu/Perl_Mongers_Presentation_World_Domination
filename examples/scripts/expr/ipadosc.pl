#!/usr/bin/perl
use strict;
use warnings;
use lib qw|../../modules|;
use Device::BCM2835;
use Net::OpenSoundControl::Server;
use RPi::PWM;

exec "sudo $0 " . join(' ', @ARGV) if $<;
$SIG{INT} = sub { exit; };

my %validMessages = map { $_ => undef } qw|/1/toggle14 /1/push1 /1/fader1|;

my $pwm = RPi::PWM->new(dutyCycle => 0, frequency => 100, activate => 1);

Device::BCM2835::init() || die "Could not init library";

my $outputPin = Device::BCM2835::RPI_GPIO_P1_16; 
Device::BCM2835::gpio_fsel($outputPin, Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);

my $server = Net::OpenSoundControl::Server->new(
	Port    => 8000,
	Handler => \&handlemsg) or die "Could not start server: $@\n";

$server->readloop();

sub handlemsg {
	my ($sender, $message) = @_;
	return unless $message;
	return unless exists $validMessages{$message->[0]};

	if ($message->[0] eq '/1/push1' && $message->[2]) {
		exit;
	}

	if ($message->[0] eq '/1/toggle14') {
		if (defined($message->[2]) && $message->[2]) {
			Device::BCM2835::gpio_set($outputPin);
			return;
		}
		Device::BCM2835::gpio_clr($outputPin);
		return;
	}

	if ($message->[0] eq '/1/fader1') {
		$pwm->setDutyCycle(int($message->[2] * 100)) if defined $message->[2];
		return;
	}

}

