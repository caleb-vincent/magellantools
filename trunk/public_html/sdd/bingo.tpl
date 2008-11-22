<html>
<head>
    <link REL = "stylesheet" TYPE = "text/css" href = "<TMPL_VAR NAME = "style">" />
    <title>Word Search: <TMPL_VAR NAME = "teacher">: <TMPL_VAR NAME = "lecture"></title>
</head>
<body onload = start()>
    <FORM>
        <INPUT TYPE="button" onClick="window.print()">
    </FORM>
    <script type="text/javascript">
        // This is the javascript file that contains the playable bingo game. 

        var numrows = 5
        var numcols = 5
        var freeSpace = new Array(3, 3);
        var boxheight = 50
        var boxwidth = 50
        var bingo = "BINGO"
        var wincondition = "row"
        var tblBody
        // This should be an array of at least numrows * numcols - 1 words (one is free space)
        var words = [ "<TMPL_VAR NAME = "word_array">" ];

        // Main function: creates and initializes grid
        function start() 
        {
            var body = document.getElementsByTagName("body")[0];
            words = shuffleArray(words);
            
            // creates an HTML <table> element
            var table = document.createElement("table");
            tblBody = document.createElement("tbody");
            table.setAttribute("border", "2");
            table.setAttribute("width", boxwidth*numcols)

            // one extra row for the "BINGO" header
            for (var i=0;i<numrows+1;i++) 
            {
                // creates a table row
                var row = document.createElement("tr");
                row.setAttribute("width", boxwidth);
                row.setAttribute("align", "center");

                for (var j=0;j<numcols;j++) 
                {
                    var cell = document.createElement("td");
                    cell.setAttribute("height", boxheight);
                    if(i > freeSpace[0] || (i == freeSpace[0] && j > freeSpace[1]-1))
                    {
                        cell.setAttribute("name", words[(i - 1)*numrows + j - 1]);
                    }
                    else if(i < freeSpace[0] || (i == freeSpace[0] && j < freeSpace[1]-1))
                    {
                        cell.setAttribute("name", words[(i - 1)*numrows + j]);
                    }
                    else
                    {
                        cell.setAttribute("name", "FREE");
                        cell.setAttribute("bgcolor", "red");                
                    }
                    if(i != 0 && !(i == freeSpace[0] && j == freeSpace[1]-1))
                    {
                        cell.setAttribute("onmouseover", "this.bgColor='#EEEEEE'");
                        cell.setAttribute("onmouseout", "this.bgColor='#FFFFFF'");
                        cell.setAttribute("onclick", "MClick(this, tblBody);");
                    }
                    
                    var cellText;
                    if(i==0)
                        // Bingo header
                        cellText = document.createTextNode(bingo[j])
                    else
                        cellText = document.createTextNode(GetCellText(cell));
                    
                    cell.appendChild(cellText)
                    row.appendChild(cell);
                }

                // add the row to the end of the table body
                tblBody.appendChild(row);
            }
            table.appendChild(tblBody);
            body.appendChild(table);
        }

        // Get the word inside a given cell
        function GetCellText(cell)
        {
            return cell.getAttribute("name");
        }

        // Randomize list, based on Fisher-Yates shuffling algorithm
        function shuffleArray(wordlist)
        {
            for(var j, x, i = wordlist.length; i; j = parseInt(Math.random() * i), x = wordlist[--i], wordlist[i] = wordlist[j], wordlist[j] = x);
            return wordlist;
        }

        // Callback for cell mouse click
        function MClick(cell, tblBody)
        {
            if(cell.getAttribute("bgcolor", "white"))
            {
                cell.setAttribute("bgcolor", "red");
                cell.removeAttribute("onmouseover");
                cell.removeAttribute("onmouseout");
            }
            else if(cell.getAttribute("bgcolor", "red"))
            {
                cell.setAttribute("bgcolor", "white");
                cell.setAttribute("onmouseover", "this.bgColor='#EEEEEE'");
                cell.setAttribute("onmouseout", "this.bgColor='#FFFFFF'");
            }
            
            // After each click, check to see if the player has won
            CheckForWinCondition(tblBody, wincondition);
        }

        // Checks clicked boxes to see if win condition is fulfilled. Default is full board.
        function CheckForWinCondition(tblBody, condition)
        {
            var win = true;
            if(condition == "fullcard")
            {
                for(var i=1;i<=numrows;i++)
                {
                    for(var j=0;j<numcols;j++)
                    {
                        row = tblBody.childNodes.item(i);
                        cell = row.childNodes.item(j);
                        if(cell.getAttribute("bgcolor") != "red")
                        {
                           win = false; 
                        }
                    }
                }
            }
            else if(condition == "outline")
            {
                // Check first and final rows
                for(var i=0;i<=numrows-1;i++)
                {
                    row = tblBody.childNodes.item(1);
                    row2 = tblBody.childNodes.item(numcols);
                    cell = row.childNodes.item(i);
                    cell2 = row2.childNodes.item(i);
                    if(cell.getAttribute("bgcolor") != "red" || cell2.getAttribute("bgcolor") != "red")
                    {
                       win = false; 
                    }    
                }
                
                // Check first and final columns
                for(var i=1;i<=numcols;i++)
                {
                    row = tblBody.childNodes.item(i);
                    cell = row.childNodes.item(0);
                    cell2 = row.childNodes.item(numrows-1);
                    if(cell.getAttribute("bgcolor") != "red" || cell2.getAttribute("bgcolor") != "red")
                    {
                       win = false; 
                    }     
                } 
            }
            else if(condition == "fourcorner")
            {
                // Check each corner (explicitly)
                if(tblBody.childNodes.item(1).childNodes.item(0).getAttribute("bgcolor") != "red" 
                || tblBody.childNodes.item(1).childNodes.item(numrows-1).getAttribute("bgcolor") != "red"
                || tblBody.childNodes.item(numcols).childNodes.item(0).getAttribute("bgcolor") != "red"
                || tblBody.childNodes.item(numcols).childNodes.item(numrows-1).getAttribute("bgcolor") != "red")
                {
                   win = false; 
                }      
            }
            else if(condition == "plusOrX")
            {
                //todo
            }
            else if(condition == "row")
            {
                // check for horizontal bingo
                for(var i=1;i<numrows+1;i++)
                {
                    win = true;
                    for(var j=0;j<numcols;j++)
                    {
                        row = tblBody.childNodes.item(i);
                        cell = row.childNodes.item(j);
                        if(cell.getAttribute("bgcolor") != "red")
                        {
                           win = false; 
                        }
                    }
                    if(win == true)
                    {
                        tblBody.childNodes.item(1).childNodes.item(1).setAttribute("bgcolor", "blue");
                        break;
                    }
                }
                
                // check for vertical bingo
                if(win == false)
                {
                    for(var i=0;i<numcols;i++)
                    {
                        win = true;
                        for(var j=1;j<numrows+1;j++)
                        {
                            row = tblBody.childNodes.item(j);
                            cell = row.childNodes.item(i);
                            if(cell.getAttribute("bgcolor") != "red")
                            {
                               win = false; 
                            }
                        }
                        if(win == true)
                        {
                            break;
                        }
                    }
                }
                
                // check for diagonal bingo
                if(win == false)
                {
                    win = true;
                    for(var i=1;i<numrows+1;i++)
                    {
                        row = tblBody.childNodes.item(i);
                        cell = row.childNodes.item(i-1);
                        if(cell.getAttribute("bgcolor") != "red")
                        {
                           win = false; 
                        }
                    }
                    if(win == false)
                    {
                        win = true;
                        for(var i=1;i<numrows+1;i++)
                        {
                            row = tblBody.childNodes.item(i);
                            cell = row.childNodes.item(numcols-i);
                            if(cell.getAttribute("bgcolor") != "red")
                            {
                               win = false; 
                            }
                        }
                    }
                }
            }
            else
            {
                //ERROR: UNKNOWN WIN CONDITION
                win = false;
            }
            if(win)
            {
                alert("CONGRATS, You have won Bingo!");
            }
            win = true;
        }
    </script>  
</body>
</html>
