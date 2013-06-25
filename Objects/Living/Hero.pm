package Objects::Hero;
use feature ":5.14";
#use lib ".";
use namespace::autoclean;
use Moose;

extends 'Objects::Living::Creature';


__PACKAGE__->meta->make_immutable;
1;
