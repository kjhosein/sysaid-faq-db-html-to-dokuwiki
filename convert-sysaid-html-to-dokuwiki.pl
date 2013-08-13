#!/usr/bin/perl

use warnings;
use strict;

use DBI;

use HTML::WikiConverter;
use HTML::Strip;
use MIME::Base64;

my ( $dbh, $sql, $sth, $row );
my ( $fh, $filename, $title, $question, $answer, $wc );
my ( $ifh, $i, $imgfilename, $image, @images );

# Database info. Modify to suit:
my $db     = 'dbi:mysql:sysaid';
my $dbuser = 'root';
my $dbpass = 'bitnami';

# Modify this to suit your table size:
my $numrecords = 200;

$wc = new HTML::WikiConverter( dialect => 'DokuWiki' );

$dbh = DBI->connect( 'dbi:mysql:sysaid', 'root', 'bitnami' )
  or die "Connection Error: $DBI::errstr\n";

$sql = "select id,title,question,answer,category,sub_category from faq limit $numrecords";
$sth = $dbh->prepare( $sql );

$sth->execute or die "SQL Error: $DBI::errstr\n";

while ( my @row = $sth->fetchrow_array ) {

    # first select the id and title and create a filename out of it:
    $filename = $row[1];
    $filename =~ s/[\s+\/\?]+/_/g;    # replace whitespace, / and ? with only 1 underscore
    $filename = lc( $filename );
    $filename = $row[0] . "." . $filename . ".txt";
    print "Found record, writing to $filename \n\n";    #debug

    # strip HTML from question field (b/c it's inconsistent)
    my $hs = HTML::Strip->new();
    $question = $hs->parse( $row[2] );

    # remove slashes (/) from category fields:
    $row[4] =~ s/\///g;
    $row[5] =~ s/\///g;

    # extract images, convert them and write them to disk:
    @images = $row[3] =~ /base64,(.+)\"/g;
    $i      = 1;
    foreach ( @images ) {
        $image       = MIME::Base64::decode_base64( $_ );
        $imgfilename = $row[0] . "-" . $i . ".png";
        print "Found image, writing to " . $imgfilename . "\n";
        $i++;
        open( $ifh, ">", $imgfilename );
        print $ifh $image;
        close( $ifh );
    }

    # now strip the base64-encoded image out of the answer:
    $row[3] =~ s/<img.*?\/>/<h4> an image goes here <\/h4>/gs;
    $answer = $row[3];

    # convert the question and answer to DokuWiki format:
    $title    = "====== $row[1] ======";     # H1
    $question = "===== $question =====";     # H2
    $answer   = $wc->html2wiki( $answer );

    # now output the title, ques and answer to the file:
    open( $fh, ">", $filename );
    print $fh "$title";
    print $fh "\n\n";
    print $fh "Category is $row[4], Sub-category is $row[5]";
    print $fh "\n\n";
    print $fh $question;
    print $fh "\n\n";
    print $fh $answer;
    close( $fh );
}

