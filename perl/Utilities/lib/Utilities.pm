package Utilities;

use 5.026001;
use strict;
use warnings;
use Carp;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Utilities ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	ParagrafoAtual
	IniciarAnalise
	CarregarDicionarios
	SalvarDicionarios
	ObterParagrafo
	VerificarPalavras
	TerminarAnalise
);

our $VERSION = '0.01';


my $arquivoTexto;  # Stream do arquivo texto tratado.
my $caminhoArquivo = "";
my $paragrafo = "";
my @array_ptbr;
my $numeroPalavras_ptbr = 0;
my @arrayNomes;
my $numeroNomes = 0;
my $moduleDir = "/home/humano/ortotxt-perllib/lib/perl5/x86_64-linux-gnu-thread-multi";

# Retorna o paragrafo atual.
sub ParagrafoAtual {
	return $paragrafo;
}

# Carrega os dicionários na memória.
sub CarregarDicionarios {
	my @linha;
	$numeroPalavras_ptbr = 0;
	$numeroNomes = 0;

	open (my $dicionario_ptbr, "<", "$moduleDir/dict_pt-br.txt") or die "\nError:  Can't open file dict_pt-br.txt: $!";
	while (<$dicionario_ptbr>) {
		# Retira a o caracter '\n' na linha do arquivo e adiciona a palavra no vetor.
		@linha = split (/\n/, $_);
		push @array_ptbr, $linha[0];
		$numeroPalavras_ptbr ++;
	}
	close ($dicionario_ptbr) or die "cant't close dict_pt-br.txt: $!";

	open (my $dicionarioNomes, "<", "$moduleDir/dict_nomes.txt") or die "Can't open file dict_nomes.txt: $!";
	while (<$dicionarioNomes>) {
		# Retira a o caracter '\n' na linha do arquivo e adiciona a palavra no vetor.
		@linha = split (/\n/, $_);
		push @arrayNomes, $linha[0];
		$numeroNomes ++;
	}
	close ($dicionarioNomes) or die "cant't close dict_nomes.txt: $!";
}

# Salva os dicionários atuais na memória com as palavras ordenadas.
sub SalvarDicionarios {
	my $linha;
	
	# Ordena o array e grava no arquivo de palavras ptbr.
	@array_ptbr = sort @array_ptbr;
	open (my $dicionario_ptbr, ">", "$moduleDir/dict_pt-br.txt") or die "Can't open file dict_pt-br.txt: $!";
	foreach $linha (@array_ptbr) {
		print $dicionario_ptbr "$linha\n";
	}
	close ($dicionario_ptbr) or die "cant't close dict_pt-br.txt: $!";
	
	# Ordena o array e grava no arquivo de nomes.
	@arrayNomes = sort @arrayNomes;
	open (my $dicionarioNomes, ">", "$moduleDir/dict_nomes.txt") or die "Can't open file dict_nomes.txt: $!";
	foreach $linha (@arrayNomes) {
		print $dicionarioNomes "$linha\n";
	}
	close ($dicionarioNomes) or die "cant't close dict_nomes.txt: $!";
	
}

# Inicia a análise abrindo o arquivo.
# Recebe o caminho completo para o arquivo texto a ser analisado e o diretorio base do programa.
sub IniciarAnalise {
	$caminhoArquivo = $_[0];
	open ($arquivoTexto, "<", $caminhoArquivo) or die "Can't open file at $caminhoArquivo: $!";
}

# Termina a analise fechando o arquivo.
sub TerminarAnalise {
	close ($arquivoTexto) or die "Can't close file at $caminhoArquivo: $!";
}

# Obtém o próximo parágrafo (não vazio), retornando 1 quando alcançado o fim do arquivo, ou 0 caso contrário.
sub ObterParagrafo {
	while (<$arquivoTexto>) {
		if ($_ =~ m/[a-zA-Z]/) {
			$paragrafo = $_;
			return 0;
		}
	}
	return 1;
}

# Verifica se a palavra passada como argumento está no dicionário ptbr utilizando busca binária.
# Retorna 1, se sim e 0, se não.
sub IsAWord {
	my $palavra = $_[0];
	
	my $inicio = 0;
	my $fim = $numeroPalavras_ptbr;
	my $meio = int (($inicio + $fim)/2);
	
	while ($fim - $inicio > 0) {
		if ((lc $palavra) eq $array_ptbr[$meio]) {
			return 1;
		}
		elsif ((lc $palavra) lt $array_ptbr[$meio]) {
			$fim = $meio;
		}
		elsif ((lc $palavra) gt $array_ptbr[$meio]) {
			$inicio = $meio + 1;
		}
		$meio = int (($inicio + $fim)/2);
	}
	
	return 0;
}

# Verifica se a palavra passada como argumento está no dicionário de nomes utilizando busca binária.
# Retorna 1, se sim e 0, se não.
sub IsAName {
	my $palavra = $_[0];

	my $inicio = 0;
	my $fim = $numeroNomes;
	my $meio = int (($inicio + $fim)/2);

	while ($fim - $inicio > 0) {
		if ((lc $palavra) eq $arrayNomes[$meio]) {
			return 1;
		}
		elsif ((lc $palavra) lt $arrayNomes[$meio]) {
			$fim = $meio;
		}
		elsif ((lc $palavra) gt $arrayNomes[$meio]) {
			$inicio = $meio + 1;
		}
		$meio = int (($inicio + $fim)/2);
	}

	return 0;
}

# Verifica se as palavras do paragrafo estão no dicionário.
# Retorna uma string com a descrição dos erros cometidos no parágrafo.
sub VerificarPalavras {
	my $resultado = "";
	
	# Separa a linha em palavras determinadas pelos espaços e pontuações.
	my @vetorParagrafo = split (/[\s\.\?,;:"']+/, $paragrafo);
	
	# Verifica as palavras e gera a string com o resultado da análise.
	foreach my $palavra (@vetorParagrafo) {
		if ($palavra ne "") {
			if (!IsAWord($palavra)) {
				$resultado = "${resultado}\t> \"$palavra\" não está presente no dicionário.\n";
			}
		}
	}

	return $resultado;
}

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Utilities - Perl extension to provide usefull functions for Ortotxt.

=head1 SYNOPSIS

  use Utilities;
  
  IniciarAnalise();
  CarregarDicionarios();
  SalvarDicionarios();
  ObterParagrafo();
  VerificarPalavras();
  TerminarAnalise();

=head1 DESCRIPTION

Stub documentation for Utilities, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Renan Passos, E<lt>renanpassos@poli.ufrj.br<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2018 by Renan Passos

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.26.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
