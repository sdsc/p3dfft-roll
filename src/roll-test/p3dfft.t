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
my @NETWORKS = split(/\s+/, 'ROLLNETWORK');
my @MPIS = split(/\s+/, 'ROLLMPI');
my %CC = ('gnu' => 'gcc', 'intel' => 'icc', 'pgi' => 'pgcc');
my @types= ( 'double','double-noncontiguous','single','single-noncontiguous' );


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
foreach my $compiler (@COMPILERS) {
    my $compilername = (split('/', $compiler))[0];
    SKIP: {
      ok(-f "/opt/modulefiles/applications/.$compilername/p3dfft/2.6",
         "module file for p3dfft/$compilername installed");
      foreach my $mpi (@MPIS) {
        foreach my $network (@NETWORKS) {
           foreach my $type  (@types) {
              $output = `. /etc/profile.d/modules.sh; module load $compiler ${mpi}_$network p3dfft;mpirun -np 8 \${P3DFFTHOME}/share/p3dfft-samples/p3dfft-${type}/test_sine_f.x`;
          like($output, qr/ Results are correct/,
               "run using p3dfft/$compilername/$mpi/$type");
           }
        }
      }
   }
}
`rm dims stdin`;
# p3dfft-doc.xml
SKIP: {
  skip 'not server', 1 if $appliance ne 'Frontend';
  ok(-d '/var/www/html/roll-documentation/p3dfft', 'doc installed');
}

`rm -f $TESTFILE*`;
