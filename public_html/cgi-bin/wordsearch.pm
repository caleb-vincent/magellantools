package Wordsearch;

use strict;
use warnings;

use List::Util qw(shuffle);

#for faster random number generation later. . .
#use IPC::Mmap::Share;

# the class initiallizer
sub new 
{
    # the name of the class  ( wordsearch )
    my $class = shift;
    
    # the array of characters for the word search
    my @char_array = ( "\0" ) x 625;
    # the array of word indexes for the word search
    my @word_array = ( 625 ) x 625;
    #the array containing the length of each word index
    my @length_array;
    # the array containing all of the words in the word search
    my @word_list;
    
    # the object itself
    my $obj ={ char_array=>[ @char_array ], word_array=>[ @word_array ], length_array=>[ @length_array ], word_list=>[ @word_list ] };
    bless $obj, $class;
    return $obj;
}

sub create_wordsearch
{
    # get ourself, as an object
    my $self = shift;
    # a reference to all of the words for this lecture
    my @word_array = @_;
    # for every element of the array
    foreach my $word ( @word_array )
    {
        # removew all non-character characters
        while( $word =~ s/(.*?)\W(.*)/$1$2/gc )
        {}
    }
    #suffle the contents of the array
    @word_array = shuffle( @word_array );
    # maximum size of a word to be used
    my $max_size = 25;
    my $used_spaces = 0;
    my $tried_words = 0;
    my @random_numbers = ( 0, 24, 12, 5, 17, 7, 2, 20 );
    # while the maximum word size is greater than 2, while the board is under 75% full, while there are still words left, and while we haven't failed in adding 50 woirds in a row
    while ( $max_size > 2 && $used_spaces < ( 625 * .75 ) && $#word_array >= 0 && $tried_words < 50 )
    {
        # since it's shuffled, we can always take of the 1st and remove it form the array
        my $curr_word = shift( @word_array );
        # keep going until we get one small enough, but bigger than two letters
        while( length( $curr_word ) > $max_size && length( $curr_word ) > 2 )
        {
            $curr_word = pop( @word_array ); 
        }
        $curr_word = uc $curr_word;
        # last successfully used direction, 0 for vertical, 1 for horizontal
        my $use_dirr = int( rand(2) );
        # result of trying to add a word
        my $result = 0;
        my $rand_num =  0;
        # if zero try verticle first
        if( $use_dirr == 0 )
        {
            # use a verticle this time
            $result = add_vert_word( $self, $curr_word, $rand_num );
            # if we wern't sucessful
            if ( $result == 0 )
            {   
                # try a hoizontal word
                $result = add_horz_word($self, $curr_word, $rand_num );
            }
        }
        # other wise
        else
        {
            # try horizontal first
            $result = add_horz_word( $self, $curr_word, $rand_num );
            if ( $result == 0 )
            {   
                #if that fail try verticle
                $result = add_vert_word( $self, $curr_word, $rand_num );
            }
        }
        # if niehter worked
        if ( $result == 0 )
        {
            # we can't use words this long any more
            $max_size = length( $curr_word ) - 1;
            # the cut off for failure, so if we keep trying words and none work, give up
            $tried_words++;
        }
        # if its in
        else
        {
            # increment the number of used spaces
            $used_spaces += length( $curr_word );
            # reset tried words
            $tried_words = 0;
        }
        
    }
    # make an array of letters
    my @letters = ( 'A' .. 'Z' );
    #for every letter in the word search
    for( my $i = 0; $i <625; $i++ )
    {
        # if it is unused
        if( ${ $self->{word_array} }[$i] == 625 )
        {
            #fill it with a random letter
            ${ $self->{char_array} }[$i] = $letters[ int( rand( 26 ) ) ];
        }
    }
}

# nfunction attempts to add a word to the woprd search vertically
sub add_vert_word
{
    my $self = shift;
    my $word = shift;
    my $rand = shift;
    # pick a random row to start in
    my $row_starter  = 12;#$rand;
    # increment up from that starter to the one before the starter 
    for ( my $i = $row_starter; $i != $row_starter - 1; $i+=2 )
    {
        # pick a random colomn
        my $col_starter = 12;#$rand;
        # increment up from that starter to the one before the starter 
        for( my $j = $col_starter; $j != $col_starter - 1; $j+=2 )
        {
            
            my $no_room = 0;
            #increment forward from the position to see if there is enough room
            for( my $offset = 0; $offset < length( $word ); $offset++ )
            {
                my $index = ( $i + $offset ) * 25 + $j;
                # make sure we are not past the end
                if( $index >= 625 )
                {
                    $no_room = 1;
                }
                # if it is otherwize ocupied or past the bottom
                elsif( ${$self->get_word_array() }[ $index ] != 625 || ($offset + $i) >= 25 )
                {
                    $no_room = 1;
                }
            }
            # if it fit
            if( !$no_room )
            {
                #push iits size onthe the length array
                push( @{ $self->get_length_array() }, length( $word ) );
                # change the letters in the words search apropriately
                for( my $offset = 0; $offset < length( $word ); $offset++ )
                {
                    
                    my $index = ( $i + $offset ) * 25 + $j;
                    # put the aproprite letter of the word in to the correct slot in the array
                    ${ $self->{char_array} }[ $index ] = substr( $word, $offset, 1 );
                    # put the correct word index in the correct place
                    ${ $self->{word_array} }[ $index ] = $#{ $self->{length_array} };
                }
                # add to wordlist
                ${ $self->{word_list} }[$#{ $self->{length_array} }] = $word;
                return 1;
            }
            # loops our row index back to the begining
            if( $j  == 26 )
            {
                $j = -1;
            }
        }
        # loops our row index back to the begining
        if( $i  == 26 )
        {
            $i = -1;
        }
    }
    return 0;
}

sub add_horz_word
{
    my $self = shift;
    my $word = shift;
    my $rand = shift;
    # pick a random row to start in
    my $row_starter = 12;#$rand;
    # increment up from that starter to the one before the starter 
    for ( my $i = $row_starter; $i != $row_starter - 1; $i+=2 )
    {
        # pick a random colomn
        my $col_starter =12;# $rand;
        # increment up from that starter to the one before the starter 
        for( my $j = $col_starter; $j != $col_starter - 1; $j+=2 )
        {
            my $no_room = 0;
            # for every letter in the word
            for( my $offset = 0; $offset < length( $word ) ; $offset++ )
            {
                
                my $index = ( $i ) * 25 + ( $j + $offset );
                # if we're off the array
                if( $index >= 625 )
                {
                    #fail
                    $no_room = 1;
                    last;
                }
                # if the space is ocupied or invalid
                if( ${ $self->{word_array} }[ $index ] != 625 || ($offset + $j) >= 25 )
                {
                    #fail
                    $no_room = 1;
                    last;
                }
            }
            # if it fit
            if( $no_room == 0 )
            {
                #push the size onto the length array
                push( @{ $self->get_length_array() }, length( $word ) );
                for( my $offset = 0; $offset < length( $word ); $offset++ )
                {
                    my $index = ( $i  * 25 ) + $j + $offset;
                    # put the aproprite letter of the word in to the correct slot in the array
                    ${ $self->{char_array} }[ $index ] = substr( $word, $offset, 1 );
                    # put the correct word index in the correct place
                    ${ $self->{word_array} }[ $index ] = $#{ $self->{length_array} };
                }
                ${ $self->{word_list} }[$#{ $self->{length_array} }] = $word;
                return 1;
            }
            # loops our row index back to the begining
            if( $j  == 26 )
            {
                $j = -1;
            }
        }
        # loops our row index back to the begining
        if( $i  == 26 )
        {
            $i = -1;
        }
    }
    return 0;
}

# returns the char_array member
sub get_char_array()
{
    my $self = shift;
    return $self->{char_array};
}

# returns the word_array member
sub get_word_array()
{
    my $self = shift;
    return $self->{ word_array };
}

#returns the length array member
sub get_length_array()
{
    my $self = shift;
    return $self->{ length_array };
}

# returns the word list member
sub get_word_list()
{
    my $self = shift;
    return $self->{ word_list };
}

1;
