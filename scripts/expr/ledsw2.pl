#!/usr/bin/perl
use Device::BCM2835;
use strict;
use warnings;

#Device::BCM2835::set_debug(1);
Device::BCM2835::init() || die "Could not init library";

my $outputPin = Device::BCM2835::RPI_GPIO_P1_16; 
Device::BCM2835::gpio_fsel($outputPin, Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);

my $inputPin0  = Device::BCM2835::RPI_GPIO_P1_11;
my $inputPin1  = Device::BCM2835::RPI_GPIO_P1_13;

Device::BCM2835::gpio_clr($outputPin);
while (1) {
	my $button0 = Device::BCM2835::gpio_lev($inputPin0);
	my $button1 = Device::BCM2835::gpio_lev($inputPin1);
	last if $button1;
	if($button0 && ! Device::BCM2835::gpio_lev($outputPin)) {
		Device::BCM2835::gpio_set($outputPin);
		print "LED On\n";
	}
	if(!$button0 && Device::BCM2835::gpio_lev($outputPin)) {
		Device::BCM2835::gpio_clr($outputPin);
		print "LED Off\n";
	}
	Device::BCM2835::delay(500); # Milliseconds
}

print "Shutting Down\n";

