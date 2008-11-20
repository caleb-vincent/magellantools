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
    
    my $obj ={ char_array=>[ @char_array ], word_array=>[ @word_array ], length_array=>[ @length_array ] };
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
    # last successfully used direction, 0 for vertical, 1 for horizontal
    my $last_used_dir = int( rand() );
    # maximum size of a word to be used
    my $max_size = 25;
    my $used_spaces = 0;
    while ( $max_size > 1 && $used_spaces < 625 && $#word_array >= 0 )
    {
        # since it's shuffled, we can always take of the 1st and remove it form the array
        my $curr_word = uc shift( @word_array );
        # keep going until we get one small enough
        while( length( $curr_word ) > $max_size )
        {
            $curr_word = uc shift( @word_array ); 
        }
        # result of trying to add a word
        my $result = 0;
        # if we used horizontal last
        if( !$last_used_dir )
        {
            # use a verticle this time
            $result = add_vert_word( $self, $curr_word );
            # if we wern't sucessful
            if ( $result == 0 )
            {   
                # try a hoizontal word
                $result = add_horz_word( $self, $curr_word );
                
                $last_used_dir = $result ? 1 : 0;
            }
            else 
            {
                $last_used_dir = 1;
            }
        }
        else
        {
            $result = add_horz_word( $self, $curr_word );
            if ( $result == 0 )
            {
                $result = add_vert_word( $self, $curr_word );
                $last_used_dir = $result ? 0 : 1;
            }
            else 
            {
                $last_used_dir = 0;
            }
        }
        if ( $result == 0 )
        {
            $max_size = length( $curr_word ) - 1;
        }
    }
}

sub add_vert_word
{
    my $self = shift;
    my $word = shift;
    for ( my $i = 0; $i < 25; $i++ )
    {
        for( my $j = 0; $j < 25; $j++ )
        {
            my $no_room = 0;
            for( my $offset = 0; $offset < length( $word ); $offset++ )
            {
                if( ${$self->get_char_array() }[ ( $i + $offset ) * 25 + $j ] ne "\0" )
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
                    ${$self->get_char_array() }[ ( $i + $offset ) * 25 + $j ] = substr( $word, $offset, 1 );
                    ${$self->get_word_array() }[ ( $i + $offset ) * 25 + $j ] = $#{ $self->get_length_array() };
                    ${ $self->get_length_array() }[ $#{ $self->get_length_array() } ]++;
                }
                return 1;
            }
        }
    }
    return 0;
}

sub add_horz_word
{
    my $self = shift;
    my $word = shift;
    for ( my $i = 0; $i < 25; $i++ )
    {
        for( my $j = 0; $j < 25; $j++ )
        {
            my $no_room = 0;
            for( my $offset = 0; $offset < length( $word ); $offset++ )
            {
                if( ${$self->get_char_array() }[ ( $i ) * 25 + $j + $offset ] ne "\0" )
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
                    ${$self->get_char_array() }[ ( $i ) * 25 + $j + $offset ] = substr( $word, $offset, 1 );
                    ${$self->get_word_array() }[ ( $i ) * 25 + $j + $offset ] = $#{ $self->get_length_array() };
                    ${ $self->get_length_array() }[ $#{ $self->get_length_array() } ]++;
                }
                return 1;
            }
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

1;