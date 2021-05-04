<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page import="boardver3.dao.CommonDAO" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>


<!-- 한글 안깨지게 처리 & 로그인 세션처리  -->
<%@ include file="../inc/login_chk.jsp" %>

<%

	String temp = request.getParameter("num") == null? "0" : request.getParameter("num"); // 번호
	String pg = request.getParameter("pg") == null? "" : request.getParameter("pg"); // 페이지
	String searchType  = request.getParameter("searchType") == null? "" : request.getParameter("searchType"); // 검색
	String keyword  = request.getParameter("keyword") == null? "" : request.getParameter("keyword"); // searchType 이 all 이면 null 값
	
	//int num = Integer.parseInt(temp);
	int num = common.stringToint(temp);
	
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
	Map<String,Object> map = dao.select_Row("Board.selectOne", num);
	System.out.println("boardverView : num ==== " + num);
	
	String return_num = "";
	String return_title = "";
	String return_name = "";
	String return_contents = "";
	String return_reg_date = "";
	String return_up_date = "";
	String return_view_cnt = "";
	String return_id = "";
	String return_file = "";
	
	
	if(map == null || map.size() == 0){   
		out.println(common.jsAlertUrl("없는 num 값입니다.", "javascript:window.history.back();")); 
	} 
	
	if(map != null){
		// resultType="map"으로 받는경우는 대문자로 써야 받아진다. 컬럼명을 
		return_num = String.valueOf(map.get("NUM")); // int라서 String 변환 
		return_title = String.valueOf(map.get("TITLE")); 
		return_name = String.valueOf(map.get("NAME")); 
		return_contents = String.valueOf(map.get("CONTENTS")); 
		return_reg_date = String.valueOf(map.get("REG_DATE"));  // date 타입이라서 String 변환 
		return_up_date = String.valueOf(map.get("UP_DATE"));    
		return_view_cnt = String.valueOf(map.get("VIEW_CNT"));
		return_id = (String)map.get("ID");
	}
	
	
	// 파일도 가져오기 (여러개일 수 있다.)
	List<Map<String,Object>> fileReturn = new ArrayList<Map<String,Object>>();
	Map<String,Object> input = new HashMap<String,Object>();
	input.put("num", num);
	fileReturn = dao.select_List("Board.selectFile", input); // 게시판번호로 파일들 가지고오기 
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="../res/css/board.css" />
<link rel="shortcut icon" href="#"> <!-- favicon 404 없애기  -->

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="../res/dev_js/comment.js" ></script> <!-- comment.js -->
<script type="text/javascript">

	window.addEventListener('DOMContentLoaded', function(){
		init(); // 댓글 불러오기 
	});
	
	
	// 댓글 불러오기 
	function init(){
		//console.log(setCount);
		$.ajax({
			type : "post",
			url : "ajaxComment.jsp",
			data: {"board_num" : "<%= num %>"},
			success : function(result){
				$('div#commentBody').html(result);
			},
			error : function(request, status, error){
				alert("에러!");
			}
		}); 
	}
	
			
	// 댓글 등록하기 
	function comment_submit(){
		
		// 댓글 있는 지 확인 
		var cmt = $("#comments").val();
		if(cmt == "" || cmt == null){
			alert("댓글을 입력하세요.");
			cmt.focus();
			return false;
		}
		
		var formData = $("#comentView").serialize(); 
		
		$.ajax({
			cache:false,
			url: "comment_action.jsp",
			type:"post",
			data:formData,
			dataType:"json", // json으로 받는다.
			success: function(result){
				//alert("일단찍어본다." + result.result);  // 이렇게 하면 값1 나옴 return시 받는거 dataType::"json"으로 해야함	
				init();
				
				// 원래값으로돌려놓기 
				$("#parent_cmt").val("0"); 
				$("#depth").val("1");
				$("#comments").val("");
			},
			error : function(request, status, error){
				alert("에러..1 : " + request + "에러..2 : " +  status + "에러..3 : " + error);
			}
		});
	}
	
	// 댓글 삭제 
	function deleteCmt(comment_no, sort){
		
		let con = confirm("댓글을 삭제하겠습니까?");
		if(con){
			$.ajax({
				type:"post",
				url: "comment_action.jsp",
				data: "cmt_no=" + comment_no + "&sort=" + sort,
				dataType : 'json',
				success : function(result){
					alert("돌아온값확인!: " + result);
					init(); // 다시 commentList 부름 
				},error : function(msg){
					alert("에러! ::" + msg);
				}
			});
		}
	
		/*if(con){
			var param = "cmt_no=" + comment_no;
			
			httpRequest = getXMLHttpRequest();
			httpRequest.onreadystatechange = checkFunc;
			httpRequest.open("POST", "comment_action.jsp", true);
			httpRequest.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded;charset=EUC-KR');
			httpRequest.send(param);
		}*/
		
	}
	
	// 댓글 수정 (나중에 합치기 -삭제랑 )
	function updeteCmt(comment_no, sort){
		
		//alert("찍어본다 ++ " + comment_no + sort );
		let comments = $('#updateComment_' + comment_no).val(); //  수정된 내용 갖고오기 
		//alert("하하하하하 : " + comments);
	    if(!comments){
            alert("내용을 입력하세요!");
            return false;
        }else{
			let con = confirm("댓글을 수정하겠습니까?");
			if(con){
				$.ajax({
					type:"post",
					url: "comment_action.jsp",
					data: "cmt_no=" + comment_no + "&sort=" + sort + "&comments=" + comments,
					dataType : 'json',
					success : function(result){
						//alert("돌아온값확인!: " + result);
						init(); // 다시 commentList 부름 
					},error : function(msg){
						alert("에러! ::" + msg);
					}
				});
			}
        }
	}
	
	// 게시글 삭제
	function delChk(){
		
		var gubn = '<%= mem_gubun %>';
		if(gubn == 'admin'){
			
			 document.getElementById("sort").value = 'd';
			 var theForm = document.writeFrm;
			 
			 var con = confirm("게시글을 삭제하겠습니까?");
			 if(con){
				 theForm.action = "iud_action.jsp"; // form action 변경
				 document.writeFrm.submit();
				 theForm.submit();
		     }else{ return false; }
		}
		else{
			alert("사용자는 삭제가 불가능합니다.");
			return false;
		}
		
	}
		
	// 게시글 수정이동
	function upChk(){
		var gubn = '<%= mem_gubun %>';
		if(gubn == 'admin'){
			//document.getElementById("sort").value = 'u'; // modifyBoard.jsp로 가져갈 값
			//document.writeFrm.submit(); // 수정 값 넘기기
			location.href="modifyBoard.jsp?pg=<%= pg %>&searchType=<%= searchType %>&keyword=<%= keyword %>&num=<%=num%>";
		}else{
			alert("사용자는 수정이 불가능합니다.");
			return false;
		}
	}

	
	
