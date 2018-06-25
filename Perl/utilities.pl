#!/usr/bin/perl

# Este arquivo implementa as funções necessárias para cada tipo de processamento de texto realizado pelo perl.

use strict;

my $arquivoTexto;  # Stream do arquivo texto tratado.
my $caminhoArquivo = "";
my $paragrafo = "";
my @array_ptbr;
my $numeroPalavras_ptbr = 0;
my @arrayNomes;
my $numeroNomes = 0;


# Carrega os dicionários na memória.
sub CarregarDicionarios {
	my @linha;
	$numeroPalavras_ptbr = 0;
	$numeroNomes = 0;
	
	open (my $dicionario_ptbr, "<", "../dict/dict_pt-br.txt") or die "Can't open file dict_pt-br.txt: $!";
	while (<$dicionario_ptbr>) {
		# Retira a o caracter '\n' na linha do arquivo e adiciona a palavra no vetor.
		@linha = split (/\n/, $_);
		push @array_ptbr, $linha[0];
		$numeroPalavras_ptbr ++;
	}
	close ($dicionario_ptbr) or die "cant't close dict_pt-br.txt: $!";

	open (my $dicionarioNomes, "<", "../dict/dict_nomes.txt") or die "Can't open file dict_nomes.txt: $!";
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
	open (my $dicionario_ptbr, ">", "../dict/dict_pt-br.txt") or die "Can't open file dict_pt-br.txt: $!";
	foreach $linha (@array_ptbr) {
		print $dicionario_ptbr "$linha\n";
	}
	close ($dicionario_ptbr) or die "cant't close dict_pt-br.txt: $!";
	
	# Ordena o array e grava no arquivo de nomes.
	@arrayNomes = sort @arrayNomes;
	open (my $dicionarioNomes, ">", "../dict/dict_nomes.txt") or die "Can't open file dict_nomes.txt: $!";
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



# --------------------- TESTES ---------------------


IniciarAnalise ("../testes/texto1.txt");

CarregarDicionarios();
SalvarDicionarios();

while (!ObterParagrafo()) {
	print "\n$paragrafo";
	print VerificarPalavras();
}
print "\n";

TerminarAnalise();

