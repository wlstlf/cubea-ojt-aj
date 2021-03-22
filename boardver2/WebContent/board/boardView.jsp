<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="boardver2.dto.BoardDTO" %>
<%@ page import="boardver2.dao.BoardDAO" %> --%>
<%@ page import="boardver2.dao.CommonDAO" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>


<!-- 세션처리  -->
<%@ include file="../main/header.jsp" %>

<%
	// 한글 안깨지게 처리 (헤더에 넣음)
	//request.setCharacterEncoding("UTF-8");

	//BoardDAO dao = BoardDAO.getInstance();
	CommonDAO dao = CommonDAO.getInstance();

	String temp = request.getParameter("num"); // 번호
	String pg = request.getParameter("pg"); // 페이지
	String searchType  = request.getParameter("searchType"); // 검색
	String keyword  = request.getParameter("keyword"); // searchType 이 all 이면 null 값
	
	int num = Integer.parseInt(temp);
	
	// ------------쿠키처리 (일단은 user기준으로 boardView.jsp에서만 처리한다.)--------------
	int result = 0;
	Cookie[] cookies = request.getCookies();
	Cookie 	BoardView = new Cookie("BoardView", "|"+temp+"|"); // temp 넣어서 넣는다.
	
	if(cookies.length == 1){   // JSESSIONID가 쿠키 0번(length=1)으로 잡힘 
		out.println("뺚뺚");
		response.addCookie(BoardView); // 이걸해야 쿠키 생김 (boardView 들어오면 쿠키 만들기)
		result = dao.insert_Data("Board.updateViewCnt", num); // 처음에도 viewCnt + 1 하기 
	}else{
		for(int i=0; i<cookies.length; i++){
			String str = cookies[i].getName();
			
			if(str.equals("BoardView")){
				out.println("찍어보자 쿠킷" + cookies[i].getValue() + "///////");
				String value = cookies[i].getValue();
				
				if(value.indexOf("|"+temp+"|")<0){ // 이 |temp|값이 없을때만 탄다.
					result = dao.insert_Data("Board.updateViewCnt", num);

					value = value + "|" + temp + "|";
					BoardView.setValue(value);
					response.addCookie(BoardView); // 이걸해야 새로 쿠키 생김 
				} 
			}
		}
	}
	
	// 받아올 그릇 선언 
	//BoardDTO dto = dao.selectOne(num);	
	Map<String,Object> map = new HashMap<String,Object>();
	//map = dao.selectOne(num);  // 1개 값 담아옴 
	map = dao.select_Row("Board.selectOne", num);
	
	// resultType="map"으로 받는경우는 대문자로 써야 받아진다. 컬럼명을 
	String return_num = String.valueOf(map.get("NUM")); // int라서 String 변환 
	String return_reg_date = String.valueOf(map.get("REG_DATE"));  // date 타입이라서 String 변환 
	String return_up_date = String.valueOf(map.get("UP_DATE"));    
	String return_view_cnt = String.valueOf(map.get("VIEW_CNT"));
	String return_id = (String)map.get("ID");
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="../res/css/board.css" />
<link rel="shortcut icon" href="#"> <!-- favicon 404 없애기  -->

<script type="text/javascript">

	function delChk(){
		 document.getElementById("sort").value = 'd';
		 var theForm = document.writeFrm;
		 
		 var con = confirm("게시글을 삭제하겠습니까?");
		 if(con){
			 theForm.action = "iud_action.jsp"; // form action 변경
			 document.writeFrm.submit();
			 theForm.submit();
	     }
	}
		
	function upChk(){
		document.writeFrm.submit(); // 수정 값 넘기기 
	}

	
	
</script>

<title>게시글 상세보기</title>
</head>
<body>

	<div id="ui_page">
	
		<h2>로그인 하셨습니까? id: <%= mem_id %> :: name: <%= mem_name %></h2>
	
		<form name="writeFrm" method="get" action="modifyBoard.jsp">
		
			<!-- 보낼값 -->
			<input type="hidden" name="pg" value="<%= pg %>" />
			<input type="hidden" name="searchType" value="<%= searchType %>"/>
			<input type="hidden" name="keyword" value="<%= keyword %>" />
			<%-- <input type="hidden" name="num" value="<%= dto.getNum() %>" /> --%>
			<input type="hidden" name="num" value="<%= return_num %>" />
			<input type="hidden" name="sort" value="" id="sort" />			
			
		   <table class="boardtb">
		   	 <tr>
		         <th>제목</th>
		         <td style="width:50%;"><%= (String) map.get("TITLE") %></td>
		         <th>조회수</th>
		         <td><%= return_view_cnt.equals("null")? "0" : return_view_cnt %></td>
		      </tr>
		      <tr>
		         <th>ID</th>
		         <td><%= (String) map.get("ID") == null? "id없음!!!!" : (String) map.get("ID") %></td> <!-- 일단 보여지는건 저장되어있는 걸로 보여야함. -->
		         <th>작성자</th>
		         <td><%= (String) map.get("NAME") %></td> <!-- 일단 보여지는건 저장되어있는 걸로 보여야함. -->
		      </tr>
		      <tr>
		      	<th>num</th>
		      	<td><%= return_num %></td>
		      	<th>작성일</th>
		        <td><%= return_reg_date %></td>
		      </tr>
		      <tr>
		         <th>내용</th>
		         <td colspan="4" style="height:300px; text-align:left; padding-left:10px;"><%= (String) map.get("CONTENTS") %></td>
		      </tr>
		   
<%-- 		DTO 사용 
			  <tr>
		         <th>제목</th>
		         <td style="width:50%;"><%= dto.getTitle() %></td>
		         <th>조회수</th>
		         <td><%= dto.getView_cnt() %></td>
		      </tr>
		      <tr>
		         <th>ID</th>
		         <td><%= dto.getId() == null? "id없음!!!!" : dto.getId() %></td> <!-- 일단 보여지는건 저장되어있는 걸로 보여야함. -->
		         <th>작성자</th>
		         <td><%= dto.getName() %></td> <!-- 일단 보여지는건 저장되어있는 걸로 보여야함. -->
		      </tr>
		      <tr>
		      	<th>num</th>
		      	<td><%= dto.getNum() %></td>
		      	<th>작성일</th>
		        <td><%= dto.getReg_date() %></td>
		      </tr>
		      <tr>
		         <th>내용</th>
		         <td colspan="4" style="height:300px; text-align:left; padding-left:10px;"><%= dto.getContents() %></td>
		      </tr> 
 --%>
 
		   </table>
	   </form>
	   
	   <div>
	   	   <!-- 보인 아이디랑 일치할 경우 수정/삭제 버튼 보이게 아닌경우 안보이게 한다. -->
   	   <%
   	   		//if( dto.getId() != null && dto.getId().equals(mem_id)){ 	// id가 null 인 값들이 있으니깐
 	   		if((mem_gubun !=null &&mem_gubun.equals("admin")) || (return_id != null && return_id.equals(mem_id))){
   	   %>
	   	   
		   <input type="button" value="수정" class="boardteam" onclick="javascript:upChk();"/>
		   <input type="button" value="삭제" class="boardteam" onclick="javascript:delChk();" />
	   	   
   	   <%			
   	   		}
   	   %>

	   	   <input type="button" value="목록" class="boardteam" onclick="location.href='board_list.jsp?pg=<%=pg%>&searchType=<%=searchType%>&keyword=<%=keyword%>'"/>
	   </div>
	   
		
	</div>

</body>
</html>