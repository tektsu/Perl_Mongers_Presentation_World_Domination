package RPi::Led;
use strict;
use warnings;
use Device::BCM2835; # Assumed to be already initialized
use Time::HiRes qw/gettimeofday tv_interval/;

sub new {
	my $class = shift;
	my %args  = @_;
	die "No pin specified\n" unless $args{pin};

	my $self = {
		name => $args{name} || '',
		pin => $args{pin},
		state     => 0,
		onTime    => $args{onTime} || 500,
		offTime   => $args{offTime} || 500,
		stateTime => 0,
		startTime => [ gettimeofday() ],
	};
	bless $self, $class;

	Device::BCM2835::gpio_fsel($self->{pin}, Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);
	$self->off;

	return $self;
}

sub on {
	my $self = shift;

	Device::BCM2835::gpio_set($self->{pin});
	$self->{state}     = 1;
	$self->{stateTime} = $self->_now;
}

sub off {
	my $self = shift;

	Device::BCM2835::gpio_clr($self->{pin});
	$self->{state}     = 0;
	$self->{stateTime} = $self->_now;
}

sub updateBlink {
	my $self = shift;

	my $now          = $self->_now;
	my $inStateSoFar = $now - $self->{stateTime};
	if ($self->{state}) {
		if ($inStateSoFar >= $self->{onTime}) {
			Device::BCM2835::gpio_clr($self->{pin});
			$self->{state}     = 0;
			$self->{stateTime} = $now;
		}
	}
	else {
		if ($inStateSoFar >= $self->{offTime}) {
			Device::BCM2835::gpio_set($self->{pin});
			$self->{state}     = 1;
			$self->{stateTime} = $now;
		}
	}
}

sub getName {
	my $self = shift;
	return $self->{name};
}

sub getState {
	my $self = shift;
	return $self->{state};
}

sub _now {
	my $self = shift;
	return 1000 * tv_interval($self->{startTime});
}

sub DESTROY {
	my $self = shift;
	$self->off;
}

1;

