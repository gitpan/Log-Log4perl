###########################################
# Test Suite for Log::Log4perl::Config
# Mike Schilli, 2002 (m@perlmeister.com)
###########################################

#########################
# change 'tests => 1' to 'tests => last_test_to_print';
#########################
use Test;
BEGIN { plan tests => 2 };


use Log::Log4perl;
use Log::Log4perl::TestBuffer;

my $EG_DIR = "eg";
$EG_DIR = "../eg" unless -d $EG_DIR;

ok(1); # If we made it this far, we're ok.

my $LOGFILE = "example.log";
unlink $LOGFILE;

Log::Log4perl->init("$EG_DIR/log4j-file-append-java.conf");

my $logger = Log::Log4perl->get_logger("");
$logger->debug("Gurgel");
$logger->info("Gurgel");
$logger->warn("Gurgel");
$logger->error("Gurgel");
$logger->fatal("Gurgel");

open FILE, "<$LOGFILE" or die "Cannot open $LOGFILE";
my $data = join '', <FILE>;
close FILE;

my $exp = <<EOT;
t/006Config-Java.t 27 DEBUG N/A  - Gurgel
t/006Config-Java.t 28 INFO N/A  - Gurgel
t/006Config-Java.t 29 WARN N/A  - Gurgel
t/006Config-Java.t 30 ERROR N/A  - Gurgel
t/006Config-Java.t 31 FATAL N/A  - Gurgel
EOT

unlink $LOGFILE;
ok($data, $exp);
