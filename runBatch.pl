#!/usr/bin/perl 

##########################################
#                                        #
# Author:     Jing Guo                   #
# Email:      moipedia@gmail.com         #
# Occupation: Bioinformatics          	 #
#                                        #
##########################################
#
# This script generates a shell file that contains commands which can be run on Linux 
# system targetting on some particular kind of file, such as 'bam', 'fastq' and so on
# according to your parameters 
#
##########################################################################################

use Getopt::Long;

my @getopt_args = ('c=s','d=s','mi=s','e=s','mo=s','o=s','h');
my %options;
usage() unless (GetOptions(\%options, @getopt_args));
usage() if (defined $options{h}); 
my $commandPart = $options{c};
my $dataDirectory = $options{d};
my $fileExtension = $options{e};
my $outPut = $options{o};
my $seqMth = $options{mi};
my $outMth = $options{mo};
usage() unless ( $commandPart && $dataDirectory && $outPut && $seqMth);

##########################################################################################

opendir(DIR,"$dataDirectory");
my @dataFiles = readdir(DIR);
my @cleanFiles = ();
foreach my $element (@dataFiles) {
	if($element =~ /$fileExtension$/){
		push @cleanFiles,$element;
	}
}
@cleanFiles = sort @cleanFiles;
close DIR;

open(OUT,">$outPut");	
for(my $i = 0; $i <= $#cleanFiles ; $i++){
	print OUT "$commandPart ";
	if($seqMth =~ /2_fq/){
		$cleanFiles[$i] =~/(^[a-zA-Z0-9]+)/;
		$sampleName = $1;
		$seqMth =~ s/1_fq/$dataDirectory\/$cleanFiles[$i]/;
		$seqMth =~ s/2_fq/$dataDirectory\/$cleanFiles[$i+1]/;
		$outMth =~ s/sampleName/$sampleName/g;
		$i++;
		print OUT "$seqMth $outMth\n"; 
	}
	else{
		$cleanFiles[$i] =~/(^[a-zA-Z0-9]+)/;
		$sampleName = $1;
		$seqMth =~ s/1_fq/$dataDirectory\/$cleanFiles[$i]/;   
		$outMth =~ s/sampleName/$sampleName/g;
		print OUT "$seqMth $outMth\n"; 
	}
	$seqMth = $options{mi};
	$outMth = $options{mo};
}
close OUT;

##########################################################################################

sub usage{
		die << "EOT";
\nUsage: $0 [-options]

        -c   <Command Part>             The command part of the whole line ["perl sth.pl"]

        -d   <Clean Data Direatory>     The file direactory inclusive of all clean data needed to deal with       

	-e   <Extension>		The file extension    

        -mi  <Input Data method>        The method of input data ["-f 1_fq 2_fq" | "-i 1_fq"] 

        -mo  <Output Data method>       The method of output data ["-o sampleName.out 2>sampleName.run.log"]
                                
        -o   <Commands File>            The file contains all commands needed to run

	-h   <Help>                     Display this information
                                        The sample name is needed to extract
                                        It should only contain characters and numbers 
                                        It should be placed at the beginning of the file name. 
	
EOT
}	

