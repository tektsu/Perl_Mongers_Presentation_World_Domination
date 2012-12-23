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
Device::BCM2835::gpio_fsel($inputPin1, Device::BCM2835::BCM2835_GPIO_FSEL_INPT);

Device::BCM2835::gpio_clr($outputPin);
Device::BCM2835::gpio_ren($inputPin1);
Device::BCM2835::gpio_set_eds($inputPin1);
while (1) {
	last if Device::BCM2835::gpio_eds($inputPin1);
	my $button0 = Device::BCM2835::gpio_lev($inputPin0);
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

