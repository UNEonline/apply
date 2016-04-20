public with sharing class PageMessages {

    public PageMessages() {
        throw new UnsupportedOperationException('The PageMessages class cannot be instantiated. Maybe you were looking for PageMessages.PageMessage()?');
	}

    public enum Severity {CONFIRM,SUCCESS,INFO,WARN,FATAL,ERROR}

    private static List<PageMessage> StaticMessages {
        get {
            if(StaticMessages == null) StaticMessages = new List<PageMessage>();
            return StaticMessages;
        }
        private set;
    }

    public class PageMessage {
        private Map<Severity,String> SeverityStrMap = new Map<Severity,String>{
            Severity.CONFIRM => 'confirm',
            Severity.SUCCESS => 'confirm',
            Severity.INFO => 'info',
            Severity.WARN => 'warn',
            Severity.FATAL => 'fatal',
            Severity.ERROR => 'fatal'
        };

        public Severity SeverityLevel { get; set; }
        public String SeverityStr { get; set; }
        public String Message { get; set; }

        public PageMessage (Severity theSeverity, String theMessage) {
            this.SeverityLevel = theSeverity;
            this.Message = theMessage;
            this.SeverityStr = SeverityStrMap.get(theSeverity);
        }
    }

    public static void addMessage(PageMessage thePageMessage) {
        StaticMessages.add(thePageMessage);
    }

    public static List<PageMessage> getMessages(){
        return StaticMessages;
    }
}