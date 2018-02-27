#!/usr/bin/perl

if ( $#ARGV < 0 || $#ARGV > 2 ) {
	usage();
}

use MIME::Base64;

my $debug = undef;

# Argumente/arguments ###############################
print "... Prüfung Argumente\n" if $debug;
my ( $opt, $ext ) = ( '-e', '.b64.r47' );
if ( $ARGV[0] =~ m/-[ed]/ ) {
	$opt = shift @ARGV;
	$ext = '.b64.r47.decoded' if $opt eq '-d';
}
my ( $over ) = ( '' ); # -o
if ( $ARGV[0] =~ m/-o/ ) {
	$over = shift @ARGV;
}
if ( !$ARGV[0] ) {
	usage();
}

# help? / Quelle/Source #################################
my $quelle = shift( @ARGV );
if ($quelle =~ /^-(h|help|-help)$/i) {
	usage();
}

# Ziel/Dest ###################################
my $ziel = $quelle . $ext;
if ( $ARGV[0] ) {
	$ziel = $ARGV[0];
}

if ( $ziel =~ m/^$quelle$/i ) {
	usage( "Ziel kann nicht gleich Quell-Dateiname sein [$ziel]" );
}

if ( !(-f $quelle) ) {
	usage( "Quelldatei nicht vorhanden [$quelle]" );
}

my $name_without_b64 = '';
my $name_without_b64_dec = '';
# correct extension #########################
print "... correct extension\n" if $debug;
if ( $quelle =~ m/^(.*?)(\.b64.r47)$/i ) { # quelle/source = b64-encoded => decode
	print "... correct extension: src = *.b64.r47\n" if $debug;
	$name_without_b64 = $1;
	my $decext = '';
	if ( lc($opt) eq '-e' ) {
		$opt = '-d';
	}
	if ( $ziel =~ m/^(.*?)(\.b64.r47(\.decoded)?)$/i ) { # no dest set, ext set automatically => decode ## BUT! not right if dest-ext was set to ".decoded"
		$name_without_b64_dec = $1;
		$ziel = $name_without_b64;
		if ( $ziel =~ m/^(.*?)\.ba_$/i ) { $ziel = "$1.bat"; }
		if ( $ziel =~ m/^(.*?)\.co_$/i ) { $ziel = "$1.com"; }
		if ( $ziel =~ m/^(.*?)\.ex_$/i ) { $ziel = "$1.exe"; }
		if ( $ziel =~ m/^(.*?)\.cm_$/i ) { $ziel = "$1.cmd"; }
		if ( $ziel =~ m/^(.*?)\.zi_$/i ) { $ziel = "$1.zip"; }
	} else { # dest set
		# do nothing ?
	}
} else { # src != .b64.r47 = possibly encode
	print "... correct extension: src != *.b64.r47\n" if $debug;
	if ( $opt =~ m/-e/i ) { # encode
		print "...>>> correct extension: action: -e\n" if $debug;
		if ( $ziel =~ m/^(.*?)(\.[a-z0-9]{1,3})(\.b64.r47)$/i ) {
			print "... correct extension: dest =~ \.[a-z0-9]\.b64.r47\n" if $debug;
			if ( $ziel =~ m/^(.*?)\.bat.b64.r47$/i ) { $ziel = "$1.ba_.b64.r47"; }
			if ( $ziel =~ m/^(.*?)\.com.b64.r47$/i ) { $ziel = "$1.co_.b64.r47"; }
			if ( $ziel =~ m/^(.*?)\.exe.b64.r47$/i ) { $ziel = "$1.ex_.b64.r47"; }
			if ( $ziel =~ m/^(.*?)\.cmd.b64.r47$/i ) { $ziel = "$1.cm_.b64.r47"; }
			if ( $ziel =~ m/^(.*?)\.zip.b64.r47$/i ) { $ziel = "$1.zi_.b64.r47"; }
		}
	}
}

