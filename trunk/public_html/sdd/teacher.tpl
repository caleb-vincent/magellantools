<HTML>
    <HEAD>
        <TITLE><TMPL_VAR NAME = "title"></TITLE>
        <LINK REL = "stylesheet" TYPE = "text/css" HREF = "<TMPL_VAR NAME = "style">" />
    </HEAD>
    <BODY>
    <DIV CLASS = "teacher-box">
        <H3>Teacher</H3>
        <FORM ACTION = "<TMPL_VAR NAME = "action">" METHOD = "get">
            Upload new lecture:
            <INPUT TYPE = "file" NAME = "teacher-upload" SIZE = "20" />
            <BR />
            -- OR --
            <BR />
            Wordlist:
	          <BR />
            <TEXTAREA COLS = "40" ROWS = "10" NAME = "teacher-list"></TEXTAREA>
            <BR />
            <INPUT TYPE = "submit" NAME = "teacher-submit" VALUE = "Submit" /> <INPUT TYPE = "reset" NAME = "teacher-reset" />
        </FORM>
        <BR />
        <FORM ACTION = "<TMPL_VAR NAME = "action">" METHOD = "get">
            <INPUT TYPE = "button" NAME = "teacher-viewgames" VALUE = "Your Games" />
        </FORM>
    </DIV>
 </BODY>
<HTML>