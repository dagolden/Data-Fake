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

my ( @job_titles );
my ( $job_title_count );

sub _job_title    { return $job_titles[ int( rand($job_title_count) ) ] }

sub fake_company {
    return sub {
        my $is_male = ( rand() < 0.5 );
        my @first = map { $is_male ? _male_first() : _female_first() } 1 .. 2;
        return join( " ", @first, _surname() );
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

$male_count      = @male_first;
$female_count    = @female_first;
$surname_count   = @surnames;
$job_title_count = @job_titles;

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
