#!/usr/bin/env perl
#
# Solutions to Day 02 of the Advent of Code 2025 challenge written in Perl.
#
# Author: Nathaniel Struselis
# SPDX-License-Identifier: AGPL-3.0-only

# Use strict to apply stricter rules to variable declaration and scoping during
# compilation, generating compile time errors if the rules aren't met.
use strict;
# Use warnings to output warnings during compilation and execution for
# potentially problematic code.
use warnings;

# Use the POSIX module for some built-in POSIX-compliant functions. In this
# script, I only use the floor() function, so import only that for clarity.
use POSIX qw(floor);
# Use Getopt::Long to handle command line options.
use Getopt::Long;
# Use Pod::Usage for better help message handling.
use Pod::Usage;

# Define some exit codes as constants for use later.
use constant  ERR_OK   => 0; # Success exit code.
use constant  ERR_HELP => 1; # Help documentation was requested, causing exit.
use constant  ERR_ARGS => 2; # There was an error while processing arguments.
use constant  ERR_FILE => 3; # There was an error opening the input file.

# Subroutine to check if a particular ID consists of two repeated halves. This
# method is much faster than check_is_id_any_pattern() for this specific case.
#
# Arguments:
# - $_[0]: The ID to check.
#
# Usage:
#   check_is_id_half_repeated <id>
#
# Returns:
# - 0 if the ID does not consist of two identical halves.
# - 1 if the ID consists of two identical halves.
sub check_is_id_half_repeated {
    # Declare a variable for the ID to test and terminate if it is not provided.
    my $id = shift or die 'An ID is required by check_is_id_half_repeated().';

    # Default to assuming the ID is valid (i.e. does not contain a repeating
    # half).
    my $id_half_repeated = 0;

    # Get the number of characters in the ID.
    my $id_length = length($id);

    # Test the ID to check if it is made up of two identical halves. If the ID
    # length is odd, it cannot be made up of two identical halves.
    if ($id_length % 2 == 0) {
        # Calculate half the length of the ID string.
        my $half_len = $id_length / 2;

        # The ID length is even, so check if the two string halves are
        # identical.
        if (substr($id, 0, $half_len) eq substr($id, $half_len, $half_len)) {
            # If the first half of the ID equals the second half, mark the ID as
            # consisting of a repeating half.
            $id_half_repeated = 1;
        }
    }

    # Return whether the ID consists of a repeating half (1) or not (0).
    return $id_half_repeated;
}

# Subroutine to check if a particular ID consists entirely of any repeated
# pattern.
#
# Arguments:
# - $_[0]: The ID to check.
#
# Usage:
#   check_is_id_any_pattern <id>
#
# Returns:
# - 0 if the ID does not consist entirely of a repeated pattern.
# - 1 if the ID consists entirely of a repeated pattern.
sub check_is_id_any_pattern {
    # Declare a variable for the ID to test and terminate if it is not provided.
    my $id = shift or die 'An ID is required by check_is_id_any_pattern().';

    # Default to assuming that the ID does not consist entirely of a repeating
    # pattern.
    my $id_is_repeating_pattern = 0;

    # Get the number of characters in the ID.
    my $id_length = length($id);

    # Calculate the maximum pattern length that can exist within an ID. A
    # pattern cannot repeat unless it is less than half the length of the ID.
    #
    # floor is used here to round down in the case of odd-length ID's - there is
    # no point checking more than half the ID length as it can't be a pattern.
    my $max_pattern_length = floor($id_length / 2);

    # Iterate over each possible pattern length.
    for my $pattern_length (1 .. $max_pattern_length) {
        # If the ID length is not a multiple of the pattern length, skip this
        # pattern length as it can't possibly repeat evenly throughout the ID.
        if ($id_length % $pattern_length != 0) {
            next;
        }

        # For each possible pattern length, create a pattern string from the
        # original ID that must be repeated throughout the entire ID for it to
        # be classed as invalid.
        my $pattern = substr($id, 0, $pattern_length);

        # Count how many times the pattern appears in the ID string using regex:
        #
        # - $id =~ ... : Apply the regex pattern to the ID string.
        # - / ... /:     Delimiters for the regex pattern.
        # - \Q ... \E:   Escape any special characters in the ID (just in case).
        # - $pattern:    The ID pattern to count matches of.
        # - g:           Global flag to find ALL matches in the ID string, which
        #                will cause the regex expression to return a list of
        #                matches.
        # - () = ... :   Assign the list of matches to an empty list. In scalar
        #                context, the result of this is the number of elements
        #                that would be assigned to the list. In this case, the
        #                number of regex matches found.
        # - scalar(...): Explicitly wrap the expression in scalar context,
        #                returning the number of matches found.
        my $pattern_matches = scalar(() = $id =~ /\Q$pattern\E/g);

        # If the number of pattern matches multiplied by the pattern length
        # equals the ID length, the pattern repeats throughout the entire ID,
        # so the ID is invalid.
        if ($pattern_matches * $pattern_length == $id_length) {
            # Indicate that the ID consists entirely of a repeating pattern.
            $id_is_repeating_pattern = 1;
            # Exit the loop early as the ID does not need to be tested further.
            last;
        }
    }

    # Return whether the ID consists entirely of a repeating pattern (1) or not
    # (0).
    return $id_is_repeating_pattern;
}

