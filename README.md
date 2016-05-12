# vfbse.org

## About

This is the code for the application running at vfbse.org. It is a work in
progress and therefore heavily bound to its context. For example, all strings
returned to the end user are in German.

## Technicalities

The web application is realized with [Mojolicious](http://mojolicious.org/) and
[Materialize](http://materializecss.com/).

## Installing

You need to have Mojolicious installed. The simplest way of installing the
framework on a new system (provided that you have curl, sudo and make) is via
the console:

> sudo -s 'curl -L cpanmin.us | perl - Mojolicious'

More information is available in the Mojolicious documentation or
[wiki](https://github.com/kraih/mojo/wiki).

Several other Perl modules are used. These dependencies are defined in the
*cpanfile* and can be resolved with [cpanm](search.cpan.org/perldoc?cpanm). Just
download and call cpanm in the root directory of the application:

> curl -LO http://xrl.us/cpanm
> perl cpanm --installdeps .

## Using



## Feedback
