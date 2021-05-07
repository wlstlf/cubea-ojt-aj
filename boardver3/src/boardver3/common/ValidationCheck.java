package boardver3.common;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;


public class ValidationCheck{
	
	
	// 싱글톤 선언
    private static ValidationCheck valid = new ValidationCheck();
    public static ValidationCheck getInstance() {
       return valid;
    }
	
	// 생성자
    private ValidationCheck() {}
	
	// 널 값 체크 
	// 멤버 필수로 넘겨 받는값 
	//String[] parameterArray = {"id","pwd","name","email","gubun"};
	//Map<String, Object> output = new HashMap<String, Object>();
    //  request.getParameter를 줄이려다보니 이상한코드 만들어짐
/*	
 * public Map<String, Object> nullChkeck(HttpServletRequest req, String[] parameterArray) throws Exception {
		int i = 0;
		for(String ab : parameterArray) {
			if(req.getParameter(ab) == null) {
				ab = "";
				//throw new Exception("null인, 값이 있음" + ab); 
			}
			else { ab = req.getParameter(ab); }
			parameterArray[i] = ab;
			i++;
		}
		return parameterArray;
	}
*/

    // HttpServletRequest request 널 값 체크 
	public Map<String, Object> validation(HttpServletRequest request, String [] parameterArray) throws Exception{

		Map<String, Object> resultVo = new HashMap<String, Object>(); // 리턴값
		
		for(String str : parameterArray) {
			if(request.getParameter(str) == null) {
				resultVo.put("succ", false);
				resultVo.put("message", str + " is null");
				
				System.out.println("이것은 널입니다.");
				
				return resultVo;
//				throw new Exception(str + " is null");
			}
			if(request.getParameter(str).toString().isEmpty()) {
				resultVo.put("succ", false);
				resultVo.put("message", str + " is empty");
				
				System.out.println("이것은 empty입니다.");
				
				return resultVo;
//				throw new Exception(str + " is empty");
			}
			if(request.getParameter(str).toString().trim().isEmpty()) {  // trim() 앞뒤 공백 없애기 
				// trim으로 공백을 제거해 준 후 isEmpty를 사용하면 > true 반환
				resultVo.put("succ", false);
				resultVo.put("message", str + " is 공백있음");
				
				System.out.println("이것은 trim입니다.");
				
				return resultVo;
//				throw new Exception(str + " is empty");
			}
			if(request.getParameter(str).toString().replace(" ", "").isEmpty()) { 
				resultVo.put("succ", false);
				resultVo.put("message", str + " is 공백있음");
				
				System.out.println("이것은 replace입니다.");
				
				return resultVo;
//				throw new Exception(str + " is empty");
			}
		}

		resultVo.put("succ", true);
		return resultVo;
	}
	
}
