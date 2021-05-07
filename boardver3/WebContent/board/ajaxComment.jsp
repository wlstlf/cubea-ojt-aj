<%@page import="boardver3.dao.CommonDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 한글 안깨지게 처리 & 로그인 세션처리  -->
<!-- 얘는 ajax로 불러오는 페이지라서 따로 컴파일된다. -->
<%@ include file="../inc/login_chk.jsp" %>


<%
	// 먼저 보드넘버에 맞는 댓글 여부 select 
	String temp = request.getParameter("board_num");
	int board_num = Integer.parseInt(temp);

	// 맵으로 넣고 
	Map<String, Object> input = new HashMap<String,Object>();
	input.put("board_num",board_num);
	
	List<Map<String,Object>> list = dao.select_List("Board.selectComment",input);
	
	// 댓글숫자도 가지고옴 
	int cmtCount = dao.select_One("Board.commentCount", input);
	
%>


<h4>댓글보기 총 댓글수: <%= cmtCount %></h4> 
<table style="border-collapse:collapse">
 
 	<%  // 리스트 뿌리기 
 		if(list.size() == 0){   // 댓글이 없는 경우 
 	%>
 		<tr><td colspan="6">등록된 댓글이 없습니다.</td></tr>
 		
 	<%		
 		}else{   				// 댓글이 있는 경우 
 			
  		for(int i=0; i<list.size(); i++){
			Map<String,Object> map = list.get(i);
			int parent_cmt = Integer.parseInt(map.get("PARENT_CMT").toString()); // 오라클 에러나서 뒤에.toString() 붙여서 처리함.
 	%>
  		<tr>
  		<% if(parent_cmt != 0){ %> <!-- 댓글 이미지 넣기 -->
  			<td><img src="../res/img/re.gif" /> 부모:: <%= parent_cmt %></td>
  		<%	}else{ %>
  			<td>시퀀스 :: <%= map.get("CMT_NO")%></td>
		<%	} %>	
  			
  			<td>ID:: <%= (String) map.get("ID") %></td>
  			
  			
  			<!-- [댓글 내용] : 수정을 클릭하면 여기가 input 으로 변경 -->
  			<td id="update_cmt_<%=  map.get("CMT_NO") %>">
  				<span id="fade_<%=  map.get("CMT_NO") %>" style="display:"><%= (String) map.get("COMMENTS") %></span>
  			</td>
		
		
		<%  if(map.get("UP_DATE") == null){  // 수정일있으면 수정일, 없으면 작성일 노출 %>
	  			<td>작성일:: <%=  map.get("REG_DATE") %></td>
		<% }else{ %>
	  			<td>수정일:: <%=  map.get("UP_DATE") %></td>
		<% }
		
  			if(map.get("DEPTH") != null && map.get("DEPTH").equals("1")){
		%>
		
			<!-- 처음 열때부터 찬성/반대 수가 있어야하는데 ㅠㅠ 좀더 생각해보기 -->
			<td>  
  				<a href="javascript:cmtAction.rere('<%=  map.get("CMT_NO") %>');" class="comm_re">대댓글달기</a>
				<a href="javascript:cmtAction.opinion('<%=  map.get("CMT_NO") %>','<%= mem_id %>','Y','<%=board_num%>');">
					찬성 :: <span id="agree_<%= map.get("CMT_NO") %>"><%= map.get("CAN_CNT") %></span>
				</a> <!-- 일단 숫자가 나와야하고 , 클릭하면 숫자 +1, 반대 하면 -1  -->
				<a href="javascript:cmtAction.opinion('<%=  map.get("CMT_NO") %>','<%= mem_id %>','N','<%=board_num%>');">
					반대 :: <span id="oppo_<%= map.get("CMT_NO") %>"><%= map.get("BAN_CNT") %></span>
				</a> <!-- 일단 숫자가 나와야하고 , 클릭하면 숫자 +1, 반대 하면 -1  -->
			</td> 

		<% }
  			
  			if(mem_id.equals((String)map.get("ID"))){ // 아이디가 동일할때 
		%>
			<td>
  				<input type="button" id="u_botton_<%=  map.get("CMT_NO") %>" value="수정" onclick="javascript:cmtAction.updateCmt('<%=  map.get("CMT_NO") %>');"/>
  				<input type="button" id="d_botton_<%=  map.get("CMT_NO") %>" value="삭제" onclick="javascript:deleteCmt('<%=  map.get("CMT_NO") %>','D');"/> 
  			</td>
  		<%				
  			}
		%>
  			
  		</tr>
  		
  		<!-- 글마다 댓글에 고유한 번호를 넣음! 그래야 한칸씩마다 대댓글창 넣을 수 있음 -->
  		<tr id="re_comm_<%=  map.get("CMT_NO") %>" style="display:none;"> 
  			<td colspan="6" style="text-align:left;">  <!-- 보낼 값 name 설정해야함 -->
  			   <img src="../res/img/re.gif" />
  			   <span>작성자 :: <%= mem_id %></span> <!-- DB 리턴값이 아니라 로그인한 사람의 ID가 들어가야함. -->
  			   
  			   <input type="hidden" name="parent_cmt" id="co_num_<%= map.get("CMT_NO") %>" value=""/> 
  			   <!-- board_no은 for문안에서 동일하지만 / cmt_no는 계속 바뀐다. --> 
  			   <input type="text" name="re_comment"  id="re_comment_<%= map.get("CMT_NO") %>"  placeholder="대댓글을 입력하세요!"/>
			   <input type="button" value="등록" onclick="cmtAction.comment_save($('#re_comment_' + <%=  map.get("CMT_NO") %>).val(), $('#co_num_' + <%= map.get("CMT_NO") %>).val());"/>
			   <input type="button" value="취소" onclick="javascript:cmtAction.rere('<%=  map.get("CMT_NO") %>');" /> 
  			</td>
  		</tr>
<%
		}
	}
%>
 		
 </table>	


