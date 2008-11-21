﻿<html>
<head>
    <link REL = "stylesheet" TYPE = "text/css" href = "<TMPL_VAR NAME = "style">" />
    <title>Word Search: <TMPL_VAR NAME = "teacher">: <TMPL_VAR NAME = "lecture"></title>
</head>
<body onload = start()>
    <DIV CLASS = "word-list" ID= "word-list" >
    </DIV>
    <script type="text/javascript">
        // This is the javascript file that contains the playable bingo game. 

        var numrows = 25;
        var numcols = 25;
        var boxheight = 25;
        var boxwidth = 25;
        // initializes an array called char_array that contains each element a char
        var char_array = [ "<TMPL_VAR NAME = "char_array">" ];
        // initializes an array called word_array that contains each element an index for a word 
        var word_array = [ <TMPL_VAR NAME = "word_array"> ];
        // initializes an array holding the length of each word index
        var length_array = [ "<TMPL_VAR NAME = "length_array">" ];
        // initializes an array holding all of the words in the wordsearch
        var word_list = [ "<TMPL_VAR NAME = "word_list">" ];
        var tblBody;
        // for the index of the the word being selected, cannot under any circumstances be 625 words. ever.
        var selected_word = 625;
        // will contain the cells that have been selected
        var selected_cells = [];
        var completed_words = 0;

        // Main function: creates and initializes grid
        function start() 
        {
            var body = document.getElementsByTagName("body")[0];

            // creates an HTML <table> element
            var table = document.createElement("table");
            tblBody = document.createElement("tbody");
            table.setAttribute("border", "1");
            table.setAttribute("width", boxwidth * numcols );
            table.setAttribute( "bgcolor", "#EEEEFF" );
            
            // one extra row for the "BINGO" header
            for ( var i = 0; i < numrows; i++ ) 
            {
                // creates a table row
                var row = document.createElement("tr");
                row.setAttribute("width", boxwidth);
                row.setAttribute("align", "center");

                for ( var j = 0; j < numcols; j++ ) 
                {
                    var cell = document.createElement( "td" );
                    cell.setAttribute( "HEIGHT", boxheight );
                    cell.setAttribute( "NAME", word_array[ i * ( numrows ) + j ] );
                    cell.setAttribute("onmouseover", "this.bgColor='#DDDDFF'");
                    cell.setAttribute("onmouseout", "this.bgColor='#EEEEFF'");
                    cell.setAttribute("onclick", "MClick(this, tblBody);");
                    
                    var cellText;
                    
                    cellText = document.createTextNode( char_array[ i * ( numrows ) + j ] );
                    
                    cell.appendChild(cellText)
                    row.appendChild(cell);
                }

                // add the row to the end of the table body
                tblBody.appendChild(row);
            }
            table.appendChild(tblBody);
            body.appendChild(table);
            
            var theDiv = document.getElementById( "word-list" );
            for( var k = 0; k < word_list.length; k++ )
            {
                var newDiv = document.createElement('div');
                newDiv.setAttribute( "ID", k );
                newDiv.setAttribute( "CLASS", "new-word" );
                var listWord = document.createTextNode( word_list[k] );
                newDiv.appendChild( listWord );
                theDiv.appendChild( newDiv );
            }
            
            
        }
        
        function ClearSelected()
        {
            for( var i = 0; i < selected_cells.length; i++ )
            {
                selected_cells[i].setAttribute("bgcolor", "#EEEEFF");
                selected_cells[i].setAttribute("onmouseover", "this.bgColor='#DDDDFF'");
                selected_cells[i].setAttribute("onmouseout", "this.bgColor='#EEEEFF'");
            }
            selected_cells.splice( 0, selected_cells.length );
        }
        
        // Callback for cell mouse click
        function MClick(cell, tblBody)
        {
            if( !cell.getAttribute( "onmouseover" ) )
            {
                ClearSelected();
            }
            // start new word selection
            else if( cell.getAttribute( "NAME" ) == 625 || cell.getAttribute( "NAME") != selected_word )
            {
                ClearSelected();
                selected_word = cell.getAttribute( "NAME" );
                cell.setAttribute("bgcolor", "#999999");
                cell.removeAttribute("onmouseover");
                cell.removeAttribute("onmouseout");
                selected_cells.push( cell );
            }
            // if its part of the current word
            else if ( cell.getAttribute( "NAME") == selected_word )
            {
                cell.setAttribute("bgcolor", "#999999");
                cell.removeAttribute("onmouseover");
                cell.removeAttribute("onmouseout");
                selected_cells.push( cell );
                // if it was the last of its word index
                if( selected_cells.length == length_array[ selected_word ] )
                {
                    for( var i = 0; i < selected_cells.length; i++ )
                    {
                        selected_cells[i].setAttribute("bgcolor", "#555555");
                        selected_cells[i].removeAttribute("onmouseover");
                        selected_cells[i].removeAttribute("onmouseout");
                    }
                    document.getElementById( selected_word ).setAttribute( "CLASS", "found-word" );
                    selected_cells.splice( 0, selected_cells.length );
                    selected_word = 625;
                }
                
            }
            
        }

    </script>
    
</body>
</html>
