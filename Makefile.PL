use 5.10.0;

use inc::Module::Install;

name 'Net-CoverArtArchive';
abstract 'Bindings to www.coverartarchive.org';
author 'MetaBrainz Foundation';
license 'perl';
version_from 'lib/Net/CoverArtArchive.pm';

requires 'LWP::UserAgent';
requires 'Moose';

WriteAll;
