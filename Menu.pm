package Tags::HTML::Menu;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_menu', 'lang', 'logo_image_url', 'logo_url', 'logout_url', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_menu'} = 'menu';

	# Language.
	$self->{'lang'} = 'eng';

	# Logo.
	$self->{'logo_image_url'} = undef;

	# Logo width in pixels.
	$self->{'logo_width'} = '20vw';

	# Logo URL.
	$self->{'logo_url'} = undef;

	# Logout URL.
	$self->{'logout_url'} = undef;

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'logout' => 'Log out',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	# Check logout url.
	if (! defined $self->{'logout_url'}) {
		err "Parameter 'logout_url' is required.";
	}

	# Object.
	return $self;
}

sub _cleanup {
	my $self = shift;

	delete $self->{'_data'};

	return;
}

sub _init {
	my ($self, $data_hr) = @_;

	if (exists $self->{'_data'}) {
		return;
	}

	$self->{'_data'} = $data_hr;

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	$self->{'tags'}->put(
		['b', 'header'],
		['a', 'class', $self->{'css_menu'}],

		['b', 'div'],
		['a', 'id', 'container'],

		# Left menu part.
		['b', 'span'],
		['a', 'id', 'menu-left'],

		# Logo.
		defined $self->{'logo_image_url'} ? (
			defined $self->{'logo_url'} ? (
				['b', 'a'],
				['a', 'href', $self->{'logo_url'}],
			) : (),
			['b', 'img'],
			['a', 'id', 'logo'],
			['a', 'src', $self->{'logo_image_url'}],
			['a', 'alt', 'logo'],
			['e', 'img'],
			defined $self->{'logo_url'} ? (
				['e', 'a'],
			) : (),
		) : (),

		# Actual title.
		defined $self->{'_data'}->{'title'} ? (
			['b', 'span'],
			['a', 'id', 'title'],
			['d', $self->{'_data'}->{'title'}],
			['e', 'span'],
		) : (),

		['e', 'span'],

		# Right menu part.
		# TODO Menu items.
		# TODO Language
		defined $self->{'_data'}->{'login_name'} ? (
			['b', 'span'],
			['a', 'id', 'menu-right'],

			['b', 'span'],
			['a', 'id', 'login'],
			# Login name
			['d', $self->{'_data'}->{'login_name'}],
			['d', '&nbsp;'],
			# Logout link
			['d', '('],
			['b', 'a'],
			['a', 'href', $self->{'logout_url'}],
			['d', $self->_text('logout')],
			['e', 'a'],
			['d', ')'],
			['e', 'span'],

			['e', 'span'],
		) : (),

		['e', 'div'],

		['e', 'header'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_menu'}],
		['d', 'border-bottom', '1px solid black'],
		['d', 'line-height', '100px'],
		['e'],

		['s', '#menu-left #logo'],
		['d', 'vertical-align', 'middle'],
		['d', 'width', $self->{'logo_width'}],
		['e'],

		['s', '#menu-left #title'],
		['d', 'vertical-align', 'middle'],
		['d', 'padding-left', '10px'],
		['d', 'font-size', '2em'],
		['e'],

		['s', '#menu-right'],
		['d', 'float', 'right'],
		['e'],

		['s', '#menu-right #login'],
		['d', 'vertical-align', 'middle'],
		['e'],
	);

	return;
}

sub _text {
	my ($self, $key) = @_;

	if (! exists $self->{'text'}->{$self->{'lang'}}->{$key}) {
		err "Text for lang '$self->{'lang'}' and key '$key' doesn't exist.";
	}

	return $self->{'text'}->{$self->{'lang'}}->{$key};
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Menu - Tags helper for menu.

=head1 SYNOPSIS

 use Tags::HTML::Menu;

 my $obj = Tags::HTML::Menu->new(%params);
 $obj->process($data_hr);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Menu->new(%params);

Constructor.

Returns instance of object.

=over 8

=item * C<css_competition>

CSS class for root div element.

Default value is 'competition'.

=item * C<TODO>

TODO

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process($data_hr);

Process Tags structure for output with information about menu.
Structure consists from:
 {
         'login_name' => __LOGIN_NAME__ (optional - default is 'Login name')
         'section' => __SECTION__ (optional - default is 'Section')
 }

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.
         Parameter 'logout_url' is required.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Tags::HTML::Menu;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Menu->new(
         'logo_image_url' => 'http://example.com/image.png',
         'logout_url' => 'https://example.com/logout',
         'tags' => $tags,
 );

 # Process list of competitions.
 $obj->process({
         'login_name' => 'Skim',
         'section' => 'Application',
 });

 # Print out.
 print $tags->flush;

 # Output:
 # <header class="menu">
 #   <div id="container">
 #     <span id="menu-left">
 #       <img id="logo" src="http://example.com/image.png"
 #         alt="logo">
 #       </img>
 #       <span id="section">
 #         Application
 #       </span>
 #     </span>
 #     <span id="menu-right">
 #       <span id="login">
 #         Skim
 #         (
 #         <a href="https://example.com/logout">
 #           Log out
 #         </a>
 #         )
 #       </span>
 #     </span>
 #   </div>
 # </header>

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<Tags::HTML>.

=head1 SEE ALSO

=over

TODO

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Tags-HTML-Menu>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2021-2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
