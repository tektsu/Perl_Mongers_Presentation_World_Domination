use strict;
use warnings;

package RPi::MCP3008;
use Device::BCM2835;

sub new {
	my $class = shift;

	Device::BCM2835::spi_begin();

	my $self = {};
	bless $self, $class;

	return $self;
}

sub readChannel {
	my $self = shift;

	my $buffer = pack('H*', '018000');
	Device::BCM2835::spi_transfern($buffer);
	return hex(unpack('H*', $buffer)) & 0x3ff;
}


