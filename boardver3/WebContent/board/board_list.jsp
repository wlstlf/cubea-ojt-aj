<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="boardver3.dao.CommonDAO"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.util.List" %>

<!-- 한글 안깨지게 처리 & 로그인 세션처리  -->
<%@ include file="../inc/login_chk.jsp" %>

<%
	// 이전 화면에서 넘어온 값 
	String temp = request.getParameter("pg") == null || request.getParameter("pg").equals("null") || request.getParameter("pg").equals("")? "1" : request.getParameter("pg");
	int pg = Integer.parseInt(temp); 
	String searchType  = (request.getParameter("searchType")==null? "all":request.getParameter("searchType")); 
	String keyword  = (request.getParameter("keyword")==null?"":request.getParameter("keyword")); 
	
	// paging 처리를 위한 갯수 세기 
	Map<String, Object> input = new HashMap<String, Object>();
	input.put("searchType", searchType);
	input.put("keyword",keyword);
	int total = dao.select_One("Board.listCount", input);
	
	// 리스트 불러오기
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
	
	
	// user인 경우 일단 게시판 글 못쓰게 
	function insertBoard(){
		
		let gubn = '<%=mem_gubun %>';
		if(gubn == 'admin'){
			location.href= "modifyBoard.jsp?pg="+'<%= pg %>'+"&searchType="+'<%=searchType%>'+"&keyword="+'<%=keyword%>';
			<%-- let str = "modifyBoard.jsp?pg="+'<%= pg %>'+"&searchType="+'<%=searchType%>'+"&keyword="+'<%=keyword%>';
			str = "location.href = '" + str + "';";
			$("#insertBoard").attr('onclick',str); --%>
		}else if(gubn == 'user'){
			alert("user는 게시글 작성이 불가능합니다.");
		}
		
	}

</script>


<title>게시판</title>
</head>
<body>


	<div id="ui_page"> <!-- ui_page 시작 -->
	
		<%@ include file="../inc/common.jsp" %>

		<form name="searchFrm" action="board_list.jsp" method="get">
		 	<input type="hidden" id="pg" name="pg" value="" />
		 
			<div class="fr bmg20">
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
						<%-- 관리자 바로 수정처리말고 관리자도 view로 넘어가게 한다.(아래 하나더 만듬)_수정됨
						<td style="width:40%;"><a href="modifyBoard.jsp?num=<%= num %>&pg=<%=pg%>&searchType=<%=searchType%>&keyword=<%=keyword%>"><%= (String) map.get("TITLE") %></a></td> 
						--%>
						<td style="width:40%;">
							<a href="boardView.jsp?num=<%= num %>&pg=<%=pg%>&searchType=<%=searchType%>&keyword=<%=keyword%>"><%= (String) map.get("TITLE") %></a>
						</td>
					<%		
						}else{  // user인 경우
					%>
						<td style="width:40%;">
							<a href="boardView.jsp?num=<%= num %>&pg=<%=pg%>&searchType=<%=searchType%>&keyword=<%=keyword%>"><%= (String) map.get("TITLE") %></a>
						</td>
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
			
			
				</tbody>
			</table>
		
			<!-- 페이징 -->
			<table>
			  <tr>
				<td align="center">
					
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
					
					</td>
				</tr>
			 </table>
		</div>
		
		<div>
			<input type="button" value="등록" class="fr" id="insertBoard" onclick="insertBoard();" />
		</div>
		
		<br><br><br><br>
		<h4>pg 찍어보기 : <%=pg %></h4>
		<h4>searchType 찍어보기 : <%=searchType %></h4>
		<h4>keyword 찍어보기 : <%=keyword %></h4>
		<h4>게시판 총 갯수 : <%= total %></h4>
		<h4>로그인 하셨습니까? id: <%= mem_id %> :: name: <%= mem_name %> :: 구분: <%= mem_gubun %></h4>
		<!-- jstl로 사용시 ${SessionScope.memberId} / ${SessionScope.memberName} 요런식으로 사용  -->
	
	</div><!-- ui_page 끝 -->


</body>
</html>