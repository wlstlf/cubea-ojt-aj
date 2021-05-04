<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="boardver3.dao.CommonDAO" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>


<!-- 한글 안깨지게 처리 & 로그인 세션처리  -->
<%@ include file="../inc/login_chk.jsp" %>


<%
	// 미리 gubn 값 확인 
	if(mem_gubun.equals("user")){
		out.println(common.jsAlertUrl("User는 수정이 불가합니다.", "javascript:window.history.back();")); 
	}

	int tt =0;
	System.out.println(tt);
	tt++;
	System.out.println(tt);

	// 바로 수정하는건 쿠키 사용 X 
	String temp = request.getParameter("num") == null ? "" : request.getParameter("num");
	int num = 0;
	
	// 사용 변수 선언
	String pg = request.getParameter("pg")  == null ? "0" : request.getParameter("pg");
	String searchType = request.getParameter("searchType")  == null ? "" : request.getParameter("searchType"); 
	String keyword = request.getParameter("keyword")  == null ? "" : request.getParameter("keyword");

	// 리턴 map, 변수
	Map<String,Object> map = new HashMap<String,Object>();
	List<Map<String,Object>> fileReturn = new ArrayList<Map<String,Object>>();
	String return_view_cnt = "";
	String return_title = "";
	String content = "";
	
	if(temp.equals("")){ // ----------------1. 등록처리
		temp = "0";
		num = Integer.parseInt(temp); // 특수문자포함시 없애기 수정
		out.println(common.jsAlertUrl("신규등록으로 진행됩니다.", "javascript:")); 
		
	}else{  // -----------------2. 수정 처리 
		
		num = common.stringToint(temp); // 특수문자포함시 없애기 수정 
		map = dao.select_Row("Board.selectOne", num); 
		
		if(map == null || map.size() == 0){
			out.println(common.jsAlertUrl("없는 num 값입니다.", "javascript:window.history.back();")); 
		} 
		
		if(map != null){   
			return_view_cnt = String.valueOf(map.get("VIEW_CNT")==null?"0":map.get("VIEW_CNT"));
			return_title = String.valueOf(map.get("TITLE")==null?"":map.get("TITLE"));  // date 타입이라서 String 변환 
			content = (String)(map.get("CONTENTS")==null?"":map.get("CONTENTS")); 
	     	content = content.replace("<br>", "\r\n");  //  개행처리 반대로
		}
		
		
		// 파일도 가져오기 (여러개일 수 있다.)
		Map<String,Object> input = new HashMap<String,Object>();
		input.put("num", num);
		fileReturn = dao.select_List("Board.selectFile", input); // 게시판번호로 파일들 가지고오기 
	}
	
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css" href="../res/css/board.css" />
<!-- <link rel="shortcut icon" href="#"> favicon 404 없애기  --><!-- 이거때문에 페이지 2번 로드했음. -->

<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
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
				document.writeFrm.submit(); 
		     }
		} 
		/* if(data == 'd'){
			var con = confirm("게시글을 삭제하겠습니까?");
			 if(con){
				document.getElementById("sort").value = "d";
				document.writeFrm.submit(); 
		     }
		}  */
	}
	
	
	// 파일 미리보기 (1개 이상되면 안되니깐 잠시 안녕..)
	/*
		FileReader() 객체를 통해서 readAsDataURL(파일객체)를 통해 FileReader 객체를 해당 파일객체로 물려두고 
		onload()시 읽어 들인 데이터의 result로 업로드 되기 전에 파일을 미리 읽어 들일 수 있다.
		==> 여러개일 때는 반복문을 돌리면서 처리하면된다.
	*/
/*   	$(function() {
       $("#uploadFile").on('change', function(){
          readURL(this);
       });
     });
    function readURL(input) {
        if (input.files && input.files[0]) {
        var reader = new FileReader();  // files 메서드는 배열로 반환되기 때문에 멀티파일도 처리가 가능하다고 함.

        	reader.onload = function (e) {
                $('#preview').attr('src', e.target.result);
            }
          reader.readAsDataURL(input.files[0]);
        }
     } */
    
     
    // 파일 추가 
	function addFile(){
		var leng = $("#addFileTd").children().length;
		var this_leng = leng + 1;
		
		var str = "";
		str = str + "<div>";
		str = str + "<input type=\"file\" name=\"uploadFile"+ this_leng +"\">";
		str = str + "<button type=\"button\" onclick=\"delFileRow(this);\">삭제</button>";
		str = str + "</div>";
		$("#addFileTd").append(str);
	}
   
    // 파일 추가 태그 삭제 
	function delFileRow(thisobj){
    	var length = $("#addFileTd > div").length; // size() -> length로 바뀜 (버전변경)
		//alert(length + ":::::::::" + thisobj);
		
		if(length > "1"){
			//var pare = $(thisobj).parents(".file_div"); 
			var pare = $(thisobj).closest("div");
			$(pare).remove();
		}else return false;
	}

    
    // 파일 삭제(UI에서)
    function deleteFile(thisobj){
    	alert(thisobj);
    	var ttt = thisobj.closest("div");
    	$(ttt).remove();
    }

