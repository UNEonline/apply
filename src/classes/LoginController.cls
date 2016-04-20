global with sharing class LoginController {

	public String username { get; set; }
    public String password { get; set; }
    public String forgotpass { get; set; }
    public Boolean isLoggedIn { get; set; }

	public LoginController() {
        if (UserInfo.getUserType().equals('Guest')) {
            isLoggedIn = false;
        }
        else {
            isLoggedIn = true;
            forwardToHome();
        }
	}

	global PageReference forwardToHome() {
		PageReference p = new PageReference('/UneOnlineHome');
		p.setRedirect(true);
		return p;
	}

	public PageReference forwardToRegisterPage() {
		return new PageReference('/Register');
	}

    global PageReference forwardToCustomAuthPage() {
        return new PageReference('/Login');
    }


    global PageReference login() {
        if (username == null || username.length() == 0) {
            PageMessages.addMessage(new PageMessages.PageMessage(PageMessages.Severity.FATAL, 'Please enter your username.'));
        }
        if (password == null || password.length() == 0) {
            PageMessages.addMessage(new PageMessages.PageMessage(PageMessages.Severity.FATAL, 'Please enter your password.'));
        }

        if (PageMessages.getMessages().size() > 0) {
            return null;
        }

        PageReference loginAttempt = Site.login(username, password, null);
        if (loginAttempt == null) {
            PageMessages.addMessage(new PageMessages.PageMessage(PageMessages.Severity.FATAL, 'Login failed. Please check your username and password.'));
            return null;
        }
        else {
            return loginAttempt;
        }
    }

    global PageReference logout() {
        return new PageReference('/Logout');
    }

    global PageReference reset() {
        Site.forgotPassword(forgotpass);
        return null;
    }

}