use strict;
use warnings;

package RPi::PWM;

my $controlDir = '/sys/class/rpi-pwm/pwm0';

sub new {
	my $class = shift;

	my $self = {};
	bless $self, $class;

	$self->deactivate;

	return $self;
}

sub activate {
	shift->_write('active', 1);
}

sub deactivate {
	my $self = shift;
	$self->_write('active', 0);
}

sub setDutyCycle {
	my $self = shift;
	my ($value) = @_;

	$value = 0 if $value < 0;
	$value = 99 if $value > 99;
	$self->_write('duty', $value);
}

sub setFrequency {
	my $self = shift;
	my ($value) = @_;

	$value = 0 if $value < 0;
	$value = 16000 if $value > 16000;
	$self->_write('frequency', $value);
}

sub _write {
	my $self = shift;
	my ($file, $value) = @_;

	open my $fh, '>', "$controlDir/$file"
		or die "Unable to open $controlDir/$file: $!\n";
	print $fh $value;
	close $fh;
}

1;

