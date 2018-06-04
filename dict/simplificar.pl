#!/usr/bin/perl

#use warning;

use strict;

open (my $out, ">", "dict_pt-br.txt") or die "Can't open dict_pt-br.txt: $!";

my @AtoZ = split(//, "ABCDEFGHIJKLMNOPQRSTUVWXYZ"); #Obtém um vetor com cada letra do alfabeto.

foreach my $letra (@AtoZ){ 

	open (my $in, "<", "$letra.txt") or die "Can't open $letra.txt: $!";
	
	while (<$in>){
		if ($_ =~ /\*( \*)?[a-zA-Z]*\*.*/){
			my @linha = split (//, $_);
			my $count = 0;
			
			while (@linha[$count] !~ /[a-zA-Z]/) { $count++; }
			my $inicio = $count;
			
			while (@linha[$count] =~ /[a-zA-Z]/) { $count++; }
			my $tamanho = $count - $inicio;			
			
			my $palavra = substr $_, $inicio, $tamanho;
			print $out lc "$palavra\n";
		}

# método antigo:		
#		my @linha;
#		if ($_ =~ /\* \*[a-zA-Z]*\*.*/){
#			@linha = split (/\* \*/, $_);
#			@linha = split (/\*/, @linha[1]);
#			print $out "@linha[0]\n";
#		}
#		elsif ($_ =~ /\*[a-zA-Z]*\*.*/){
#			@linha = split (/\*/, $_);
#			print $out "@linha[1]\n";
#		}
	}

	close ($in) or die "cant't close $letra.txt: $!";

}

close ($out) or die "cant't close dict_simples_pt-br.txt: $!"