# Subroutine to count invalid IDs from the input file, according to different
# criteria.
#
# Arguments:
# - $_[0]: The file path to the input data file.
#
# Usage:
#   count_invalid_ids <input_file_path>
#
# Returns:
# - A list containing the sums of invalid ID's according to different criteria:
#   - [0]: Sum of invalid ID's that are made up of two identical halves.
#   - [1]: Sum of invalid ID's that are made up of any repeating patterns.
sub count_invalid_ids {
    # Declare a variable for the input file path and terminate if it is not
    # provided.
    my $input_path = shift or die 'Input path required by count_invalid_ids().';

    # Open the input file, returning an error if it cannot be opened, and
    # writing the error message returned by the OS to stderr.
    open(my $input_fh, '<', $input_path)
        or die "Error opening '$input_path': $!";

    # The input file is expected to contain a single line of comma-separated ID
    # ranges. Read the entire file contents into a single string:
    #
    # - local $/: Undefine the input record separator to read the whole file
    #   (often called slurp mode).
    # - <$input_fh>: Read from the input file handle.
    # - do { ... }: Execute the block and return the last evaluated expression.
    #   This is really only there to limit the scope of the local "$/"" change
    #   as a best practice.
    my $input = do { local $/; <$input_fh> };

    # Close the input file handle, returning an error if it cannot be closed,
    # and writing the error massage returned by the OS to stderr.
    close($input_fh) or die "Error closing '$input_path': $!";

    # Split the input string into an array of ID ranges, denoted by commas.
    my @id_ranges = split(/,/, $input);

    # Initialize the sums for all invalid ID criteria.
    my $invalid_id_half_repeat = 0;
    my $invalid_id_any_pattern = 0;

    # Iterate over each ID range in the array.
    foreach my $range (@id_ranges) {
        # Split the range into start and end ID's, separated by a hyphen.
        my ($start_id, $end_id) = split(/-/, $range);

        # Iterate over each ID in the range (inclusive).
        for my $id ($start_id .. $end_id) {
            # Check if the ID is invalid according to any repeating pattern
            # criteria.
            if (check_is_id_half_repeated($id)) {
                # If the ID consists of two repeated halves, then it is counted
                # in both invalid sums, since a repeating half also matches the
                # criteria for ANY repeated section.
                $invalid_id_half_repeat += $id;
                $invalid_id_any_pattern += $id;
            } elsif (check_is_id_any_pattern($id)) {
                # If the ID is invalid according to any repeating pattern
                # criteria, add it to the corresponding sum.
                $invalid_id_any_pattern += $id;
            }
        }
    }

    # Return the sums of invalid ID's in the input data according to different
    # criteria.
    return ($invalid_id_half_repeat, $invalid_id_any_pattern);
}

# Main subroutine to parse arguments and execute the script logic.
sub main {
    # Declare variables to store the parsed command line options.
    my $help = 0;   # Help flag, defaults to false.
    my $input_file; # Input file path. Defaults to undefined.
    my $man = 0;    # Man flag, defaults to false.

    # Parse command line options using Getopt::Long. If parsing fails, display
    # a usage message and return an error code using Pod::Usage.
    #
    # For the pod2usage verbosity, 1 is used to give the full options list.
    GetOptions(
        'help|h' => \$help,
        'input|i=s' => \$input_file,
        'man|m' => \$man
    ) or pod2usage(-exitval => ERR_ARGS, -verbose => 1);

    # Display the man page or help message if the corresponding flags were set.
    # Note that the man page takes precedence over the help message, as it is
    # more detailed.
    #
    # For the man page, verbosity 2 is used to give the full documentation.
    # For the help message, verbosity 1 is used to give the full options list.
    #
    # An error exit code is used to indicate that the program exited due to user
    # request rather than successful completion, but the exit code of 1 means
    # pod2usage will output to stdout instead of stderr.
    pod2usage(
        -exitval => ERR_HELP,
        -verbose => 2
    ) if $man;
    pod2usage(
        -exitval => ERR_HELP,
        -verbose => 1
    ) if $help;

    # If neither man page or help message was requested, ensure that the
    # required input file option was provided. If not, display an error message
    # and the help string to stderr, and return an error code.
    pod2usage(
        -message => 'Missing required --input/-i option.',
        -exitval => ERR_ARGS,
        -verbose => 1
    ) if not defined $input_file;

    # Ensure that the specified input file exists and is readable. If not,
    # display an error message and the help string to stderr, and return an
    # error code.
    pod2usage(
        -message => "Input file '$input_file' doesn't exist or isn't readable.",
        -exitval => ERR_FILE,
        -verbose => 1
    ) if not ( -f $input_file and -r $input_file );

    # Call the subroutine to count the sums of invalid IDs by different
    # criteria, and assign the returned list to a list of variables to be
    # printed.
    my ($half_repeats, $any_pattern) = count_invalid_ids($input_file);

    # Print the solutions to part 1 and part 2 of the challenge.
    print(
        "AoC 2025 Day 02 Solutions:\n",
        "Part 1: $half_repeats\n",
        "Part 2: $any_pattern\n"
    );
}

# Invoke main script logic.
main();

# POD documentation for this script starts here.
__END__

=head1 NAME

day02.pl - Solutions to Day 02 of the Advent of Code 2025 challenge.

=head1 SYNOPSIS

day02.pl [options] --input <file_path>

=head1 OPTIONS

=over 2

=item B<--help> or B<-h>

Print the script's usage information, and exit.

=item B<--input> I<<file_path>> or B<-i> I<<file_path>>

Required. Specifies the input file to process.

=item B<--man> or B<-m>

Print the script's man page, and exit.

=back

=head1 DESCRIPTION

B<This program> will read the given input file as the input to the day 02
challenge of the Advent of Code 2025 and use it to calculate the solutions to
part 1 and part 2 of the challenge.

=cut
