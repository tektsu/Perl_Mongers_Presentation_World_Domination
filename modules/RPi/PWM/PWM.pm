use strict;
use warnings;

package RPi::PWM::PWM;
use base qw/RPi::PWM/;

sub new {
	my $class = shift;
	my %args  = @_;

	my $self = $class->SUPER::new;

	$self->setDutyCycle($args{dutyCycle}) if exists $args{dutyCycle};
	$self->setFrequency($args{frequency}) if exists $args{frequency};
	$self->activate if $args{activate};

	return $self;
}

sub setDutyCycle {
	my $self = shift;
	my ($value) = @_;

	$value ||= 1;;
	$value = 99 if $value > 99;
	$self->_write('duty', $value);
}

sub getDutyCycle {
	my $self = shift;
	my ($value) = @_;

	return $self->_read('duty');
}

sub setFrequency {
	my $self = shift;
	my ($value) = @_;

	$value = 0 if $value < 0;
	$value = 16000 if $value > 16000;
	$self->_write('frequency', $value);
}

sub DESTROY {
	my $self = shift;
	$self->setDutyCycle(0);
	$self->SUPER::DESTROY;
}

1;

