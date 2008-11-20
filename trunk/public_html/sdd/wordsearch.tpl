<html>
<head>
    <link REL = "stylesheet" TYPE = "text/css" href = "<TMPL_VAR NAME = "style">" />
    <title>Word Search: <TMPL_VAR NAME = "teacher">: <TMPL_VAR NAME = "lecture"></title>
</head>
<body onload = start()>
    <script type="text/javascript">
        // This is the javascript file that contains the playable bingo game. 

        var numrows = 25;
        var numcols = 25;
        var boxheight = 25;
        var boxwidth = 25;
        // initializes an array called char_array that contains each element a char
        var char_array = [ "<TMPL_VAR NAME = "char_array">" ];
        // initializes an array called word_array that contains each element an index for a word 
        var word_array = [ "<TMPL_VAR NAME = "word_array">" ];
        // initializes an array holding the length of each word index
        var length_array = [ "<TMPL_VAR NAME = "length_array">" ];
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
                    cell.setAttribute( "NAME", word_array[ i * numrows + j ] );
                    cell.setAttribute("onmouseover", "this.bgColor='#DDDDFF'");
                    cell.setAttribute("onmouseout", "this.bgColor='#EEEEFF'");
                    cell.setAttribute("onclick", "MClick(this, tblBody);");
                    
                    var cellText;
                    
                    cellText = document.createTextNode( char_array[ i * numrows + j ] );
                    
                    cell.appendChild(cellText)
                    row.appendChild(cell);
                }

                // add the row to the end of the table body
                tblBody.appendChild(row);
            }
            table.appendChild(tblBody);
            body.appendChild(table);
        }
        
        // Callback for cell mouse click
        function MClick(cell, tblBody)
        {
            if ( selected_word == 625 )
            {
                selected_word = cell.getAttribute( "NAME" );
            }
            if ( selected_word == 625 )
            {
            }
            else if( selected_cells.indexOf( cell ) != -1 )
            {
            }
            else if( selected_word == cell.getAttribute( "NAME" ) && selected_cells.length < length_array[ selected_word ] - 1 )
            {
                cell.setAttribute("bgcolor", "33FFFF");
                cell.removeAttribute("onmouseover");
                cell.removeAttribute("onmouseout");
                selected_cells.push( cell );
            }
            else if( selected_word == cell.getAttribute( "NAME" ) &&  selected_cells.length == length_array[selected_word] - 1)
            {
                cell.setAttribute("bgcolor", "33FFFF");
                cell.removeAttribute("onmouseover");
                cell.removeAttribute("onmouseout");
                selected_cells.push( cell );
                for( var i = 0; i < selected_cells.length; i++ )
                {
                    selected_cells[i].setAttribute("bgcolor", "33DDDD");
                    selected_cells[i].removeAttribute("onmouseout");
                    selected_cells[i].removeAttribute("onmouseover");
                }
                selected_cells.splice( 0, selected_cells.length );
                length_array[ selected_word ] = 0;
                selected_word = 625;
                completed_words++;
                if( completed_words == length_array.length )
                {
                    alert("You have won the Word Search!");
                }
            }
            else
            {
                for( var i = 0; i < selected_cells.length; i++ )
                {
                    selected_cells[i].setAttribute("bgcolor", "#EEEEFF");
                    selected_cells[i].setAttribute("onmouseover", "this.bgColor='#DDDDFF'");
                    selected_cells[i].setAttribute("onmouseout", "this.bgColor='#EEEEFF'");
                }
                selected_cells.splice( 0, selected_cells.length );
                selected_word = 625;
            }
        }

    </script>  
</body>
</html>
