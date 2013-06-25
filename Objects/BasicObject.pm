package Objects::BasicObject;
use Moose;
use feature ":5.14";
use namespace::autoclean;

has 'name' => (
	is			=> 'rw',
	isa		=> 'Str',
	default	=> 'A Thing',
);

has 'description' => (
	is			=> 'rw',
	isa		=> 'Str',
	default	=> 'Needs describing!',
);

has 'height' => (
	is			=> 'rw',
	isa		=> 'Int',
	default	=> 2,
);

has 'weight' => (
	is			=> 'rw',
	isa		=> 'Int',
	default	=> 45,
);

has ['x', 'y'] => (
	is			=> 'rw',
	isa		=> 'Int',
	default	=> 15,
);

__PACKAGE__->meta->make_immutable;
1;

=head1 NAME

Thing

=head1 SYNOPSIS

  use Thing;

	Abstract base class for all creatures, heros and items

=head1 DESCRIPTION


=head1 FUNCTION
