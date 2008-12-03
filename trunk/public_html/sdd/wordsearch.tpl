<html>
<head>
    <link REL = "stylesheet" TYPE = "text/css" href = "<TMPL_VAR NAME = "style">" />
    <title>Word Search: <TMPL_VAR NAME = "teacher">: <TMPL_VAR NAME = "lecture"></title>
</head>
<!-- If we have a print template variable, the run the print me function-->
<TMPL_IF name = "print">
    <body onload = "printMe()">
<!-- If we don't just start he game -->
<TMPL_ELSE>
    <body onload = start()>
</TMPL_IF>
    <DIV CLASS = "word-list" ID= "word-list" >
        
    </DIV>
    <DIV CLASS = "word-search" ID = "word-search">
    
    </DIV>
    <DIV CLASS = "word-extras">
        <!-- if we have a print, don't display the print button -->
        <TMPL_IF name = "print">
        <!-- otherwise display it, in all its glory -->
        <TMPL_ELSE>
            <FORM ACTION = "../cgi-bin/template.cgi" METHOD = "get" ENCTYPE = "multipart/form-data">
                    <!-- the button, goes to the cached page -->
                <INPUT TYPE = "button" VALUE="Print" onClick="window.open('<TMPL_VAR NAME = "file">', 'Word Search: <TMPL_VAR NAME = "teacher">: <TMPL_VAR NAME = "lecture">', 'WIDTH=800, HEIGHT=600,COPYHISTORY=no,MENUBAR=no,STATUS=no,DIRECTORIES=no,LOCATION=no,TOOLBAR=no')" />
            </FORM>        
        </TMPL_IF>
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

        // Start the main functino then opens print dialog
        function printMe()
        {
            start();
            window.print();
        }
        // Main function: creates and initializes grid
        function start() 
        {
            var body = document.getElementById( "word-search" );

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
                
                // creates a cell for each colomn
                for ( var j = 0; j < numcols; j++ ) 
                {
                    // the new cell
                    var cell = document.createElement( "td" );
                    cell.setAttribute( "HEIGHT", boxheight );
                    cell.setAttribute( "NAME", word_array[ i * ( numrows ) + j ] );
                    cell.setAttribute("onmouseover", "this.bgColor='#DDDDFF'");
                    cell.setAttribute("onmouseout", "this.bgColor='#EEEEFF'");
                    cell.setAttribute("onclick", "MClick(this, tblBody);");
                    
                    // the test for the cell
                    var cellText;
                    cellText = document.createTextNode( char_array[ i * ( numrows ) + j ] );
                    
                    // throw it all out there
                    cell.appendChild(cellText)
                    row.appendChild(cell);
                }

                // add the row to the end of the table body
                tblBody.appendChild(row);
            }
            //stick it on
            table.appendChild(tblBody);
            body.appendChild(table);
            
            // grab the div for th word list
            var theDiv = document.getElementById( "word-list" );
            // for every word in the word list
            for( var k = 0; k < word_list.length; k++ )
            {
                // create a div for the word to go into
                var newDiv = document.createElement('div');
                newDiv.setAttribute( "ID", k );
                newDiv.setAttribute( "CLASS", "new-word" );
                //create the text for the div
                var listWord = document.createTextNode( word_list[k] );
                // shove it in there
                newDiv.appendChild( listWord );
                theDiv.appendChild( newDiv );
            }
            
            
        }
        
        // goes through the selected cells, and resets there attributes 
        function ClearSelected()
        {
            // for every selected cell
            for( var i = 0; i < selected_cells.length; i++ )
            {
                // the reseting
                selected_cells[i].setAttribute("bgcolor", "#EEEEFF");
                selected_cells[i].setAttribute("onmouseover", "this.bgColor='#DDDDFF'");
                selected_cells[i].setAttribute("onmouseout", "this.bgColor='#EEEEFF'");
            }
            // trash everything in the array
            selected_cells.splice( 0, selected_cells.length );
        }
        
        // Callback for cell mouse click
        function MClick(cell, tblBody)
        {
            //if it doesn't have "onmouseover" attribute, it has already been selected before
            if( !cell.getAttribute( "onmouseover" ) )
            {
                // so it must be a new word, clear selected array
                ClearSelected();
            }
            // start new word selection
            else if( cell.getAttribute( "NAME" ) == 625 || cell.getAttribute( "NAME") != selected_word )
            {
                // clear
                ClearSelected();
                // set the selected_word
                selected_word = cell.getAttribute( "NAME" );
                // set the cells attributes
                cell.setAttribute("bgcolor", "33FFFF");
                cell.removeAttribute("onmouseover");
                cell.removeAttribute("onmouseout");
                //add it to the selected array
                selected_cells.push( cell );
            }
            // if its part of the current word
            else if ( cell.getAttribute( "NAME") == selected_word )
            {
                // set its attributes
                cell.setAttribute("bgcolor", "33FFFF");
                cell.removeAttribute("onmouseover");
                cell.removeAttribute("onmouseout");
                // add it
                selected_cells.push( cell );
                // if it was the last of its word index
                if( selected_cells.length == length_array[ selected_word ] )
                {
                    // color them all done
                    for( var i = 0; i < selected_cells.length; i++ )
                    {
                        var color = 15597568 + ( selected_word * 10 );
                        selected_cells[i].setAttribute("bgcolor", color );
                        selected_cells[i].removeAttribute("onmouseover");
                        selected_cells[i].removeAttribute("onmouseout");
                    }
                    // set the coresponding word list word to strike out
                    document.getElementById( selected_word ).setAttribute( "CLASS", "found-word" );
                    // clear the selected array
                    selected_cells.splice( 0, selected_cells.length );
                    // reset selected_word
                    selected_word = 625;
					completed_words++;
					if( completed_words >= word_list.length )
					{
						alert( " You've Completed the Wordsearch!" );
					}
                }
                
            }
            
        }

    </script>
    
</body>
</html>
