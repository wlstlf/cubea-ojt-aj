<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="boardver2.dto.BoardDTO" %>
<%@ page import="boardver2.dao.BoardDAO" %> --%>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="boardver2.dao.CommonDAO" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>


<!-- 세션처리  -->
<%@ include file="../main/header.jsp" %>

<%
	// 바로 수정하는건 쿠키 사용 X 
	// 한글 안깨지게 처리 
	//request.setCharacterEncoding("UTF-8");

	String temp = request.getParameter("num")==null?"0":request.getParameter("num");
	int num = Integer.parseInt(temp);
	//BoardDTO dto = new BoardDTO(); // dto
	//BoardDAO dao = BoardDAO.getInstance(); // dao
	CommonDAO dao = CommonDAO.getInstance(); // dao
	Map<String,Object> map = new HashMap<String,Object>();
	
	if(num != 0){
		//map = dao.selectOne(num);	
		map = dao.select_Row("Board.selectOne", num); 
	} 
	
	String pg = request.getParameter("pg");
	String searchType  = request.getParameter("searchType"); 
	String keyword  = request.getParameter("keyword");
	
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="../res/css/board.css" />
<link rel="shortcut icon" href="#"> <!-- favicon 404 없애기  -->

<script type="text/javascript">

	// 인서트 처리
	function writeChk(){
		
		var form = document.writeFrm;
		
		if(!form.title.value){
			alert("제목을 입력해주세요");
			form.title.focus();
			return;
		}
		
		if(!form.name.value){
			alert("이름을 입력해주세요");
			form.name.focus();
			return;
		}
		
		if(!form.contents.value){
			alert("내용을 입력해주세요");
			form.contents.focus();
			return;
		}
		
		document.getElementById("sort").value = "i";
		form.submit(); // form 보내기 
	}

	// 업데이트 처리 
	function updateAction(data){
		if(data == 'u'){
			var con = confirm("게시글을 수정하겠습니까?");
			 if(con){
				document.getElementById("sort").value = "u";
				document.writeFrm.submit(); // 수정 값 넘기기 
		     }
		} 
		
		if(data == 'd'){
			var con = confirm("게시글을 삭제하겠습니까?");
			 if(con){
				document.getElementById("sort").value = "d";
				document.writeFrm.submit(); 
		     }
		} 
		
	}

</script>



<title>게시글 수정/등록</title>
</head>
<body>
	
	<div id="ui_page" class="board">
		<form name="writeFrm" method="post" action="iud_action.jsp">
		   <input type="hidden" name="sort" value="" id="sort" />
		   
		   	<input type="hidden" name="pg" value="<%= pg %>" />
			<input type="hidden" name="searchType" value="<%= searchType %>"/>
			<input type="hidden" name="keyword" value="<%= keyword %>" />
			<input type="hidden" name="num" value="<%= num %>" />
			
			<input type="hidden" name="id" value="<%= mem_id %>" /> <!-- id 넘긴다. -->
		
			<%
				String return_view_cnt = String.valueOf(map.get("VIEW_CNT")==null?"0":map.get("VIEW_CNT"));
				String return_title = String.valueOf(map.get("TITLE")==null?"":map.get("TITLE"));  // date 타입이라서 String 변환 
				String content = (String)(map.get("CONTENTS")==null?"":map.get("CONTENTS")); 
		     	content = content.replace("<br>", "\r\n"); //  개행처리 반대로
			%>
		
		   	<table class="boardtb">
			   	 <tr>
			         <th>제목</th>
			         <td colspan="4"><input type="text" name="title" value="<%= return_title %>"/></td>
			      </tr>
			      <tr>
			         <th>작성자</th>
			         <td colspan="4"><input type="text" name="name" value="<%= mem_name %>" readonly/> id 확인 : <%= mem_id %></td>
			      </tr>
			     
			     <% if(num != 0){   System.out.println("num : " + num); %>
				     <tr>
				      	<th>num</th>
				      	<td colspan="4"><input type="text" value="<%= num %>" readonly/> 조회수 : <%= return_view_cnt %></td>
				      </tr>
				      <tr>
			     <% } %>
			     
			         <th>내용</th>
			         <td colspan="4" style="height:300px; text-align:left; padding-left:10px;">
			         	<textarea name="contents"><%= content %></textarea>
		         	</td>
			      </tr>
		   	
<%--  
		     <tr>
		         <th>제목</th>
		         <td colspan="4"><input type="text" name="title" value="<%= dto.getTitle() %>"/></td>
		      </tr>
		      <tr>
		         <th>작성자</th>
		         <td colspan="4"><input type="text" name="name" value="<%= dto != null ? mem_name : dto.getName() %>" readonly/> id 확인 : <%= mem_id %></td>
		      </tr>
		     
		     <% if(num != 0){ %>
			     <tr>
			      	<th>num</th>
			      	<td colspan="4"><input type="text" value="<%= num %>" readonly/> 조회수 : <%= dto.getView_cnt() %></td>
			      </tr>
			      <tr>
		     <% } %>
		     <% String content = dto.getContents().replace("<br>", "\r\n"); %> <!-- 개행처리 반대로 -->
		         <th>내용</th>
		         <td colspan="4" style="height:300px; text-align:left; padding-left:10px;">
		         	<textarea name="contents"><%= content %></textarea>
	         	</td>
		      </tr> 
 --%>
 
		   </table>
		   
	   </form>	
		   
		    <%
		   		if(num ==0){
	   		%>
	   			<input type="button" value="등록"  class="boardteam" onclick="javascript:writeChk('i');"/>
	   		<%
		   		}else if(num !=0){
	   		%>	
	   		 	 <input type="button" value="수정"  class="boardteam" onclick="javascript:updateAction('u');"/>
	   		 	 <input type="button" value="삭제"  class="boardteam" onclick="javascript:updateAction('d');"/>
	   		<%
		   		}
		    %>
		   		<input type="button" value="목록" class="boardteam" onclick="location.href='board_list.jsp?pg=<%= pg %>&searchType=<%=searchType%>&keyword=<%=keyword%>'"/>
	   	   
	</div>

</body>
</html>