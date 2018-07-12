use Utilities;

IniciarAnalise ("/home/humano/Área de Trabalho/lingprog/programa/perl/Utilities/t/texto1.txt");

CarregarDicionarios();
SalvarDicionarios();

while (!ObterParagrafo()) {
	print "\n".ParagrafoAtual()."\n";
	print VerificarPalavras();
}
print "\n";

TerminarAnalise();
