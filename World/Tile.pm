package Tile;
use Moose;
use feature ':5.14';
use Glib qw/TRUE FALSE/;

use Moose::Util::TypeConstraints;
use namespace::autoclean;

enum 'tileType', [qw(rock wall floor)];

has blockMove => (
	is 	=> 'rw',
	isa 	=> 'Bool',
	default	=> TRUE
);

has blockSight => (
	is 	=> 'rw',
	isa 	=> 'Bool',
	default	=> TRUE
);

has name => (
	is 	=> 'rw',
	isa 	=> 'tileType',
	default	=> 'rock'
);

has terrain => (
	is 	=> 'rw',
	isa 	=> 'Str',
	default	=> '.'
);

has fgcolour => (
	is 		=> 'rw',
	isa 	=> 'ArrayRef',
	default	=> sub { [0.3, 0.6, 0.2, 0.5] }
);

has bgcolour => (
	is 		=> 'rw',
	isa 	=> 'ArrayRef',
	default	=> sub { [0.8, 0.6, 0.2, 0.5] }
);

__PACKAGE__->meta->make_immutable;

1;
