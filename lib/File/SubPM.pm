#!perl
#
# Documentation, copyright and license is at the end of this file.
#
package  File::SubPM;

use 5.001;
use strict;
use warnings;
use warnings::register;

use vars qw($VERSION $DATE);
$VERSION = '1.11';
$DATE = '2003/07/26';

use SelfLoader;

1

__DATA__


#####
# Determine the output generator program modules
#
sub sub_modules
{
   my (undef, $base_file, @dirs ) = @_;

   use Cwd;
   use File::Glob ':glob';
   use File::Spec;

   my $restore_dir = cwd();
   my ($vol, $dirs, undef) = File::Spec->splitpath(File::Spec->rel2abs($base_file));
   chdir $vol if $vol;
   chdir $dirs if $dirs;
   $dirs = File::Spec->catdir( @dirs );
   chdir $dirs if $dirs;
   my @modules = bsd_glob( '*.pm' );
   foreach my $module (@modules) {
       $module =~ s/\.pm$//;
   }
   chdir $restore_dir;
   @modules

}


#####
# Determine if a module is valid
#
sub is_module
{
   my (undef, $module, @modules) = @_;

   ($module) = $module =~ /^\s*(.*)\s*$/; # zap leading, trailing white space
   my $length = length($module);
   $module = lc($module);
   return undef unless( $length );

   my $module_found = '';
   foreach my $module_test (@modules) {
       if( $module eq  substr(lc($module_test), 0, $length)) {
           if( $module_found ) {
               warn "# Ambiguous $module\n";
               return undef;
           }
           $module_found = $module_test;
       }
   }
   return $module_found if $module_found;
   warn( "# Cannot find sub module $module.\n");
   undef

}


1

__END__


=head1 NAME

File::SubPM - support sub program modules as files in a sub directory

=head1 SYNOPSIS

  use File::SubPM

  @sub_modules   = File::FileUtil->sub_modules($base_file, @dirs)
  $module        = File::FileUtil->is_module($module, @modules)

=head1 DESCRIPTION

=head2 is_module method

 $driver = Test::TestUtil->is_module($module, @modules)

The I<is_module> method determines if I<$module> is present
in I<@modules>. The detemination is case insensitive and
only the leading characters are needed.

=head2 sub_modules method

 @sub_modules = File::FileUtil->sub_modules($base_file, @dirs)

Placing sub modules in their own private directory provides
a method to add a new sub_modules without changing the using module.
The parent object finds all the available sub_modules by listing
the modules in the sub_module directory using the I<sub_modules> method.

The I<sub_modules> method takes as its input a I<$base_file>, a file
in the parent directory, and a list of subdirectories, I<@dirs>, relative to
the I<$base_file>. It returns the a list,  I<@sub_modules>, of I<*.pm> file names 
stripped of the extension I<.pm> in the identified directory.

=head1 REQUIREMENTS

Coming soon.

=head1 DEMONSTRATION

 ~~~~~~ Demonstration overview ~~~~~

Perl code begins with the prompt

 =>

The selected results from executing the Perl Code 
follow on the next lines. For example,

 => 2 + 2
 4

 ~~~~~~ The demonstration follows ~~~~~

 =>     use File::Spec;

 =>     use File::Package;
 =>     my $fp = 'File::Package';

 =>     my $sm = 'File::SubPM';
 =>     my $loaded = '';
 => my $errors = $fp->load_package( $sm )
 => $errors
 ''

 => my @drivers = sort $sm->sub_modules( __FILE__, 'Drivers' )
 => join (', ', @drivers)
 'Driver, Generate, IO'

 => $sm->is_module('dri', @drivers )
 'Driver'


=head1 QUALITY ASSURANCE

The module "t::File::SubPM" is the Software
Test Description(STD) module for the "File::SubPM".
module. 

To generate all the test output files, 
run the generated test script,
run the demonstration script and include it results in the "File::SubPM" POD,
execute the following in any directory:

 tmake -test_verbose -replace -run  -pm=t::File::SubPM

Note that F<tmake.pl> must be in the execution path C<$ENV{PATH}>
and the "t" directory containing  "t::File::SubPM" on the same level as 
the "lib" directory that
contains the "File::SubPM" module.

=head1 NOTES

=head2 AUTHOR

The holder of the copyright and maintainer is

E<lt>support@SoftwareDiamonds.comE<gt>

=head2 COPYRIGHT NOTICE

Copyrighted (c) 2002 Software Diamonds

All Rights Reserved

=head2 BINDING REQUIREMENTS NOTICE

Binding requirements are indexed with the
pharse 'shall[dd]' where dd is an unique number
for each header section.
This conforms to standard federal
government practices, 490A (L<STD490A/3.2.3.6>).
In accordance with the License, Software Diamonds
is not liable for any requirement, binding or otherwise.

=head2 LICENSE

Software Diamonds permits the redistribution
and use in source and binary forms, with or
without modification, provided that the 
following conditions are met: 

=over 4

=item 1

Redistributions of source code must retain
the above copyright notice, this list of
conditions and the following disclaimer. 

=item 2

Redistributions in binary form must 
reproduce the above copyright notice,
this list of conditions and the following 
disclaimer in the documentation and/or
other materials provided with the
distribution.

=back

SOFTWARE DIAMONDS, http::www.softwarediamonds.com,
PROVIDES THIS SOFTWARE 
'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL SOFTWARE DIAMONDS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL,EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE,DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING USE OF THIS SOFTWARE, EVEN IF
ADVISED OF NEGLIGENCE OR OTHERWISE) ARISING IN
ANY WAY OUT OF THE POSSIBILITY OF SUCH DAMAGE. 

=for html
<p><br>
<!-- BLK ID="NOTICE" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="OPT-IN" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="EMAIL" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="COPYRIGHT" -->
<!-- /BLK -->
<p><br>
<!-- BLK ID="LOG_CGI" -->
<!-- /BLK -->
<p><br>

=cut

### end of file ###