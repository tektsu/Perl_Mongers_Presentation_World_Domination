#!/usr/bin/perl
use strict;
use warnings;
use lib qw|../../modules|;
use Device::BCM2835;
use RPi::PWM;

exec "sudo $0 " . join(' ', @ARGV) if $<;

Device::BCM2835::init() || die "Could not init library";

Device::BCM2835::spi_begin();

#Device::BCM2835::spi_setBitOrder(Device::BCM2835::BCM2835_SPI_BIT_ORDER_MSBFIRST);
#Device::BCM2835::spi_setDataMode(Device::BCM2835::BCM2835_SPI_MODE0);
#Device::BCM2835::spi_setClockDivider(Device::BCM2835::BCM2835_SPI_CLOCK_DIVIDER_65536);
#Device::BCM2835::spi_chipSelect(Device::BCM2835::BCM2835_SPI_CS0);
#Device::BCM2835::spi_setChipSelectPolarity(Device::BCM2835::BCM2835_SPI_CS0, 0);

use constant MAX_VALUE => 1023;
use constant JITTER    => 5;

my $pwm = RPi::PWM->new;
$pwm->setDutyCycle(0);
$pwm->setFrequency(100);
$pwm->activate;

my $oldValue = MAX_VALUE + (2 * JITTER);
while (1) {

	# Read the value on CH0
	my $buffer = pack('H*', '018000');
	Device::BCM2835::spi_transfern($buffer);
	my $value = hex(unpack('H*', $buffer)) & 0x3ff;

	# De-jitter
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

END {
	$pwm->deactivate;
	$pwm->setDutyCycle(0);

	Device::BCM2835::spi_end();
}

