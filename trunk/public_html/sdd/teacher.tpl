<HTML>
    <HEAD>
        <TITLE><TMPL_VAR NAME = "title"></TITLE>
        <LINK REL = "stylesheet" TYPE = "text/css" HREF = "<TMPL_VAR NAME = "style">" />
    </HEAD>
    <BODY>
        <DIV CLASS = "teacher-box">
            <H3>Teacher: <TMPL_VAR NAME = "user"></H3>
            <FORM ACTION = "<TMPL_VAR NAME = "action">" METHOD = "post" ENCTYPE = "multipart/form-data">
                <STRONG>-- ALL --</STRONG>
                <BR />
                Lecture: 
                <INPUT TYPE = "text" NAME = "lecture-name" SIZE = "20" />
                <BR />
                Game: 
                <INPUT TYPE = "radio" NAME = "game-type" VALUE = "BIN"> Bingo
                <INPUT TYPE = "radio" NAME = "game-type" VALUE = "WOR"> Wordsearch
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
                <INPUT TYPE = "submit" NAME = "page" VALUE = "Add Words" />
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