#!/usr/bin/perl
use Device::BCM2835;
use strict;
use warnings;

exec "sudo $0 " . join(' ', @ARGV) if $<;

#Device::BCM2835::set_debug(1);
Device::BCM2835::init() || die "Could not init library";

my $outputPin = Device::BCM2835::RPI_GPIO_P1_12; 
Device::BCM2835::gpio_fsel($outputPin, Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);

my $inputPin0  = Device::BCM2835::RPI_GPIO_P1_11;
my $inputPin1  = Device::BCM2835::RPI_GPIO_P1_13;
my $inputPin2  = Device::BCM2835::RPI_GPIO_P1_15;

while (1) {
	print "Button 0: " . Device::BCM2835::gpio_lev($inputPin0) . "\n";
	print "Button 1: " . Device::BCM2835::gpio_lev($inputPin1) . "\n";
	print "Button 2: " . Device::BCM2835::gpio_lev($inputPin2) . "\n";
	# Turn it on
	Device::BCM2835::gpio_set($outputPin);
	Device::BCM2835::delay(500); # Milliseconds

	# Turn it off
	Device::BCM2835::gpio_clr($outputPin);
	Device::BCM2835::delay(500); # Milliseconds
}

