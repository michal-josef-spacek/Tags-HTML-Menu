#!/usr/bin/env perl

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
$obj->init({
        'login_name' => 'Skim',
        'title' => 'Application',
});
$obj->process;

# Print out.
print $tags->flush;

# Output:
# <header class="menu">
#   <div id="logo">
#     <img src="http://example.com/image.png" alt="logo">
#     </img>
#   </div>
#   <div id="title">
#     Application
#   </div>
#   <div id="login">
#     Skim
#     &nbsp;
#     (
#     <a href="https://example.com/logout">
#       Log out
#     </a>
#     )
#   </div>
# </header>