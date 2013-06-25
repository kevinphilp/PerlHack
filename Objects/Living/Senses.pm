package Objects::Living::Senses;
use Moose::Role;
use feature ":5.14";
use namespace::autoclean;

use Data::Dumper;

has 'type' => (
	is			=> 'ro',
	isa 		=> 'Str',
	default 	=> 'vision',  # vision, IRvision, smell, esp
);

has 'range' => (
	is			=> 'ro',
	isa		=> 'Int',
	default	=> 10,
);

sub BUILD {
	my $self = shift;
	say "Building";
}

sub detect {
	my $self = shift;
	say "Detected";
}


no Moose::Role;
1;

=head1 NAME

Senses

=head1 SYNOPSIS

  use Senses;

  Supplies functions:
  checkSenses()

=head1 DESCRIPTION


=head1 FUNCTION

