// This is the javascript file that contains the playable bingo game. 

var numrows = 5
var numcols = 5
var boxheight = 50
var boxwidth = 50
var bingo = "BINGO"
var tblBody

// Main function: creates and initializes grid
function start() 
{
    var body = document.getElementsByTagName("body")[0];

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
            cell.setAttribute("name", "r"+i+"c"+j);
            if(i != 0)
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
function GetCellText(cell)
{
    return cell.getAttribute("name");
}

// Callback for cell mouse click
function MClick(cell, tblBody)
{
    cell.setAttribute("bgcolor", "red");
    cell.removeAttribute("onmouseover");
    cell.removeAttribute("onmouseout");
    
    // After each click, check to see if the player has won
    CheckForWinCondition(tblBody);
}

// Checks clicked boxes to see if win condition is fulfilled. Default is full board.
function CheckForWinCondition(tblBody)
{
    var win = true;
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
    if(win)
    {
        alert("You have won Full Bingo!");
    }
    win = true;
}