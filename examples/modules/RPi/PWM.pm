use strict;
use warnings;

package RPi::PWM;

sub new {
	my $class = shift;
	my %args  = @_;

	my $self = {
		controlDir => '/sys/class/rpi-pwm/pwm0',
	};
	bless $self, $class;

	$self->deactivate;

	return $self;
}

sub activate {
	shift->_write('active', 1);
}

sub deactivate {
	shift->_write('active', 0);
}

sub delayed {
	my $self = shift;
	my $value = shift;
	$self->_write('delayed', $value ? 1 : 0);
}

sub _read {
	my $self = shift;
	my ($file) = @_;

	open my $fh, '<', "$self->{controlDir}/$file"
		or die "Unable to open $self->{controlDir}/$file: $!\n";
	my $value = <$fh>;
	close $fh;

	return $value;
}

sub _write {
	my $self = shift;
	my ($file, $value) = @_;

	open my $fh, '>', "$self->{controlDir}/$file"
		or die "Unable to open $self->{controlDir}/$file: $!\n";
	print $fh $value;
	close $fh;
}

sub DESTROY {
	shift->deactivate;
}

1;

