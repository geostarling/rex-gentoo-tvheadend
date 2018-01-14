package Rex::Gentoo::Tvheadend;

use Rex -base;

task 'setup', sub {

  pkg "media-tv/tvheadend", ensure => 'present';

  setup_config_repo();

};

task 'setup_config_repo', sub {

  my $config_dir = '/etc/tvheadend';
  my $config_repo_url = param_lookup 'Rex::Gentoo::Tvheadend::config_repo_url';
  my $config_repo_ref = param_lookup 'Rex::Gentoo::Tvheadend::config_repo_ref', 'master';
  my $git_cmd = "git -C $coniig_dir";

  # 1. initialize git repo if it does not exist
  if (! is_directory("$config_dir/.git") ) {
    run "$git_cmd init";
  }

  # 2. synchronize it with the remote if desired
  if (! defined $config_repo_url ) {
    if ( run "$git_cmd remote | grep origin" ne "origin" ) {
      run "$git_cmd add origin $config_repo_url";
    } else {
      run "$git_cmd set-url origin $config_repo_url", unless => "$git_cmd get-url origin $config_repo_url | grep $config_repo_url";
    }
    # 3. and fetch the new stuff from remote
    run "$git_cmd fetch origin";
  }

  # 4. _reset_ current branches HEAD to desired ref so a working copy is not overwritte
  run "$git_cmd reset $config_repo_ref";

};

1;

=pod

=head1 NAME

$::module_name - {{ SHORT DESCRIPTION }}

=head1 DESCRIPTION

{{ LONG DESCRIPTION }}

=head1 USAGE

{{ USAGE DESCRIPTION }}

 include qw/Rex::Gentoo::Install/;

 task yourtask => sub {
    Rex::Gentoo::Install::example();
 };

=head1 TASKS

=over 4

=item example

This is an example Task. This task just output's the uptime of the system.

=back

=cut
