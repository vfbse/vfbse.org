package Vfbse::Controller::Main;
use Mojo::Base 'Mojolicious::Controller';

# This action renders the home page
sub home {
  my $self = shift;
  $self->render();
}

# This action renders the statute page
sub statute {
  my $self = shift;
  # The beauty of static content..
  $self->render();
}

# This action renders the page providing the legal information
sub legal {
  my $self = shift;
  $self->render();
}

# This action renders the about page
sub about {
  my $self = shift;
  $self->render();
}

# This action renders the projects page
sub projects {
  my $self = shift;
  $self->render();
}

# This action renders the page for the articles
sub projects {
  my $self = shift;
  $self->render();
}

1;
