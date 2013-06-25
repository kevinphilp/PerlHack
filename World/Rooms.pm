package Rooms;
use Moose;
use feature ':5.14';
use Glib qw/TRUE FALSE/;

use namespace::autoclean;

has ['x1', 'x2', 'y1', 'y2', 'id'] => (
	is 		=> 'rw',
	isa 	=> 'Int',
	default	=> 0,
);

has lit => (
	is 	=> 'rw',
	isa 	=> 'Bool',
	default	=> TRUE
);

__PACKAGE__->meta->make_immutable;

1;
