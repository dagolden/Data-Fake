use 5.008001;
use strict;
use warnings;

package Data::Fake::Company;
# ABSTRACT: Fake company and job data generators

our $VERSION = '0.001';

use Exporter 5.57 qw/import/;

our @EXPORT = qw(
  fake_company
  fake_title
);

use Data::Fake::Names ();

my ( @job_titles,     $job_title_count );
my ( @company_suffix, $company_suffix_count );

sub _job_title      { return $job_titles[ int( rand($job_title_count) ) ] }
sub _company_suffix { return $company_suffix[ int( rand($company_suffix_count) ) ] }

sub fake_company {
    my $fake_surname = Data::Fake::Names::fake_surname();
    return sub {
        my $format = int( rand(3) );
        if ( $format == 0 ) {
            return sprintf( "%s, %s", $fake_surname->(), _company_suffix );
        }
        elsif ( $format == 1 ) {
            return sprintf( "%s-%s", map { $fake_surname->() } 1 .. 2 );
        }
        elsif ( $format == 2 ) {
            return sprintf( "%s, %s and %s", map { $fake_surname->() } 1 .. 3 );
        }
    };
}

sub fake_title {
    return sub { _job_title() }
}

# list of most common job titles from glassdoor.com with some edits and
# amendments
@job_titles = (
    'Account Executive',
    'Account Manager',
    'Accountant',
    'Actuary',
    'Administrative Assistant',
    'Analyst',
    'Applications Engineer',
    'Architect',
    'Art Director',
    'Assistant Manager',
    'Assistant Store Manager',
    'Assistant Vice President',
    'Associate',
    'Associate Consultant',
    'Associate Director',
    'Attorney',
    'Audit Associate',
    'Branch Manager',
    'Business Analyst',
    'Business Development Manager',
    'Cashier',
    'Civil Engineer',
    'Consultant',
    'Customer Service',
    'Customer Service Representative',
    'Data Analyst',
    'Design Engineer',
    'Developer',
    'Director',
    'Editor',
    'Electrical Engineer',
    'Engineer',
    'Engineering Manager',
    'Executive Assistant',
    'Finance Manager',
    'Financial Advisor',
    'Financial Analyst',
    'Financial Representative',
    'Flight Attendant',
    'General Manager',
    'Graduate Research Assistant',
    'Graphic Designer',
    'Hardware Engineer',
    'Human Resources Manager',
    'Investment Banking Analyst',
    'IT Analyst',
    'It Manager',
    'IT Specialist',
    'Law Clerk',
    'Management Trainee',
    'Manager',
    'Marketing Assistant',
    'Marketing Director',
    'Marketing Manager',
    'Mechanical Engineer',
    'Member of Technical Staff',
    'Network Engineer',
    'Office Manager',
    'Operations Analyst',
    'Operations Manager',
    'Personal Banker',
    'Pharmacist',
    'Principal Consultant',
    'Principal Engineer',
    'Principal Software Engineer',
    'Process Engineer',
    'Product Manager',
    'Program Manager',
    'Programmer',
    'Programmer Analyst',
    'Project Engineer',
    'Project Manager',
    'Public Relations',
    'QA Engineer',
    'Recruiter',
    'Registered Nurse',
    'Research Analyst',
    'Research Assistant',
    'Research Associate',
    'Sales',
    'Sales Associate',
    'Sales Engineer',
    'Sales Manager',
    'Sales Representative',
    'Senior Accountant',
    'Senior Analyst',
    'Senior Associate',
    'Senior Business Analyst',
    'Senior Consultant',
    'Senior Director',
    'Senior Engineer',
    'Senior Financial Analyst',
);

@company_suffix = qw( Inc. Corp. LP LLP LLC );

$job_title_count      = @job_titles;
$company_suffix_count = @company_suffix;

=for Pod::Coverage BUILD

=head1 SYNOPSIS

    use Data::Fake::Core;

=head1 DESCRIPTION

This module might be cool, but you'd never know it from the lack
of documentation.

=head1 USAGE

Good luck!

=head1 SEE ALSO

=for :list
* Maybe other modules do related things.

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:
