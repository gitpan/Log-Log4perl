use Log::Log4perl;
use Test;
use File::Spec;

my $WORK_DIR = File::Spec->catfile(qw(t tmp));
use vars qw(@outfiles $test_logfile); 
$test_logfile = File::Spec->catfile($WORK_DIR, 'test2.log');
@outfiles = ($test_logfile);
unless (-e "$WORK_DIR"){
    mkdir("$WORK_DIR", 0755) || die "can't create $WORK_DIR $!";
}
foreach my $f (@outfiles){
    unlink $f if (-e $f);
}


my $conf = <<CONF;
log4j.category.cat1      = INFO, myAppender

log4j.appender.myAppender=org.apache.log4j.FileAppender
log4j.appender.myAppender.File=$test_logfile
log4j.appender.myAppender.layout=org.apache.log4j.PatternLayout
log4j.appender.myAppender.layout.ConversionPattern=%-5p %c - %m%n
CONF

Log::Log4perl->init(\$conf);

my $logger = Log::Log4perl->get_logger('cat1');

$logger->debug("debugging message 1 ");
$logger->info("info message 1 ");      
$logger->warn("warning message 1 ");   
$logger->fatal("fatal message 1 ");   


my ($result, $expected);

$expected = <<EOL;
INFO  cat1 - info message 1 
WARN  cat1 - warning message 1 
FATAL cat1 - fatal message 1 
EOL

{local $/ = undef;
 open (F, "$test_logfile") || die $!;
 $result = <F>;
 close F;
}
ok ($result, $expected);



BEGIN { plan tests => 1, }



foreach my $f (@outfiles){
    unlink $f if (-e $f);
}

