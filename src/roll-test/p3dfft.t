#!/usr/bin/perl -w
use Test::More qw(no_plan);
# p3dfft roll installation test.  Usage:
# p3dfft.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend


my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my $output;

my $TESTFILE = 'rollp3dfft';

my @COMPILERS = split(/\s+/, 'ROLLCOMPILER');
my @MPIS = split(/\s+/, 'ROLLMPI');
my @types = ( 'double','double-noncontiguous','single','single-noncontiguous' );

open(INPUT,">dims");
print INPUT <<END;
2 4
END
close(INPUT);

open(INPUT,">stdin");
print INPUT <<END;
16 16 16 2 1
END
close(INPUT);

foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    foreach my $type(@types) {
      $output = `module load $compiler $mpi p3dfft; mpirun -np 8 \${P3DFFTHOME}/share/p3dfft-samples/p3dfft-${type}/test_sine_f.x 2>&1`;
      if($output =~ /run-as-root/) {
        $output = `module load $compiler $mpi p3dfft; mpirun --allow-run-as-root -np 8 \${P3DFFTHOME}/share/p3dfft-samples/p3dfft-${type}/test_sine_f.x 2>&1`;
      }
      like($output, qr/ Results are correct/,
             "run using p3dfft/$compilername/$mpi/$type");
    }
  }
  `/bin/ls /opt/modulefiles/applications/.$compilername/p3dfft/.version.* 2>&1`;
  ok($? == 0, "p3dfft $compilername version module installed");
  ok(-l "/opt/modulefiles/applications/.$compilername/p3dfft/.version",
     "p3dfft $compilername version module link created");
  $output = `module load $compiler p3dfft; echo \$P3DFFTHOME 2>&1`;
  my $firstmpi = $MPIS[0];
  $firstmpi =~ s#/.*##;
  like($output, qr#/opt/p3dfft/$compiler/$firstmpi#, 'p3dfft modulefile defaults to first mpi');
}

`rm -fr $TESTFILE* dims stdin`;
