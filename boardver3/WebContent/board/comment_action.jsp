<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.net.*" %>  
<%@ page import="com.google.gson.Gson" %> 
<%@ page import="com.google.gson.JsonObject" %> 
<%@ page import="boardver3.dao.CommonDAO" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>

    
<%
   CommonDAO dao = CommonDAO.getInstance();
   Map<String, Object> input = new HashMap<String,Object>();
   
   // null체크
   String id= request.getParameter("id") == null? "0" : request.getParameter("id");
   String comments = request.getParameter("comments") == null? "0" : request.getParameter("comments");
   String parent_board = request.getParameter("parent_board") == null? "0" : request.getParameter("parent_board");
   String parent_cmt = request.getParameter("parent_cmt") == null? "0" : request.getParameter("parent_cmt");
   String depth = request.getParameter("depth") == null? "0" : request.getParameter("depth");
   
   // 제, 수정시 구분값 sort
   String sort = request.getParameter("sort") == null? "0" : request.getParameter("sort");

   // 삭제, 수정시 사용 
   String cmt_no = request.getParameter("cmt_no") == null? "0" : request.getParameter("cmt_no");
   
   input.put("cmt_no", cmt_no);
   input.put("id", id);
   input.put("comments", comments);
   input.put("parent_board", parent_board);
   input.put("parent_cmt", parent_cmt);
   input.put("depth", depth);
   
   
   int result = 0;  // 등록 이랑 -- 삭제랑 같이 하려고하는데.. cmt_no가 있으면 삭제고/ 없으면 등록 !! 으로 수정하기 
   if(sort.equals("0")){
	   result = dao.insert_Data("Board.insertComment", input);
   }else if(sort.equals("D") || sort.equals("d")){  // 삭제일떄 
	   result = dao.delete_Data("Board.deleteComment", input);
   }else if(sort.equals("U") || sort.equals("u")){  // 수정일때
	   result = dao.delete_Data("Board.updateComment", input);
   }
  
   if(result == 0) {
	   out.print("{\"result\":\"0\"}");  // json형태로 그냥 보냄
	   // 받는쪽에서 dataType:"json" 처리를 해주어야함.
   } else {
	   out.print("{\"result\":\"1\"}");
   }
   
   
%>

