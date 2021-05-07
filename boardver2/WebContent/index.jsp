<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%

	Map<String, Object> input = new HashMap<String, Object>();
	input = (HashMap) session.getAttribute("memberInfo");
	if(input == null ){
		response.sendRedirect("main/login.jsp");
	}else{
		response.sendRedirect("board/board_list.jsp");
	}

%>

