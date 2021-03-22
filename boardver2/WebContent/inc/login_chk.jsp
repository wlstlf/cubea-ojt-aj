<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardver2.common.CommonUtil" %>


<%
	CommonUtil common = new CommonUtil(); // 공용 util 생성!

	// 세션 값 
	String mem_id = "";
	String mem_name = "";
	String mem_email = "";
	String mem_tel = "";
	String mem_gubun = "";
	
	Map<String, Object> memberInfo = new HashMap<String,Object>();
	if(session.getAttribute("memberInfo") != null) {  // 항상 널 체크를 미리 해줘야한다. 
 		memberInfo = (HashMap)session.getAttribute("memberInfo");
		mem_id = (String)memberInfo.get("ID");
		mem_name = (String) memberInfo.get("NAME");
		mem_email = (String) memberInfo.get("EMAIL");
		mem_tel = (String)memberInfo.get("TEL1")+ (String)memberInfo.get("TEL2") + (String)memberInfo.get("TEL3");
		mem_gubun = (String) memberInfo.get("GUBUN");
	}

	if(mem_id.equals("") || mem_name.equals("") || mem_email.equals("") || mem_tel.equals("") || mem_gubun.equals("")){
		out.println(common.jsAlertUrl("로그인이 필요한 서비스 입니다.", "../main/login.jsp"));
	}  
	
%>


