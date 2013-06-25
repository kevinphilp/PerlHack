package Objects::Living::Creature;
use feature ":5.14";
#use lib ".";
use namespace::autoclean;
use Moose;

extends 'Objects::BasicObject';
with 'Objects::Living::Senses';

has ['strength', 'dexterity', 'consitution', 'intelligence','wisdom', 'charisma', 'movement' ] => (
	is			=> 'rw',
	isa		=> 'Int',
	default	=> 2,
);

sub move {
	my $self = shift;
}

__PACKAGE__->meta->make_immutable;
1;
