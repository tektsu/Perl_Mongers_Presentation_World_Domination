package RPi::Button;
use strict;
use warnings;
use Device::BCM2835; # Assumed to be already initialized

sub new {
	my $class = shift;
	my %args  = @_;
	die "No pin specified\n" unless $args{pin};

	my $self = {
		name => $args{name} || '',
		pin => $args{pin},
		state => Device::BCM2835::gpio_lev($args{pin}),
	};
	bless $self, $class;

	return $self;
}

sub getState {
	my $self = shift;

	my $changed = 0;
	my $state   = Device::BCM2835::gpio_lev($self->{pin});
	if ($state != $self->{state}) {
		++$changed;
		$self->{state} = $state;
	}

	return wantarray ? ($changed, $state, $self->{name}) : $state;
}

sub getName {
	my $self = shift;
	return $self->{name};
}

1;

