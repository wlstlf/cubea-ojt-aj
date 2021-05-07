package boardver2.common;

public class CommonUtil {
	
	public CommonUtil() {}

	
	// javascript- alert 띄우기 
	
	// javascript- alert 띄우고 url 이동 
	public String jsAlertUrl(String message, String url) {
		
		StringBuffer strBuffer = new StringBuffer();
		strBuffer.append("<script type=\'text/javascript\'>");
		strBuffer.append("alert(\'" + message + "\');");
		strBuffer.append("location.href=\'"+ url + "\'; ");
		strBuffer.append("</script>");
		
		return strBuffer.toString();
	}
	
	
}
