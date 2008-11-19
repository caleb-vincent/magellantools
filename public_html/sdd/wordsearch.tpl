<html>
<head>
    <link rel="stylesheet" type="text/css" href="default.css" />
    <title>Word Search: <TMPL_VAR NAME = "teacher">: <TMPL_VAR NAME = "lecture"></title>
</head>
<body onload = start()>
    <script type="text/javascript">
        // This is the javascript file that contains the playable bingo game. 

        var numrows = 25
        var numcols = 25
        var boxheight = 25
        var boxwidth = 25
        var array = "<TMPL_VAR NAME = "array">"
        var tblBody

        // Main function: creates and initializes grid
        function start() 
        {
            var body = document.getElementsByTagName("body")[0];

            // creates an HTML <table> element
            var table = document.createElement("table");
            tblBody = document.createElement("tbody");
            table.setAttribute("border", "1");
            table.setAttribute("width", boxwidth*numcols)

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
                    cell.setAttribute( "height", boxheight );
                    cell.setAttribute( "name", array[ i * numrows + j ] );
                    if(i != 0)
                    {
                        cell.setAttribute("onmouseover", "this.bgColor='#'");
                        cell.setAttribute("onmouseout", "this.bgColor='#FFFFFF'");
                        cell.setAttribute("onclick", "MClick(this, tblBody);");
                    }
                    
                    var cellText;
                    
                    cellText = document.createTextNode("A");//cell.getAttribute("name") );
                    
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
            cell.setAttribute("bgcolor", "orange");
            cell.removeAttribute("onmouseover");
            cell.removeAttribute("onmouseout");
            
        }

        
    </script>  
</body>
</html>
