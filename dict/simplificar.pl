#!/usr/bin/perl

#use warning;

use strict;

open (my $out, ">", "dict_pt-br.txt") or die "Can't open dict_pt-br.txt: $!";

my @AtoZ = split (//, "ABCDEFGHIJKLMNOPQRSTUVWXYZ"); # Obtém um vetor com cada letra do alfabeto.

foreach my $letra (@AtoZ){ # Para cada letra...

	open (my $in, "<", "$letra.txt") or die "Can't open $letra.txt: $!";
	
	while (<$in>){
		if ($_ =~ /\*( \*)?[a-zA-Z]*\*.*/){ # testa se a linha comtém uma palavra.
			my @linha = split (//, $_);
			my $count = 0;
			
			#Obtém o início da palavra.
			while (@linha[$count] !~ /[a-zA-Z]/) { $count++; } 
			my $inicio = $count;
			
			#Obtém o fim da palavra e calcula o tamanho.
			while (@linha[$count] =~ /[a-zA-Z]/) { $count++; }
			my $tamanho = $count - $inicio;			
			
			# Obtém a palavra em caixa baixa e grava no arquivo.
			my $palavra = lc (substr ($_, $inicio, $tamanho));
			print $out "$palavra\n";
		}
	}

	close ($in) or die "cant't close $letra.txt: $!";

}

close ($out) or die "cant't close dict_simples_pt-br.txt: $!"

