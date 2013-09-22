use strict;
use warnings;
use utf8;
use Test::More;
use Test::Requires 'Software::License';
use t::Util;

use CPAN::Meta;

use Minilla::Profile::Default;
use Minilla::Project;
use Minilla::Git;

subtest 'develop deps' => sub {
    my $guard = pushd(tempdir());

    my $profile = Minilla::Profile::Default->new(
        author => 'Tokuhiro Matsuno',
        dist => 'Acme-Foo',
        path => 'Acme/Foo.pm',
        suffix => 'Foo',
        module => 'Acme::Foo',
        version => '0.01',
        email => 'tokuhirom@example.com',
    );
    $profile->generate();
    write_minil_toml('Acme-Foo', {
        license => 'artistic_2_0',
    });
    git_init_add_commit();

    my $project = Minilla::Project->new();
    is_deeply(
        $project->contributors,
        ['Foo <foo@example.com>',
        'Bar <bar@example.com>'],
    );
    $project->regenerate_files();
    is_deeply(
        CPAN::Meta->load_file('META.json')->{x_contributors},
        ['Foo <foo@example.com>',
        'Bar <bar@example.com>'],
    );
};

done_testing;

