<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.net.*" %>  
<%@ page import="boardver3.dao.CommonDAO" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
    
    
<%
   Map<String, Object> input = new HashMap<String,Object>();
   
   // null체크
   String id= request.getParameter("id") == null? "0" : request.getParameter("id");
   String cmt_no = request.getParameter("cmt_no") == null? "0" : request.getParameter("cmt_no");
   String opinion = request.getParameter("opinion") == null? "0" : request.getParameter("opinion");
   String gubun = request.getParameter("gubun") == null? "0" : request.getParameter("gubun");
   String board_num = request.getParameter("board_num") == null? "0" : request.getParameter("board_num");
   
   System.out.println("board_num ::: " + board_num);

   // DB에 보낼 파라미터 값 
   input.put("cmt_no", cmt_no);
   input.put("id", id);
   input.put("opinion", opinion);
   input.put("board_num", board_num); 
   
   // 리턴값
   Map<String, Object> output = new HashMap<String,Object>();
   CommonDAO dao = CommonDAO.getInstance();
   
   int result = 0;  
   if(!gubun.equals("0") && gubun.equals("N")){ // 등록 
	   result = dao.insert_Data("Board.opinionInsert", input);
   }
   
   if(!gubun.equals("0") && gubun.equals("Y")){  // 수정 
	   result = dao.insert_Data("Board.opinionUpdate", input);
   }
   
  
   // 결과처리
   if(result == 0) {
	   out.print("{\"result\":\"0\"}");  // json형태로 그냥 보냄 , insert 또는 update가 제대로 안됐다는 뜻
   } else { // 성공 
   	   //다시 한번더 타서 찬,반 숫자를 가지고온다. 
	   output = dao.select_Row("Board.opinionCount", cmt_no);
   
   	   String agree = String.valueOf(output.get("AGREE")); // 오라클 에러나서 요러케
   	   String oppo =  String.valueOf(output.get("OPPO"));
   
	   out.print("{\"agree\":\"" + agree + "\", \"oppo\":\""+ oppo +"\",\"result\":\"1\"}");
   }
   
   
%>

