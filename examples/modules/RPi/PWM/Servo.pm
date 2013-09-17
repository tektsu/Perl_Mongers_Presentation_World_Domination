use strict;
use warnings;

package RPi::PWM::Servo;
use base qw/RPi::PWM/;

sub new {
	my $class = shift;
	my %args  = @_;

	my $self = $class->SUPER::new;

	die "ServoMax was not specified\n" unless defined $args{servoMax};

	$self->_write('mode', 'pwm [servo] audio');
	$self->setServoMax($args{servoMax});
	$self->setServo($args{servo}) if exists $args{servo};
	$self->activate if $args{activate};

	return $self;
}

sub setServoMax {
	my $self = shift;
	my ($value) = @_;

	$value = 0 if $value < 0;;
	$value = 360 if $value > 360;
	$self->{servoMax} = int($value);
	$self->_write('servo_max', $self->{servoMax});
}

sub setAngle {
	my $self = shift;
	my ($angle) = @_;

	$angle = 0 if $angle < 0;;
	$angle = $self->{servoMax} if $angle > $self->{servoMax};
	$self->{angle} = int($angle);
	$self->_write('servo', $self->{angle});
}

sub left {
	shift->setAngle(0);
}

sub center {
	my $self = shift;
	$self->setAngle(int($self->{servoMax}/2));
}

sub right {
	my $self = shift;
	$self->setAngle($self->{servoMax});
}

sub incLeft {
	my $self = shift;
	my $angle = shift;

	$self->setAngle($self->{angle} - $angle);
}

sub incRight {
	my $self = shift;
	my $angle = shift;

	$self->setAngle($self->{angle} + $angle);
}

sub DESTROY {
	shift->SUPER::DESTROY;
}

1;