</script>



<title>게시글 수정/등록</title>
</head>
<body>
	
	<div id="ui_page" class="board">
	
		<%@ include file="../inc/common.jsp" %>
		
		<form name="writeFrm" method="post" action="iud_action.jsp" enctype="multipart/form-data" onSubmit="return false;">
		    
		    <input type="hidden" name="sort" value="" id="sort" />
		   	<input type="hidden" name="pg" value="<%= pg %>" />
			<input type="hidden" name="searchType" value="<%= searchType %>"/>
			<input type="hidden" name="keyword" value="<%= keyword %>" />
			<input type="hidden" name="num" value="<%= num %>" />
			
			<%-- <input type="hidden" name="id" value="<%= mem_id %>" /> <!-- id 넘긴다. -->
			<input type="hidden" name="gubn" value="<%= mem_gubun %>" /> <!-- 사용자/관리자 구분 값 넘긴다. --> --%>
		
		
		   	<table class="boardtb">
			   	 <tr>
			         <th>제목</th>
			         <td colspan="4"><input type="text" name="title" value="<%= return_title %>"/></td>
			      </tr>
			      <tr>
			         <th>작성자</th>
			         <td colspan="4"><input type="text" name="name" value="<%= mem_name %>" readonly/> id 확인 : <%= mem_id %></td>
			      </tr>
			     
			     <% if(num != 0){  %>
				     <tr>
				      	<th>num</th>
				      	<td colspan="4"><input type="text" value="<%= num %>" readonly/> 조회수 : <%= return_view_cnt %></td>
				      </tr>
			     <% } %>
			     
			      <tr>
			         <th>내용</th>
			         <td colspan="4" style="height:300px; text-align:left; padding-left:10px;">
			         	<textarea name="contents"><%= content %></textarea>
		         	</td>
			      </tr>
			      
			      <!-- 등록된 파일 -->
			      <tr>
			         <th>저장된 파일</th>
			         <td colspan="4" style="text-align:left; padding-left:10px;" id="savedFile">
				       <%
					         if(fileReturn != null || fileReturn.size() != 0){
					        	 
					        	 for(int i=0; i<fileReturn.size(); i++){
					        		 String file_name = fileReturn.get(i).get("UPLOAD_NAME").toString() == null? "" : fileReturn.get(i).get("UPLOAD_NAME").toString();
					        		 String save_name = fileReturn.get(i).get("SAVE_NAME").toString() == null? "" : fileReturn.get(i).get("SAVE_NAME").toString();
					     %>
						         	<div class="saveFile_div">
							         	<span><img src="./fileBox/<%= save_name %>"/><%= file_name %></span>
							         	<button type="button" onclick="deleteFile(this);">X</button>
							         	<input type="hidden" name="alreadyFile_<%= i %>" value="<%= save_name %>" />
									</div>
					     <%	 	} 
			        	 	}
					        if(fileReturn.size() <= 0){ 
				         %>
					     		<span>저장된 파일 없음!</span>
					     <%	} %>
			         </td>
		      	 </tr>
			      
			     <!-- 파일 업로드  -->
			     <tr>
			    	<th>파일 업로드 ::<button type="button" onclick="addFile();">추가+</button></th>
			      		<td id="addFileTd" style="text-align:left;">
			      			<!-- 파일이름:  <input type="text" name="fileTitle" id="fileTitle"> -->
			      			<div class="file_div">
			      				<input type="file" name="uploadFile1">
		      					<button type="button" onclick="delFileRow(this);">삭제</button>
		      				</div>
			      			<!-- <input type="file" name="uploadFile" id="uploadFile" value=""> -->
		      			</td>
			      </tr>
			      
			   <!-- 
			   <tr>
		      		<th>미리보기</th>
		      		<td>
		      			<img id="preview" src="./fileBox/" alt="" width="300" height="300" />
	      			</td>
			      </tr>  
		      -->
			      
		   </table>
		   
	   </form>	
		   
		    <% if(num ==0) {  %>
		    
	   			<input type="button" value="등록"  class="fr" onclick="javascript:writeChk('i');"/>
	   		
	   		<% } else if(num !=0){ %>	
	   		
	   		 	 <input type="button" value="수정"  class="fr" onclick="javascript:updateAction('u');"/>
	   		 	 <!-- <input type="button" value="삭제"  class="boardteam" onclick="javascript:updateAction('d');"/> -->
	   		 	 <input type="button" value="취소"  class="fr" onclick="javascript:window.history.back();"/>
	   		
	   		<% } %>
	   		
		   		<input type="button" value="목록" class="fr" onclick="location.href='board_list.jsp?pg=<%= pg %>&searchType=<%=searchType%>&keyword=<%=keyword%>'"/>
	</div>
	
</body>
</html>