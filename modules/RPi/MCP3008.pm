use strict;
use warnings;

package RPi::MCP3008;
use Device::BCM2835;

sub new {
	my $class = shift;

	Device::BCM2835::spi_begin();
#	Device::BCM2835::spi_setBitOrder(Device::BCM2835::BCM2835_SPI_BIT_ORDER_MSBFIRST);
#	Device::BCM2835::spi_setDataMode(Device::BCM2835::BCM2835_SPI_MODE0);
#	Device::BCM2835::spi_setClockDivider(Device::BCM2835::BCM2835_SPI_CLOCK_DIVIDER_65536);
#	Device::BCM2835::spi_chipSelect(Device::BCM2835::BCM2835_SPI_CS0);
#	Device::BCM2835::spi_setChipSelectPolarity(Device::BCM2835::BCM2835_SPI_CS0, 0);

	my $self = {
		commands => [qw/018000 019000 01a000 01b000 01c000 01d000 01e000 01f000/],
	};
	bless $self, $class;

	return $self;
}

sub readChannel {
	my $self = shift;
	my $channel = shift;
	die "Channel [$channel} is invalid\n" if $channel < 0 || $channel > 7;

	my $buffer = pack('H*', $self->{commands}[$channel]);
	Device::BCM2835::spi_transfern($buffer);
	return hex(unpack('H*', $buffer)) & 0x3ff;
}

sub DESTROY {
	my $self = shift;

	Device::BCM2835::spi_end();
}

1;

