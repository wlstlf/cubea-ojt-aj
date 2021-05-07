<%@page import="boardver3.common.ValidationCheck"%>
<%@page import="boardver3.dao.CommonDAO"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardver3.common.CommonUtil" %>


<%
	request.setCharacterEncoding("UTF-8");

	CommonDAO dao = CommonDAO.getInstance(); // 공용 dao 생성 
	ValidationCheck valid = ValidationCheck.getInstance(); // 공용 valid 생성
	CommonUtil common = CommonUtil.getInstance(); // 공용 util 생성!

	// 세션 값 
	String mem_id = "";
	String mem_name = "";
	String mem_email = "";
	String mem_gubun = "";
	
	Map<String, Object> memberInfo = new HashMap<String,Object>();
	if(session.getAttribute("memberInfo") != null) {  // 항상 널 체크를 미리 해줘야한다. 
 		memberInfo = (HashMap)session.getAttribute("memberInfo");
		mem_id = (String)memberInfo.get("ID");
		mem_name = (String) memberInfo.get("NAME");
		mem_email = (String) memberInfo.get("EMAIL");
		//mem_tel = (String)memberInfo.get("TEL1")+ (String)memberInfo.get("TEL2") + (String)memberInfo.get("TEL3");
		mem_gubun = (String) memberInfo.get("GUBUN");
	}

	if(mem_id.equals("") || mem_name.equals("") || mem_email.equals("") || mem_gubun.equals("")){
		out.println(common.jsAlertUrl("로그인이 필요한 서비스 입니다.", "../main/login.jsp"));
	}  
	
%>