</script>

<title>게시글 상세보기</title>
</head>
<body>

	<div id="ui_page">
	
		<%@ include file="../inc/common.jsp" %>
	
		<form name="writeFrm" method="get" action="modifyBoard.jsp" onsubmit="return false;">
		
			<!-- 보낼값 -->
			<input type="hidden" name="pg" value="<%= pg %>" />
			<input type="hidden" name="searchType" value="<%= searchType %>"/>
			<input type="hidden" name="keyword" value="<%= keyword %>" />
			<input type="hidden" name="num" value="<%= return_num %>" />
			<input type="hidden" name="sort" value="" id="sort" />			
			<!-- <input type="hidden" name="uploadFile" value="" />		 -->
			
			<%-- <input type="hidden" name="id" value="<%= mem_id %>" /> <!-- id 넘긴다. -->
			<input type="hidden" name="gubn" value="<%= mem_gubun %>" /> <!-- 사용자/관리자 구분 값 넘긴다. --> --%>
			
		   <table class="boardtb">
		   	 <tr>
		         <th>제목</th>
		         <td style="width:50%;"><%= return_title  %></td>
		         <th>조회수</th>
		         <td><%= return_view_cnt.equals("null")? "0" : return_view_cnt %></td>
		      </tr>
		      <tr>
		         <th>ID</th>
		         <td><%= return_id == null? "id없음!!!!" : return_id  %></td> <!-- 일단 보여지는건 저장되어있는 걸로 보여야함. -->
		         <th>작성자</th>
		         <td><%= return_name  %></td> <!-- 일단 보여지는건 저장되어있는 걸로 보여야함. -->
		      </tr>
		      <tr>
		      	<th>num</th>
		      	<td><%= return_num %></td>
		      	<th>작성일</th>
		        <td><%= return_reg_date %></td>
		      </tr>
		      <tr>
		         <th>내용</th>
		         <td colspan="4" style="height:300px; text-align:left; padding-left:10px;"><%= return_contents  %></td>
		      </tr>
		      <tr>
		         <th>저장된 파일</th>
		         <td colspan="4" style="text-align:left; padding-left:10px;">
			         <%
				         if(fileReturn != null || fileReturn.size() != 0){
				        	 
				        	 for(int i=0; i<fileReturn.size(); i++){
				        		 String file_name = fileReturn.get(i).get("UPLOAD_NAME").toString() == null? "" : fileReturn.get(i).get("UPLOAD_NAME").toString();
				        		 String save_name = fileReturn.get(i).get("SAVE_NAME").toString() == null? "" : fileReturn.get(i).get("SAVE_NAME").toString();
				     %>
					         	<span><%-- <img src="./fileBox/<%= save_name %>"/> --%><%= file_name %></span>
					         	<a href="#" onclick="location.href = './fileDown.jsp?fileName=<%= save_name %>&uploadName=<%= file_name %>'">파일 다운받기</a><br>
				     <%	 	} 
		        	 	}
				        if(fileReturn.size() <= 0){ 
			         %>
				     		<span>저장된 파일 없음!</span>
				     <%	} %>
		         </td>
		      </tr>
		   </table>
	   </form>
	   
	   
		<!-- comment 댓글보기/ 리스트 들어갈 곳  -->
		<div id="commentBody" style="padding-top:20px; padding-bottom:20px;"></div>
	
	
	   <!-- 댓글 추가하기 -->
	   <h4>Leave a Coment:</h4> 
	   
	   <form name="comentView" id="comentView" method="post" action="javascript:comment_submit();">
			
			<input type="hidden" name="id" value="<%= mem_id  %>" /> <!-- 작성자ID / 세션(log_chk.jsp)에서 가지고온다.  -->
			<input type="hidden" name="parent_board" value="<%=num %>" />  <!-- 게시판 번호가져옴 -->
			<input type="hidden" id="parent_cmt" name="parent_cmt" value="0"/>
			<input type="hidden" id="depth" name="depth" value="1" />				
			<input type="text" name="comments" id="comments" placeholder="댓글을 입력하세요!" style="width:70%;">
			
			<button type="submit">등록하기</button>
		</form>


   	   <!-- 보인 아이디랑 일치할 경우 수정/삭제 버튼 보이게 아닌경우 안보이게 한다. -->
	   <div>
	   	   <% if((mem_gubun !=null &&mem_gubun.equals("admin")) || (return_id != null && return_id.equals(mem_id))){  %>
	   	   
		   <input type="button" value="수정" class="fr" onclick="javascript:upChk();"/>
		   <input type="button" value="삭제" class="fr" onclick="javascript:delChk();" />
	   	   
	   	   <% } %>

	   	   <input type="button" value="목록" class="fr" onclick="location.href='board_list.jsp?pg=<%=pg%>&searchType=<%=searchType%>&keyword=<%=keyword%>'"/>
	   </div>
	   
		
	</div>

</body>
</html>