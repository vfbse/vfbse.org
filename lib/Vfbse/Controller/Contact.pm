package Vfbse::Controller::Contact;
use Mojo::Base 'Mojolicious::Controller';
use Regexp::Common qw[Email::Address];
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP ();
use Email::Simple ();
use Email::Simple::Creator ();

# This action processes and displays the contact form page
sub do {
  my $self = shift;
  my $val = $self->validation;
  my $msgs = '';

  # POST params
  my $topic = 'topic';
  my $topic_value = '';

  my $details = 'details';
  my $details_value = '';

  my $email = 'email';
  my $email_value = '';

  my $math = 'math';

  if ($val->has_data) { # it's a POST request
    $val->required($topic)->size(1, 50);
    $val->required($details)->size(1, 500);
    $val->required($email)->size(1, 50)->like(qr/^$RE{Email}{Address}$/);
    $val->required($math)->size(1, 4);

    if ($val->has_error($topic)) {
      $msgs .= get_html_error('Kein Thema angegeben.');
    } else {
      $topic_value = $self->param($topic);
    }

    if ($val->has_error($details)) {
      $msgs .= get_html_error('Keine Details angegeben.');
    } else {
      $details_value = $self->param($details);
    }

    if ($val->has_error($email)) {
      $msgs .= get_html_error('Die E-Mail-Adresse ist ungültig.');
    } else {
      $email_value = $self->param($email);
    }

    if ($val->has_error($math)) {
      $msgs .= get_html_error('Die Sicherheitsfrage wurde nicht gelöst.');
    } else {
      if ($self->session($math) != $self->param($math)) {
        $msgs .= get_html_error('Die Sicherheitsfrage wurde falsch beantwortet.');
      }
    }

    if (!$msgs) {
      my $email_config = $self->app->{config}->{email};
      send_mail($email_config, $email_value, $topic_value, $details_value);
      $self->stash(msgs => get_html_success('Vielen Dank für Ihre Nachricht.'));
      # clear form values after success
      $topic_value = ''; $details_value = ''; $email_value = '';
    } else {
      $self->stash(msgs => $msgs);
    }
  }

  my %math_task = get_math_task();
  $self->stash($math => $math_task{task});
  $self->session($math => $math_task{result});

  return $self->render(template => 'main/contact', topic => $topic_value,
    details => $details_value, email => $email_value);
}

# Returns a small html element as a string representing an error message.
sub get_html_error {
  my $msg = shift;
  return '<div class="card-panel red lighten-3"><span class="white-text">' . $msg .
    '</span></div>';
}

# Returns a small html element as a string representing a success message.
sub get_html_success {
  my $msg = shift;
  return '<div class="card-panel green lighten-3"><span class="white-text">' . $msg .
    '</span></div>';
}

# Returns a hash containing a somewhat textualized arithmetic problem and the
# solution to it. It serves as a weak yet existing captcha for the contact form.
# The hash structure is as follows:
# ("task" => string, "result" => number)
sub get_math_task {
  my $first = int(rand(500));
  my $second = int(rand(500));
  my $op = int(rand(2));
  my @ops = ('plus', 'minus');
  my $result = ($op == 0 ? $first + $second : $first - $second);

  return (task => $first . ' ' . $ops[$op] . ' ' . $second, result => $result);
}

# Sends a mail via SMTP to recipients internally specified. The subroutine
# expects four arguments, the first one being an object representing the email
# sub-part of the application configuration, the second one being the sender of
# the mail, the third one being the email subject and the fourth one being the
# body.
sub send_mail {
  my ($mail_cfg, $from, $subject, $body) = @_;

  my $transport = Email::Sender::Transport::SMTP->new({
    host => $mail_cfg->{server},
    port => $mail_cfg->{port},
    sasl_username => $mail_cfg->{user},
    sasl_password => $mail_cfg->{pass},
  });

  my $email = Email::Simple->create(
    header => [
      To      => $mail_cfg->{to},
      Cc      => $mail_cfg->{cc},
      From    => $from,
      Subject => $subject,
    ],
    body => $body . "\n",
  );

  sendmail($email, { transport => $transport });
}

1;
