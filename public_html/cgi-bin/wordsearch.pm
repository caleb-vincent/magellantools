package Wordsearch;

use strict;
use warnings;

use List::Util qw(shuffle);

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
    while ( $max_size > 1 && $used_spaces < 468 && $#word_array >= 0 )
    {
        # since it's shuffled, we can always take of the 1st and remove it form the array
        my $curr_word = shift( @word_array );
        # keep going until we get one small enough
        while( length( $curr_word ) > $max_size )
        {
            $curr_word = pop( @word_array ); 
        }
        $curr_word = uc $curr_word;
        # last successfully used direction, 0 for vertical, 1 for horizontal
        my $use_dirr = int( rand(2) );
        # result of trying to add a word
        my $result = 0;
        my $rand_num =  0;
        # if we used horizontal last
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
        else
        {
            $result = add_horz_word( $self, $curr_word, $rand_num );
            if ( $result == 0 )
            {
                $result = add_vert_word( $self, $curr_word, $rand_num );
            }
        }
        if ( $result == 0 )
        {
            $max_size = length( $curr_word ) - 1;
        }
        else
        {
            $used_spaces += length( $curr_word );
        }
        $tried_words++;
    }
    my @letters = ( 'A' .. 'Z' );
    for( my $i = 0; $i <625; $i++ )
    {
        if( ${ $self->{word_array} }[$i] == 625 )
        {
            ${ $self->{char_array} }[$i] = $letters[ int( rand( 26 ) ) ];
        }
    }
}

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
            for( my $offset = 0; $offset < length( $word ); $offset++ )
            {
                my $index = ( $i + $offset ) * 25 + $j;
                if( $index >= 625 )
                {
                    $no_room = 1;
                }
                elsif( ${$self->get_word_array() }[ $index ] != 625 || ($offset + $i) >= 25 )
                {
                    $no_room = 1;
                }
            }
            if( !$no_room )
            {
                push( @{ $self->get_length_array() }, 0 );
                for( my $offset = 0; $offset < length( $word ); $offset++ )
                {
                    # put the aproprite letter of the word in to the correct slot in the array
                    my $index = ( $i + $offset ) * 25 + $j;
                    ${ $self->{char_array} }[ $index ] = substr( $word, $offset, 1 );
                    ${ $self->{word_array} }[ $index ] = $#{ $self->{length_array} };
                    ${ $self->{length_array} }[ $#{ $self->{length_array} } ]++;
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
            for( my $offset = 0; $offset < length( $word ) ; $offset++ )
            {
                
                 my $index = ( $i ) * 25 + ( $j + $offset );
                if( $index >= 625 )
                {
                    $no_room = 1;
                    last;
                }
                if( ${ $self->{word_array} }[ $index ] != 625 || ($offset + $j) >= 25 )
                {
                    $no_room = 1;
                    last;
                }
            }
            if( $no_room == 0 )
            {
                push( @{ $self->get_length_array() }, 0 );
                for( my $offset = 0; $offset < length( $word ); $offset++ )
                {
                    # put the aproprite letter of the word in to the correct slot in the array
                    my $index = ( $i  * 25 ) + $j + $offset;
                    ${ $self->{char_array} }[ $index ] = substr( $word, $offset, 1 );
                    ${ $self->{word_array} }[ $index ] = $#{ $self->{length_array} };
                    ${ $self->{length_array} }[ $#{ $self->{length_array} } ]++;
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

sub get_char_array()
{
    my $self = shift;
    return $self->{char_array};
}
sub get_word_array()
{
    my $self = shift;
    return $self->{ word_array };
}
sub get_length_array()
{
    my $self = shift;
    return $self->{ length_array };
}

sub get_word_list()
{
    my $self = shift;
    return $self->{ word_list };
}

1;
