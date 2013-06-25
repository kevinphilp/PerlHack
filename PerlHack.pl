#! /usr/bin/perl

use strict;
use warnings;
use feature ':5.14';
use Gtk3 '-init';
use Glib qw/TRUE FALSE/;
use Cairo::GObject;

use World::FloorPlan;
use Objects::Living::Hero;

use constant {
	PI 			=> 3.1415927,
	TILESIZE 		=> 20,
	FONT_SIZE		=> 12,
};

use constant	COL_BG 		=> (0.9, 0.9, 0.6, 0.9);
use constant	COL_GRID	=> (0.1, 0.1, 0.1, 0.3);
use constant	COL_TEXT	=> (0.4, 0.2, 0.6, 0.5);
use constant	COL_FONT	=> (0.4, 0.2, 0.6);
use constant	FONT			=> ("Sans", "normal", "bold");

my $window = Gtk3::Window->new('toplevel');
$window->set_title("Perl Hack");
$window->set_position("mouse");
$window->set_default_size(600, 600);
$window->set_border_width(5);
$window->signal_connect (delete_event => sub { Gtk3->main_quit });

my $frame = Gtk3::Frame->new("Level 1 Map");
$window->add($frame);

my $drawable = Gtk3::DrawingArea->new;
$drawable->signal_connect( draw => \&cairo_draw );
$frame->add($drawable);

$window->show_all;

my $plan = FloorPlan->new(bgcolour => [0.8, 0.8, 0.8, 1.0] );
$plan->makeRooms;
$plan->makeCorridors;
$plan->addDoors;

Gtk3->main;

sub cairo_draw {
	my ( $widget, $context, $ref_status ) = @_;

	# Defaults
	$context->select_font_face( FONT );
	$context->set_font_size( FONT_SIZE );

	# Background
	$context->set_source_rgba( @{$plan->bgcolour} );
	$context->paint;

	$context->set_line_width(1);
	foreach my $x (0..50) {
		foreach my $y (0..50) {

			$context->set_source_rgba( @{$plan->gridcolour} );
			$context->rectangle( $x*TILESIZE, $y*TILESIZE, TILESIZE, TILESIZE );
			$context->stroke;

			$context->set_source_rgba( @{$plan->levelMap->[$x][$y]->fgcolour} );
			# Puts character roughly in the centre of the box
			$context->move_to( ($x*TILESIZE) + TILESIZE/2 - FONT_SIZE/2, ($y*TILESIZE) + TILESIZE/2 + FONT_SIZE/2 );
			$context->show_text( $plan->levelMap->[$x][$y]->terrain );
			$context->stroke;
		}
	}
	return FALSE;
}
