use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Tags helper for menu.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0.03;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'Tags-HTML-Menu';
readme_from 'Menu.pm';
recursive_author_tests('xt');
requires 'Class::Utils' => 0.02;
requires 'Error::Pure' => 0.07;
requires 'perl' => '5.8.0';
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/Tags-HTML-Menu/issues';
resources 'homepage' => 'https://github.com/michal-josef-spacek/Tags-HTML-Menu';
resources 'repository' => 'git://github.com/michal-josef-spacek/Tags-HTML-Menu';
test_requires 'Tags::Output::Raw' => 0;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
