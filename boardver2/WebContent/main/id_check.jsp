<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="boardver2.dao.MemberDAO" %>

<%
	// HTML 
	String id = request.getParameter("id");
	MemberDAO dao = MemberDAO.getInstance();
	int result = dao.idChk(id);
	
	
	if(result == 0){
		// 사용가능 아이디
		out.print("0"); 
	}else{
		// 이미 있어서 사용불가능 아이디 
		out.print("1");
	}
	
%> --%>
    
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.net.*" %>  
<%@ page import="com.google.gson.Gson" %> 
<%@ page import="com.google.gson.JsonObject" %> 
<%-- <%@ page import="boardver2.dao.MemberDAO" %> --%>
<%@ page import="boardver2.dao.CommonDAO" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
    
<%
   // JSON
   request.setCharacterEncoding("utf-8");
   String id = request.getParameter("id");
   
   CommonDAO dao = CommonDAO.getInstance();
   Map<String, Object> input = new HashMap<String,Object>();
   input.put("id", id);
   int result = dao.select_One("Member.idCheck",input);

   Gson gson = new Gson();
   JsonObject obj = new JsonObject();
   if(result == 0) {
      obj.addProperty("result", "0");
   } else {
      obj.addProperty("result", "1");
   }
   
   out.print(gson.toJson(obj));
   
//    out.print("{\"result\":\"0\"}");
%>

