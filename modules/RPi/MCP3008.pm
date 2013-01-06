use strict;
use warnings;

package RPi::MCP3008;
use Device::BCM2835;

sub new {
	my $class = shift;

	Device::BCM2835::spi_begin();

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

