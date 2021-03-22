<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="boardver2.dto.BoardDTO" %>
<%@ page import="boardver2.dao.BoardDAO" %> --%>
<%@page import="boardver2.dao.CommonDAO"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.util.List" %>

<!-- 세션처리  -->
<%@ include file="../main/header.jsp" %>

<%
	// 한글 안깨지게 처리 
	//request.setCharacterEncoding("UTF-8");

	// 이전 화면에서 넘어온 값 
	String temp = request.getParameter("pg") == null || request.getParameter("pg").equals("null") || request.getParameter("pg").equals("")? "1" : request.getParameter("pg");
	int pg = Integer.parseInt(temp); 
	String searchType  = (request.getParameter("searchType")==null?"all":request.getParameter("searchType")); 
	String keyword  = (request.getParameter("keyword")==null?"":request.getParameter("keyword")); 
	
	// dao - getInstance
	//BoardDAO dao = BoardDAO.getInstance();
	CommonDAO dao = CommonDAO.getInstance();
	
	// paging 처리를 위한 갯수 세기 
	//int total = dao.listCount(searchType, keyword);
	Map<String, Object> input = new HashMap<String, Object>();
	input.put("searchType", searchType);
	input.put("keyword",keyword);
	int total = dao.select_One("Board.listCount", input);
	
	// 리스트 불러오기
	//List<BoardDTO> list = dao.selectData(searchType, keyword); // 검색어들을 보낸다. all, title, content
	//List<Map<String,Object>> list = dao.selectData(searchType, keyword); 
	List<Map<String,Object>> list = dao.select_List("Board.boardList", input);
	
	// 페이징처리 
	int size = list.size();
	int size2 = size;
	
	final int ROWSIZE = 5;  // 이 숫자를 바꾸는데로 볼 수 있게 짜라고 하심 ㅠㅠ 
	final int BLOCK = 5;
	int indent = 0;
	int end = (pg*ROWSIZE); // 1* 5 = 5 
	int allPage = 0;
	int startPage = ((pg-1)/BLOCK*BLOCK)+1; // 1인경우 = 1 / 2인경우 (1/5*5)+1 = 0.2*5 =1+1=2
	int endPage = ((pg-1)/BLOCK*BLOCK)+BLOCK; // 1인경우 =5 / 2인경우(1/5*5)+5 =0.2*5 =1 +5 = 6
	allPage = (int)Math.ceil(total/(double)ROWSIZE); // 1인경우 3 
	
	if(endPage > allPage) {endPage = allPage;} // endPage = 3
	size2 -=end; // size 6 = 11-5 
	if(size2 < 0) {
		end = size;
	}
	
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="../res/css/board.css" />
<link rel="shortcut icon" href="#"> <!-- favicon 404 없애기  -->

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript">

	// url 자르기 - 맨처음엔 undefined로 나옴
	function getUrlParams(){ 
		var params = {};
		window.location.search.replace(/[?&]+([^=&]+)=([^&]*)/gi,
				function(str,key,value){params[key] = value;}
		);
		return params;
	}
	
	function pgNumReload(num){
		$("#pg").val(num);
		document.searchFrm.submit();
	}
	
	$(document).ready(function(){
		var sel = '<%=searchType%>'; 
		$("#searchType").val(sel).attr("selected");
	}); 
	
	
	// 로그아웃 버튼 
	function logout(){
		window.location.href="../main/logout.jsp";
	}

</script>


