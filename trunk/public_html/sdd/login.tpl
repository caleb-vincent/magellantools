<HTML>
    <HEAD>
        <TITLE><TMPL_VAR NAME = "title"></TITLE>
        <LINK REL = "stylesheet" TYPE = "text/css" HREF = "<TMPL_VAR NAME = "style">" />
    </HEAD>
    <BODY>
        <DIV NAME = "login-box" CLASS = "login-box">
            <H3>LOGIN</H3>
            <FORM ACTION = "<TMPL_VAR NAME = "action">" METHOD = "GEt">
                Username:
                <BR />
                <INPUT TYPE = "text" NAME = "login-user" />
                <BR />
                Password:
                <BR />
                <INPUT TYPE = "password" NAME = "login-password" />
                <BR />
                <INPUT TYPE = "submit" NAME = "page" VALUE = "Login" />
            </FORM>
            <FONT COLOR = "#ff0000">
                <TMPL_VAR NAME = "errmsg">
            </FONT>
        </DIV>
    </BODY>
</HTML>