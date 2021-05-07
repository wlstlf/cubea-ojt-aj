<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardver3.dao.Encryption" %>
<%@ page import="boardver3.common.*" %>
<%@ page import="boardver3.dao.CommonDAO" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

   

<%
	request.setCharacterEncoding("UTF-8");
	CommonUtil common = CommonUtil.getInstance();	// alert + url 지정 

	String[] arr = {"id","pwd","name","email","gubun"}; // 순서 확인용
	ValidationCheck valid = ValidationCheck.getInstance();
	//String[] parameterChk = valid.nullChkeck(request, arr); // null chk 후 가지고온다 
	boolean returnchk = (boolean)valid.validation(request, arr).get("succ");
	
	if(!returnchk) { // false인 경우 
		System.out.println(valid.validation(request, arr).get("message").toString());
		out.println(common.jsAlertUrl("필수항목이 넘어오지 않았습니다.", "javascript:window.history.back();"));
		return;
	}
	
	// ValidationCheck.java에서 throw ~ exception으로 처리했을때는 이렇게 받는다.
	//	try { // nullcheck }
	//	catch(Exception e) { out.println("<script>history.back();</script>"); } 
	
	// 워에서 null 체크해서 따로 null 체크안한다. 
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	String gubun = request.getParameter("gubun"); 
//	String tel1 = request.getParameter("tel1");
//	String tel2 = request.getParameter("tel2");
//	String tel3 = request.getParameter("tel3");
	

	CommonDAO dao = CommonDAO.getInstance();
	int result = 0;
	
	// 등록할 값 보낼 객체 선언 
	Map<String,Object> map = new HashMap<String,Object>();
	
	map.put("id", id);

	// 비밀번호는 암호화 시켜서 보냄 
//	byte[] temp = pwd.getBytes();
	byte[] temp = pwd.getBytes();
	Encryption encrypt = new Encryption();
	String temp2 = encrypt.set_Pwd(temp); // 암호화 시킨다.
	map.put("pwd", temp2);
			
	map.put("name", name);  // 이름에서 arr[번호]로..?ㅋㅋㅋㅋ 
	map.put("email", email);
//	map.put("tel1", tel1);
//	map.put("tel2", tel2);
//	map.put("tel3", tel3);
	map.put("gubun", gubun);
	
	
	// insert 회원처리 
	result = dao.insert_Data("Member.insertMember", map);
	
	if(result != 0 ){  // js-> common 유틸로 수정 
		out.println(common.jsAlertUrl("회원가입이 완료되었습니다.", "login.jsp"));
	}else{
		out.println(common.jsAlertUrl("회원가입 실패!!", "login.jsp"));
	}

%>
