#!/usr/bin/perl

# Programa que simplifica os dicionários para conter apenas uma palavra por linha

use strict;

# Simplifica o dicionário das palavras em português

my $in;
my $out;

open ($out, ">", "dict_pt-br.txt") or die "Can't open dict_pt-br.txt: $!";

my @AtoZ = split (//, "ABCDEFGHIJKLMNOPQRSTUVWXYZ"); # Obtém um array com cada letra do alfabeto.

foreach my $letra (@AtoZ){ # Para cada letra...

	open ($in, "<", "$letra.txt") or die "Can't open $letra.txt: $!";
	
	while (<$in>){
		if ($_ =~ /\*( \*)?[a-zA-Zà-úÀ-Ú\-]*\*.*/){ # Testa se a linha tem o formato de interesse.
			my @linha = split (//, $_);
			my $count = 0;
			
			# Obtém o início da palavra.
			while ($linha[$count] !~ /[a-zA-Zà-úÀ-Ú\-]/) { $count++; } 
			my $inicio = $count;
			
			# Obtém o fim da palavra e calcula o tamanho.
			while ($linha[$count] =~ /[a-zA-Zà-úÀ-Ú\-]/) { $count++; }
			my $tamanho = $count - $inicio;			
			
			# Obtém a palavra em caixa baixa e grava no arquivo.
			my $palavra = lc (substr ($_, $inicio, $tamanho));
			print $out "$palavra\n";
		}
	}

	close ($in) or die "cant't close Nomes.txt: $!";

}

close ($out) or die "cant't close dict_simples_pt-br.txt: $!";

# Simplifica o dicionário de nomes

open ($out, ">", "dict_nomes.txt") or die "Can't open dict_nomes.txt: $!";
open ($in, "<", "Names.txt") or die "Can't open Names.txt: $!";

while (<$in>){
	if ($_ =~ /& \*[a-zA-Zà-úÀ-Ú\-]*.*/){ # Testa se a linha tem o formato de interesse.
		my @linha = split (//, $_);
		my $count = 0;
		
		# Obtém o início da palavra.
		while ($linha[$count] !~ /[a-zA-Zà-úÀ-Ú\-]/) { $count++; } 
		my $inicio = $count;
		
		# Obtém o fim da palavra e calcula o tamanho.
		while ($linha[$count] =~ /[a-zA-Zà-úÀ-Ú\-]/) { $count++; }
		my $tamanho = $count - $inicio;			
		
		# Obtém a palavra em caixa baixa e grava no arquivo.
		my $palavra = lc (substr ($_, $inicio, $tamanho));
		print $out "$palavra\n";
		
		#print $palavra; #DEBUG
		#print "\n"; #DEBUG
	}
}

close ($in) or die "cant't close Names.txt: $!";
close ($out) or die "cant't close dict_nomes.txt: $!";
