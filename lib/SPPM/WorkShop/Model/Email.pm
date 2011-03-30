
package SPPM::WorkShop::Model::Email;

use Moose;
extends 'SPPM::WorkShop::Model';

our $dir = SPPM::WorkShop->path_to('emails');

sub template {
    my ( $self, $template, @args ) = @_;
    my $filename = join( '/', $dir, $template );

    my $content = do {
        local ($/);
        open my $fh, '<', $filename or die "Error : $!";
        <$fh>;
    };

    my $loop = 0;
    foreach my $arg (@args) {
        $content =~ s/\%\%ARG$loop\%\%/$arg/g;
        $loop++;
    }

    return $content;
}

1;

