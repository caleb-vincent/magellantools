<html>
<head>
    <link REL = "stylesheet" TYPE = "text/css" href = "default.css" />
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
        var tblBody;
        // for the index of the the word being selected, cannot under any circumstances be 625 words. ever.
        var selected_word = 625;
        // will contain the cells that have been selected
        var selected_cells = [];

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
            cell.setAttribute("bgcolor", "33FFFF");
            cell.removeAttribute("onmouseover");
            cell.removeAttribute("onmouseout");
            if ( selected_word == 625 )
            {
                selected_word = cell.getAttribute( "NAME" );
            }
            else
            {
            }
        }

        
    </script>  
</body>
</html>