print "... ist Ziel bereits vorhanden?\n" if $debug;
my ( $overwrite, $eingabe ) = ( 'n', '' );
if ( $over =~ m/-o/i ) {
	$overwrite = 'y';
	print "... overwrite is ON \n";
}
# print "... overwrite is: $overwrite\n";
while ( (-f $ziel) && ( $overwrite !~ m/^[jy]$/i ) ) {
	print "Zieldatei bereits vorhanden, ueberschreiben? Dest exist's, overwrite? (J/Y/N) [$ziel]: ";
	$eingabe = <STDIN>;
	chomp( $eingabe );
	$overwrite = $eingabe;
	if ( $overwrite =~ m/^[n]$/i ) {
		abort("Ziel wird nicht ueberschrieben [$ziel]");
	}
}

print "... Ermitteln Verzeichnis\n" if $debug;
my $aktdir = `cd`;
chomp( $aktdir );
if ( $aktdir !~ m/\\/ ) { $aktdir .= m"\\"; }
print "$aktdir\n";

print "... Quelle lesen Argumente\n" if $debug;
my $orgein = $/;
if ( !open( EIN, "$quelle" ) ) {
	usage( "Kann Quelldatei nicht lesen [$quelle]." );
}
undef( $/ );
binmode( EIN );
my $ein = <EIN>;
close( EIN );
$/ = $orgein;

print "... do Base64\n" if $debug;
my ( $aus, $action ) = ( '', 'encoding BASE64' );
# rot47:
## in:
##    !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~
#### mask
##    !"#$%&'\x28\x29*+,\x2D.\x2F0-9:;<=>?@A-Z[\x5C]^_`a-z{|}~
## out:
##    PQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNO
#### mask
##    P-Z[\x5C]^_`a-z{|}~!"#$%&'\x28\x29*+,\x2D.\x2F0-9:;<=>?@A-O
if ( lc( $opt ) eq '-e' ) { ## encrypt
	# base64 encrypt
	$aus = MIME::Base64::encode($ein);
	# rot47 encrypt
	$aus =~ tr
		(!"#$%&'\x28\x29*+,\x2D.\x2F0-9:;<=>?@A-Z[\x5C]^_`a-z{|}~)
		(P-Z[\x5C]^_`a-z{|}~!"#$%&'\x28\x29*+,\x2D.\x2F0-9:;<=>?@A-O);
} elsif ( lc( $opt ) eq '-d' ) { ## decrypt
	$action = 'decoding BASE64';
	#rot47 decrypt
	$ein =~ tr
		(!"#$%&'\x28\x29*+,\x2D.\x2F0-9:;<=>?@A-Z[\x5C]^_`a-z{|}~)
		(P-Z[\x5C]^_`a-z{|}~!"#$%&'\x28\x29*+,\x2D.\x2F0-9:;<=>?@A-O);
	#base64 decrypt
	$aus = MIME::Base64::decode($ein);
} else {
	usage( "Falsche Option [$opt]" );
}

print "$action\n";
print "... Ziel schreiben\n" if $debug;
if ( !open( AUS, ">$ziel" ) ) {
	usage( "Kann Zieldatei nicht schreiben [$ziel]." );
}
print "... schreibe [$ziel]\n";
binmode( AUS );
print AUS $aus;
close( AUS );

#print "\n*** ENDE ***\n";

sub usage {
	my ( $mes, @rest ) = @_;
	print "\n";
	if ( $mes ) {
		print $mes;
		print "\n" if $mes !~ m/\n$/;
	}
	print "baserot4.pl - Benutzung/Usage:\n";
	print "[perl] baserot4.pl [-e|-d] [-o] (quelldatei/source) [(zieldatei/destination)]\n";
	print "-e 	 encode (default)\n-d 	 decode\n-o 	 overwrite existing\n-h|help	 diese Hilfe/this help\next(encode) = .b64.r47 (if no dest set)\nsource ext .b64.r47 = action: decode\n";
	exit(255);
}
sub abort {
	my ( $mes, @rest ) = @_;
	print "\n";
	if ( $mes ) {
		print $mes;
		print "\n" if $mes !~ m/\n$/;
	}
	print "baserot4.pl - canceled\n";
	exit(255);
}
