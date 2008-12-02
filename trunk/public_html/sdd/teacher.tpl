<HTML>
    <HEAD>
        <TITLE><TMPL_VAR NAME = "title"></TITLE>
        <LINK REL = "stylesheet" TYPE = "text/css" HREF = "<TMPL_VAR NAME = "style">" />
        <SCRIPT TYPE="text/javascript">
            function setBlock(it, it2)
            {
                var shown = document.getElementById( it );
                shown.type = "text";
                shown = document.getElementById( it2 );
                shown.style.display = "block";
            }
            function setHide(it)
            {
                var shown = document.getElementById( it );
                shown.type = "hidden";
                shown = document.getElementById( it2 );
                shown.style.display = "none";
            }
        </SCRIPT>
    </HEAD>
    <BODY>
        <DIV CLASS = "teacher-box">
            <H3>Teacher: <TMPL_VAR NAME = "user"></H3>
            <FORM ACTION = "<TMPL_VAR NAME = "action">" METHOD = "post" ENCTYPE = "multipart/form-data" NAME = "teacher-form">
                <STRONG>-- ALL --</STRONG>
                <BR />
                Lecture: 
                <INPUT TYPE = "text" NAME = "lecture-name" SIZE = "20" />
                <BR />
                Game: 
                <INPUT TYPE = "radio" NAME = "game-type" VALUE = "BIN" CHECKED ONCLICK = "setHide( 'hide-me', 'search-size' )"> Bingo
                <INPUT TYPE = "radio" NAME = "game-type" VALUE = "WOR" ONCLICK = "setBlock( 'hide-me', 'search-size' )"> Wordsearch
                <BR />
                <DIV ID = "search-size" STYLE = "display: none" >
                    How large should the grid be:
                </DIV>
                <INPUT TYPE = "hidden" ID = "hide-me" NAME = "word-options" SIZE = "2" VALUE = "25" />
                <BR />
                <STRONG>-- PICK ONE: --</STRONG>
                <BR />
                Upload new lecture:
                <INPUT TYPE = "file" NAME = "teacherupload" SIZE = "20" />
                <BR />
                <STRONG>-- OR --</STRONG>
                <BR />
                Wordlist:
                <BR />
                <TEXTAREA COLS = "40" ROWS = "10" NAME = "teacher-list"></TEXTAREA>
                <BR />
                <INPUT TYPE = "submit" NAME = "page" VALUE = "Add Words"/>
                <INPUT TYPE = "reset" NAME = "teacher-reset" />
            </FORM>
            <BR />
            <FORM ACTION = "<TMPL_VAR NAME = "action">" METHOD = "get">
                <INPUT TYPE = "submit" NAME = "page" VALUE = "Your Games" />
            </FORM>
        </DIV>
        <DIV CLASS = "error-box">
            <FONT COLOR = "#ff0000">
                <TMPL_VAR NAME = "errmsg">
            </FONT>
        </DIV>
    </BODY>
<HTML>