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

        var numrows = <TMPL_VAR NAME = "size">;
        var numcols = <TMPL_VAR NAME = "size">;
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
        var selected_word = numrows * numcols;
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
        
        // Callback for cell mouse click
        function MClick(cell, tblBody)
        {
            //if it doesn't have "onmouseover" attribute, it has already been selected before
            if( cell.getAttribute( "ID" ) == "selected" )
            {
				var index = selected_cells.indexOf( cell );
				if (index != -1 )
				{
					selected_cells.splice( index, 1 );
				}
                cell.setAttribute("bgcolor", "#EEEEFF");
                cell.setAttribute("onmouseover", "this.bgColor='#DDDDFF'");
                cell.setAttribute("onmouseout", "this.bgColor='#EEEEFF'");
				cell.setAttribute( "ID", "" );
            }
            // if its part of the current word
            else if ( cell.getAttribute( "ID" ) != "done" )
            {
				selected_word = cell.getAttribute( "name" );
                // set its attributes
                cell.setAttribute("bgcolor", "33FFFF");
                cell.removeAttribute("onmouseover");
                cell.removeAttribute("onmouseout");
				cell.setAttribute( "ID", "selected" );
                // add it
                selected_cells.push( cell );
                // if it was the last of its word index
            }
			checkWin();
			
        }
		
		function checkWin ()
		{
			if( selected_word < numrows * numcols )
			{
				var isOneWord = true;
				for( var q = 1; q < selected_cells.length; q++ )
				{
					if( selected_cells[q - 1].getAttribute( "NAME" ) != selected_cells[q].getAttribute( "NAME" ) )
					{
						isOneWord = false;
					}
				}
                if( isOneWord == true && selected_cells.length == length_array[selected_word] )
                {
                    // color them all done
                    for( var i = 0; i < selected_cells.length; i++ )
                    {
                        var color = 15597568 + ( selected_word * 10 );
                        selected_cells[i].setAttribute("bgcolor", color );
                        selected_cells[i].removeAttribute("onmouseover");
                        selected_cells[i].removeAttribute("onmouseout");
						selected_cells[i].setAttribute( "ID", "done" );
                    }
                    // set the coresponding word list word to strike out
                    document.getElementById( selected_word ).setAttribute( "CLASS", "found-word" );
                    // clear the selected array
                    selected_cells.splice( 0, selected_cells.length );
                    // reset selected_word
                    selected_word = numrows * numcols;
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
