use 5.026001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Utilities',
    VERSION_FROM      => 'lib/Utilities.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/Utilities.pm', # retrieve abstract from module
    AUTHOR            => 'Renan Passos <renanpassos@poli.ufrj.br>',
    #LICENSE           => 'perl',
    #Value must be from legacy list of licenses here
    #http://search.cpan.org/perldoc?Module%3A%3ABuild%3A%3AAPI
    LIBS              => [''], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    INC               => '-I.', # e.g., '-I. -I/usr/include/other'
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
if  (eval {require ExtUtils::Constant; 1}) {
  # If you edit these definitions to change the constants used by this module,
  # you will need to use the generated const-c.inc and const-xs.inc
  # files to replace their "fallback" counterparts before distributing your
  # changes.
  my @names = (qw());
  ExtUtils::Constant::WriteConstants(
                                     NAME         => 'Utilities',
                                     NAMES        => \@names,
                                     DEFAULT_TYPE => 'IV',
                                     C_FILE       => 'const-c.inc',
                                     XS_FILE      => 'const-xs.inc',
                                  );

}
else {
  use File::Copy;
  use File::Spec;
  foreach my $file ('const-c.inc', 'const-xs.inc') {
    my $fallback = File::Spec->catfile('fallback', $file);
    copy ($fallback, $file) or die "Can't copy $fallback to $file: $!";
  }
}


# Modifica o arquivo do módulo para conter o diretório de instalação em uma variável;

open (my $in, "<", "lib/Utilities.pm") or die "Can't open lib/Utilities.pm: $!";
open (my $out, ">", "lib/Utilities.pm.new") or die "Can't open lib/Utilities.pm.new: $!";

while (<$in>){
	if ($_ =~ /my \$moduleDir = .*/){ # Testa se a linha contém a definição do diretório de instalação do módulo.

		my @argumento = split (/=/, $ARGV[0]); # Separa o par nome-valor do argumento pelo sinal '='.
		my $installBase = $argumento[1]; 
		print $out "my \$moduleDir = \"${installBase}/lib/perl5/x86_64-linux-gnu-thread-multi\";\n";
		
	}
	else {
		
		print $out $_;
		
	}
}

close ($out) or die "cant't close lib/Utilities.pm.new: $!";
close ($in) or die "cant't close lib/Utilities.pm: $!";

# Substitui o módulo pelo novo arquivo (Utilities.pm.new).
`mv lib/Utilities.pm lib/Utilities.pm.old && mv lib/Utilities.pm.new lib/Utilities.pm`;
