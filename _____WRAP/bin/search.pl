#!/usr/bin/env perl
# shellcheck shell=perl

use strict;
use warnings;
use File::Find;

# 🆔 UUID-based function name (guaranteed unique)
sub MAIN_EA8FCBCF_8F1F_4C56_AE9C_D91C1FBD13E1 {

    # Parse arguments
    my @args = @ARGV;
    unless ( @args >= 2 ) {
        print_help();
        exit 1;
    }

    my $target = shift @args;
    my $pattern = shift @args;
    
    # Check for options
    my $exec_command = undef;
    my $list_files_only = 0;
    my $say_files = 0;
    
    while ( @args ) {
        my $arg = shift @args;
        if ( $arg eq '-exec' ) {
            $exec_command = join(' ', @args);
            unless ( $exec_command ) {
                die "Error: -exec requires a command.\n";
            }
            last;  # -exec consumes all remaining args
        } elsif ( $arg eq '-l' ) {
            $list_files_only = 1;
        } elsif ( $arg eq '-s' ) {
            $say_files = 1;
        } else {
            die "Error: Unknown argument: $arg\n";
        }
    }

    my $regex = qr/$pattern/i;
    my %matched_files;  # Track files that have matches

    my $process_file = sub {
        return unless -f $_ && -r _;    # Only readable files
        open my $fh, '<', $_ or return;
        my $linenum = 0;
        my $file_has_match = 0;
        while ( my $line = <$fh> ) {
            $linenum++;
            if ( $line =~ $regex ) {
                if ( $list_files_only ) {
                    # Just mark that we found a match and break
                    $file_has_match = 1;
                    last;  # No need to continue reading this file
                } elsif ( $say_files ) {
                    # Just mark that we found a match and break
                    $file_has_match = 1;
                    last;  # No need to continue reading this file
                } elsif ( !$exec_command ) {
                    print "$File::Find::name:$linenum: $line";
                }
                $file_has_match = 1;
            }
        }
        close $fh;
        
        # Handle different output modes
        if ( $file_has_match ) {
            if ( $list_files_only ) {
                print "$File::Find::name\n";
            } elsif ( $say_files ) {
                $matched_files{$File::Find::name} = 1;
            } elsif ( $exec_command ) {
                $matched_files{$File::Find::name} = 1;
            }
        }
    };

    if ( -d $target ) {
        find( $process_file, $target );
    }
    elsif ( -f $target ) {
        local $File::Find::name = $target;
        $process_file->();
    }
    else {
        die "Error: '$target' is not a valid file or directory.\n";
    }
    
    # Execute command on matched files if -exec was specified
    if ( $exec_command && %matched_files ) {
        for my $file ( sort keys %matched_files ) {
            my $cmd = $exec_command;
            $cmd =~ s/\{\}/$file/g;  # Replace {} with filename
            system('/bin/sh', '-c', $cmd);  # Execute through shell for full shell functionality
        }
    }
    
    # Say filenames if -s was specified
    if ( $say_files && %matched_files ) {
        for my $file ( sort keys %matched_files ) {
            my $basename = $file;
            $basename =~ s/.*\///;  # Remove path, keep only filename
            system('say', $basename);
        }
    }
}

# 📄 Help message
sub print_help {
    print <<"USAGE";
Usage: search [file or directory] "search phrase" [options]

Searches for a regex pattern inside a file or recursively in a directory.

Options:
  -l          List only the names of files containing matches (like grep -l)
  -s          Say (speak) the basename of files containing matches using macOS 'say'
  -exec cmd   Execute command on each file that contains matches
              Use {} as a placeholder for the filename in the command

Output modes:
  Default: Shows matching lines with filename and line number
  -l:      Shows only filenames that contain matches
  -s:      Speaks the basename of files that contain matches
  -exec:   Executes command on matching files (no other output)

Examples:
  search /path/to/dir "TODO"
  search /path/to/dir "function.*name" -l
  search /path/to/dir "error" -s
  search /path/to/dir "error" -exec vim {}
  search . "import.*React" -l
  search /path/to/dir "config" -exec echo "Found in: \$(basename {})"
  search /path/to/dir "function" -exec say "\$(basename {})"
USAGE
}

# 🏁 Entrypoint
MAIN_EA8FCBCF_8F1F_4C56_AE9C_D91C1FBD13E1();
