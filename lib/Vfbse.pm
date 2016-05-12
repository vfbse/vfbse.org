package Vfbse;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;
  my $config = $self->plugin('Config' => {file => 'vfbse.conf'});

  # Routing
  my $r = $self->routes;
  $r->get('/')->to('main#home');
  $r->get('/statute')->to('main#statute');
  $r->get('/legal')->to('main#legal');
  $r->get('/about')->to('main#about');
  $r->get('/projects')->to('main#projects');
  $r->get('/articles')->to('main#articles');
  $r->any(['GET', 'POST'] => '/contact')->to('contact#do');

  # Other stuff
  $self->secrets(['-- place your very very secret string here --']);
}

1;
