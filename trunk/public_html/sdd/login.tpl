<HTML>
    <HEAD>
        <TITLE><TMPL_VAR NAME = "title"></TITLE>
        <LINK REL = "stylesheet" TYPE = "text/css" HREF = "<TMPL_VAR NAME = "style">" />
    </HEAD>
    <BODY>
		<DIV CLASS = "container-box">
			<DIV NAME = "login-box" CLASS = "login-box">
				<H3>LOGIN</H3>
				<FORM ACTION = "<TMPL_VAR NAME = "action">" METHOD = "GET">
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
			</DIV>
			<DIV NAME = "register-box" CLASS = "register-box">
				<H3>REGISTER</H3>
				<FORM ACTION = "<TMPL_VAR NAME = "register-action">" METHOD = "GET">
					Username:
					<BR />
					<INPUT TYPE = "text" NAME = "register-user" />
					<BR />
					Real Name:
					<BR />
					<INPUT TYPE = "text" NAME = "real-name" />
					<BR />
					Password:
					<BR />
					<INPUT TYPE = "password" NAME = "register-password" />
					Retype Password:
					<BR />
					<INPUT TYPE = "password" NAME = "confirm-password" />
					<BR />
					<INPUT TYPE = "submit" NAME = "page" VALUE = "Register" />
				</FORM>
				
			</DIV>
			<DIV CLASS = "error-box">
				<FONT COLOR = "#ff0000">
					<TMPL_VAR NAME = "errmsg">
				</FONT>
			</DIV>
		</DIV>
		
    </BODY>
</HTML>