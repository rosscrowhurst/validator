#!/usr/bin/perl

use strict;
use ModENCODE::Parser::Chado;
use ModENCODE::Chado::XMLWriter;
use Data::Dumper;
use ModENCODE::Validator::Data;

my $experiment_id = $ARGV[0];

my $reader = new ModENCODE::Parser::Chado({ 
    'dbname' => 'mepipe' ,
    'host' => 'localhost',
    'username' => 'db_public',
    'password' => 'limecat',
  });

if (!$experiment_id) {
  print "Available experiments are:\n";
  my @exp_strings = map { $_->{'experiment_id'} . "\t\"" . $_->{'description'} . "\"" } @{$reader->get_available_experiments()};
  print "  ID\tDescription\n";
  print "  " . join("\n  ", @exp_strings);
  print "\n";
} else {
  $reader->load_experiment($experiment_id);
  my $experiment = $reader->get_experiment();

  my $data_validator = new ModENCODE::Validator::Data();
  #$data_validator->validate($experiment);
  $experiment = $data_validator->merge($experiment);

  my $writer = new ModENCODE::Chado::XMLWriter();
  $writer->write_chadoxml($experiment);
}