<title>게시판</title>
</head>
<body>


	<div id="ui_page"> <!-- ui_page 시작 -->
	
	<h2>로그인 하셨습니까? id: <%= mem_id %> :: name: <%= mem_name %> :: 구분: <%= mem_gubun %></h2>
	<!-- jstl로 사용시 ${SessionScope.memberId} / ${SessionScope.memberName} 요런식으로 사용  -->
	
	<div><input type="button" value="로그아웃" style="float:right;" onclick="logout();"/></div>
	
		<h2> Board ver.1 </h2>

		<form name="searchFrm" action="board_list.jsp" method="get">
		 	<input type="hidden" id="pg" name="pg" value="" />
		 
		 	<div class="boardteam">
				<span>
					<label id="stype" for="searchType"></label>
					<select id="searchType" name="searchType">
						<option value="all">전체</option> <%--  <%= searchType.equals("all") ? "selected" : "" %> --%>
						<option value="title">제목</option>
						<%-- <option value="title" <%= searchType.equals("title") ? "selected" : "" %>>제목</option> --%>
						<option value="content">내용</option>
						<option value="author">작성자</option>
						<option value="id">ID</option>
					</select>
				</span>
				<input type="text" name="keyword" id="keyword" value="<%= keyword %>"/>
				<input type="button" value="검색" onclick="pgNumReload(1);" />
			</div>
		</form>
			 
		<div id="list">
			<h2>pg 찍어보기 : <%=pg %></h2>
			<h2>searchType 찍어보기 : <%=searchType %></h2>
			<h2>keyword 찍어보기 : <%=keyword %></h2>
			<h2>게시판 총 갯수 : <%= total %></h2>
	
			<table class="boardtb">
				<thead>
					<tr>
						<th>num</th>
						<th>ID</th>
						<th>title</th>
						<th>작성자</th>
						<th>등록일</th>
						<th>수정일</th>
						<th>view</th>
					</tr>
				</thead>
				<tbody>
		
			<%	
				// 리스트 뿌리기
				if(total == 0){
			%>
					<tr>
						<td colspan="7">작성된 글이 없습니다.</td>
					</tr>
					
			<%
				}else{
					for(int i = ROWSIZE*(pg-1); i<end; i++){
						Map<String,Object> map = list.get(i);  // 받아와서 
						String num = String.valueOf(map.get("NUM")); // int라서 String 변환 
						String reg_date = String.valueOf(map.get("REG_DATE"));  // date 타입이라서 String 변환 
						String up_date = String.valueOf(map.get("UP_DATE"));    
						String view_cnt = String.valueOf(map.get("VIEW_CNT"));
			%>		
			
					<tr>
						<td><%= num %></td>
						<td><%= (String) map.get("ID") == null? "-" : (String) map.get("ID") %></td>
						
					<% 
						if(mem_gubun != null && mem_gubun.equals("admin")){ // 관리자인 경우 그냥 modify로 간다.
					%>
						<td style="width:40%;"><a href="modifyBoard.jsp?num=<%= num %>&pg=<%=pg%>&searchType=<%=searchType%>&keyword=<%=keyword%>"><%= (String) map.get("TITLE") %></a></td>
					<%		
						}else{  // user인 경우
					%>
						<td style="width:40%;"><a href="boardView.jsp?num=<%= num %>&pg=<%=pg%>&searchType=<%=searchType%>&keyword=<%=keyword%>"><%= (String) map.get("TITLE") %></a></td>
					<%		
						}
					%>
						<td><%= (String) map.get("NAME") %></td>
						<td><%= reg_date %></td>
						<td><%= up_date.equals("null")? "-" : up_date %></td>
						<td><%= view_cnt.equals("null")? "-" : view_cnt %></td>
					</tr> 
			<%
					}  // for문 종료 
				} // else문 종료 
					
			%>
			
			
<%-- 		DTO 사용 
			<%		
				}else{
					for(int i = ROWSIZE*(pg-1); i<end; i++){
						BoardDTO dto = list.get(i);
			%>
					<tr>
						<td><%= dto.getNum() %></td>
						<td><%= dto.getId() == null? "-" : dto.getId() %></td>
						
					<% 
						if(mem_gubun != null && mem_gubun.equals("admin")){ // 관리자인 경우 그냥 modify로 간다.
					%>
						<td style="width:40%;"><a href="modifyBoard.jsp?num=<%= dto.getNum() %>&pg=<%=pg%>&searchType=<%=searchType%>&keyword=<%=keyword%>"><%= dto.getTitle() %></a></td>
					<%		
						}else{  // user인 경우
					%>
						<td style="width:40%;"><a href="boardView.jsp?num=<%= dto.getNum() %>&pg=<%=pg%>&searchType=<%=searchType%>&keyword=<%=keyword%>"><%= dto.getTitle() %></a></td>
					<%		
						}
					%>
						<td><%= dto.getName() %></td>
						<td><%= dto.getReg_date() %></td>
						<td><%= dto.getUp_date() == null? "-" :dto.getUp_date() %></td>
						<td><%= dto.getView_cnt() %></td>
					</tr> 
--%>
			
		<%-- 	<% 		
					}  // for문 종료 
				} // else문 종료 
			%>  --%>
			
				</tbody>
			</table>
		
			<!-- 페이징 -->
			<table>
			  <tr>
				<td align="center">
					<%--  <%
						if(pg > BLOCK) {
					%>
						[<a href="board_list.jsp?pg=1&searchType=<%=searchType%>">처음</a>]
						[<a href="board_list.jsp?pg=<%=startPage-1%>&searchType=<%=searchType%>">ㅇㅇㅇ</a>]
					<%
						}
					%>  --%>
					
					<%
						for(int i=startPage; i<= endPage; i++){ // 1 , 5  , 1-2-3-4-5
							if(i == pg){
					%>
								<b>[<%=i %>]</b>
					<%
							}else{
					%>
								[<a href="board_list.jsp?pg=<%= i %>&searchType=<%=searchType%>&keyword=<%=keyword%>"><%=i %></a>]
					<%
							}
						}
					%>
					
					<%-- <%
						if(endPage<allPage){
					%>
						[<a href="board_list.jsp?pg=<%=endPage+1%>&searchType=<%=searchType%>">마지막</a>]
						[<a href="board_list.jsp?pg=<%=allPage%>&searchType=<%=searchType%>">ㅈㅈㅈ</a>]
					<%
						}
					%>  --%>
					</td>
				</tr>
			 </table>
		</div>
		
		<div>
			<input type="button" value="등록" class="boardteam" onClick="location.href='modifyBoard.jsp?pg=<%= pg %>&searchType=<%=searchType%>&keyword=<%=keyword%>'" />
		</div>
	</div><!-- ui_page 끝 -->


</body>
</html>