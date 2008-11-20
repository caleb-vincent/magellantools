<HTML>
    <HEAD>
        <TITLE><TMPL_VAR NAME = "title"></TITLE>
        <LINK REL = "stylesheet" TYPE = "text/css" HREF = "<TMPL_VAR NAME = "style">" />
    </HEAD>
    <BODY>
        <DIV CLASS = "games-box">
            <H3>Games for teacher: <TMPL_VAR NAME = "user"></H3>
            <FORM ACTION = "<TMPL_VAR NAME = "action">" METHOD = "get">
                <BR />
				<TMPL_IF name = "games">
					<TMPL_LOOP NAME= "games">
						<BR />
						<BR />
						<A HREF = "<TMPL_VAR NAME = "link">">
							<TMPL_VAR NAME = "lecture"> - <TMPL_VAR NAME = "game_type">
						</A>
						<BR />
					</TMPL_LOOP>
				<TMPL_ELSE>
					No games found!
					<BR />
					<BR />
				</TMPL_IF>
                <INPUT TYPE = "submit" NAME = "page" VALUE = "Teacher Page" />
            </FORM>
        </DIV>
        <DIV CLASS = "error-box">
            <FONT COLOR = "#ff0000">
                <TMPL_VAR NAME = "errmsg">
            </FONT>
        </DIV>
    </BODY>
<HTML>