package FloorPlan;
use Moose;
use feature ':5.14';
use Glib qw/TRUE FALSE/;
use Data::Dumper;
use namespace::autoclean;

use World::Tile;
use World::Rooms;

has ['maxX', 'maxY'] => (
	is 		=> 'rw',
	isa 	=> 'Int',
	default	=> 50,
	required => 1,
);

has levelMap => (
	is 			=> 'rw',
	isa 		=> 'ArrayRef',
	builder 	=> 'buildMap'
);

has bgcolour => (
	is 		=> 'rw',
	isa 	=> 'ArrayRef',
	default	=> sub { [0.8, 0.6, 0.2, 0.5] }
);

has gridcolour => (
	is 		=> 'rw',
	isa 	=> 'ArrayRef',
	default	=> sub { [0.2, 0.2, 0.8, 0.5] }
);

has rooms => (
	is 		=> 'rw',
	traits  => ['Array'],
	isa 	=> 'ArrayRef',
	default	=> sub { [] },
	handles => {
		all_rooms    => 'elements',
		add_room     => 'push',
		map_rooms    => 'map',
		filter_rooms => 'grep',
		find_room    => 'first',
		get_room     => 'get',
		join_rooms   => 'join',
		count_rooms  => 'count',
		has_rooms    => 'count',
		has_no_rooms => 'is_empty',
		sorted_rooms => 'sort',
	},
);

sub buildMap {
	my $self = shift;
	my @array1 = [];
	foreach my $x (0..50 ) {
		foreach my $y (0..50) {
			$array1[$x][$y] = Tile->new;
		}
	}
	return \@array1;
}

sub overlaps {
	my ($self, $roomref) = @_;
	my $return = 1; # Default to overlaps
	foreach my $room ( @{$self->rooms} ) {
		if (($$roomref->x1 > ($room->x2 + 1))
		    or ($$roomref->x2 < ($room->x1 -1) )
		    or ($$roomref->y1 > ($room->y2 +1) )
		    or ($$roomref->y2 < ($room->y1 -1))) {
            $return =0;
        } else {
            return 1;
        }
	}
	return $return;
}

sub addRoom {
	my ($self, $roomref) = @_;
	# Add to room array
	push($self->rooms, $$roomref);
	# Add to level map
	foreach my $x ($$roomref->x1..$$roomref->x2) {
		foreach my $y ($$roomref->y1..$$roomref->y2) {
			if (($x == $$roomref->x1)
				or ($x == $$roomref->x2)
				or ($y == $$roomref->y1)
				or ($y == $$roomref->y2) ) {
					$self->levelMap->[$x][$y]->terrain( 'X' );
					$self->levelMap->[$x][$y]->fgcolour( [0.195, 0.15, 0.15, 0.5]  );
			} else {
				$self->levelMap->[$x][$y]->terrain( $$roomref->id );
				$self->levelMap->[$x][$y]->fgcolour( [0.195, 0.55, 0.15, 0.5]  );
			}

		}
	}
}

sub makeRooms {
	my $self = shift;
	my $roomcount = int(rand(5)) + 5;
	my $counter = 3;
	while ($counter <= $roomcount ) {
		my $room = Rooms->new;
		$room->x1( int(rand(36)) + 1 );
		$room->y1( int(rand(36)) + 1 );
		$room->x2( $room->x1 + int(rand(10)) + 4 );
		$room->y2( $room->y1 + int(rand(10)) + 4 );
		$room->id( $counter );

		if ($counter == 0 ) {
			$self->addRoom( \$room );
			$counter++;
		} elsif ( not $self->overlaps( \$room) ) {
			$self->addRoom( \$room );
			$counter++;
		}
	}
}

sub makeCorridors {
	my $self = shift;

	for (my $counter = 1; $counter < $self->count_rooms; $counter++) {
		my $end = $self->get_room( $counter );
		my $start = $self->get_room( $counter - 1 );

		my $widthx = ($self->get_room( $counter - 1 )->x2 - $self->get_room( $counter - 1 )->x1);
		my $heighty = ($self->get_room( $counter - 1 )->y2 - $self->get_room( $counter - 1 )->y1);
		my $startx = int($self->get_room( $counter - 1 )->x1 + ($widthx / 2));
		my $starty = int($self->get_room( $counter - 1 )->y1 + ($heighty / 2));

		$widthx = ($self->get_room( $counter )->x2 - $self->get_room( $counter )->x1);
		$heighty = ($self->get_room( $counter )->y2 - $self->get_room( $counter )->y1);
		my $endx = int($self->get_room( $counter )->x1 + ($widthx / 2));
		my $endy = int($self->get_room( $counter )->y1 + ($heighty / 2));


		unless ($startx == $endx) {
			my $incx = int (($endx - $startx) / abs($endx - $startx));
			for (my $x = $startx; $x != $endx; $x += $incx) {
				$self->levelMap->[$x][$starty]->terrain( $counter );
				$self->levelMap->[$x][$starty]->fgcolour( [0.195, 0.55, 0.15, 0.85]  );
			}
		}

		unless ($starty == $endy) {
			my $incy = int (($endy - $starty) / abs($endy - $starty));
			for (my $y = $starty; $y != $endy; $y += $incy) {
				$self->levelMap->[$endx][$y]->terrain( $counter );
				$self->levelMap->[$endx][$y]->fgcolour( [0.195, 0.55, 0.15, 0.85]  );
			}
		}
	}
}

sub addDoors {
	my $self = shift;


}

__PACKAGE__->meta->make_immutable;

1;
