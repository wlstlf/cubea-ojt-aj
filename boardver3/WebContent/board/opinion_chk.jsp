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

   // DB에 보낼 파라미터 값 
   input.put("cmt_no", cmt_no);
   input.put("id", id);
   input.put("opinion", opinion);
   
   // 리턴값
   Map<String, Object> output = new HashMap<String,Object>();
   CommonDAO dao = CommonDAO.getInstance();
   
   if(!opinion.equals("0")){
	   output = dao.select_Row("Board.myopinionCount", input);  // 댓글번호 + id로 조회
		   
	   int agree = Integer.parseInt(output.get("AGREE").toString());  
	   int oppo = Integer.parseInt(output.get("OPPO").toString());
	   
	   System.out.println("agree : "  + agree);
	   System.out.println("oppo : "  + oppo);
	   

	   if(agree == 0 && oppo == 0) {  // 찬성, 반대 다 없을때 
		   out.print("{\"result\":\"0\"}");
	   }
	   
	   if(agree >= 1 && oppo == 0){  // 찬성이 1이상, 반대가 0일때 
		   out.print("{\"result\":\"agree\"}");		
	   }
	   
	   if(agree == 0 && oppo >= 1){ // 찬성이 0, 반대가 1이상
		   out.print("{\"result\":\"oppo\"}");
	   }
	   
	   if(agree > 1 && oppo > 1){   // 찬성, 반대가 다 있는 경우 
		   out.print("{\"result\":\"error\"}");
	   }
   
   }

%>

