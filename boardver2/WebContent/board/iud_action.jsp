<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="boardver2.dao.BoardDAO" %>
<%@ page import="boardver2.dto.BoardDTO" %> --%>
<%@ page import="boardver2.common.CommonUtil" %>
<%@ page import="boardver2.dao.CommonDAO" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>


<!-- 한글 안깨지게 처리 & 로그인 세션처리  -->
<%@ include file="../inc/common.jsp" %>

<%-- <jsp:useBean id="dto" class="boardver1.dto.BoardDTO" />
<jsp:setProperty name="dto" property="*" />  --%>
<!-- useBean 값 담아가는거 : 인코딩 에러나서 X  -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">


<%
	request.setCharacterEncoding("UTF-8");
	String title = request.getParameter("title");
	String name = request.getParameter("name");
	String contents = request.getParameter("contents"); 
	//String img_path = request.getParameter("img_path") == null?"": request.getParameter("img_path");
	String id = request.getParameter("id");  // id 값 
	int num = Integer.parseInt(request.getParameter("num")); // 뷰에서 넘어오는값 (1)
	
	// 뷰에서 넘어오는값 (2)- 페이징 
	String pg = request.getParameter("pg");
	String searchType  = request.getParameter("searchType"); 
	String keyword  = request.getParameter("keyword");

	// Insert : i 
	// Update : u
	// delete : d 
	String sort = request.getParameter("sort"); // 뷰에서 넘어오는값 (3)

	//CommonUtil common = new CommonUtil(); // 공용 util 생성!
	//BoardDAO dao = BoardDAO.getInstance();
	CommonDAO dao = CommonDAO.getInstance();
	
	int result = 0;
	String message = "";
	String url = "";
	
	// 담을 객체 선언
	//BoardDTO dto = new BoardDTO();
	Map<String,Object> map = new HashMap<String,Object>();
	
	/* dto.setNum(num);
	if(sort.equals("u") || sort.equals("i")){
		dto.setId(id); // 등록시에만 쓴다.
		dto.setName(name);
		dto.setTitle(title);
		dto.setContents(contents.replace("\r\n", "<br>"));  // 개행처리
	} */
	map.put("num", num);
	if(sort.equals("u") || sort.equals("i")){
		map.put("id", id);
		map.put("name", name);
		map.put("title", title);
		map.put("contents", contents.replace("\r\n", "<br>"));
	}
	
	 
	if(sort.equals("i")){
		//result = dao.insertData(dto); // 여기 result는 maxNum임
		result = dao.insert_Data("Board.insertData", map);
		message = "등록이";
		url = "boardView.jsp?num=" + result + "&pg=" + pg + "&searchType=" + searchType + "&keyword=" + keyword; // 등록 된 뷰페이지로 이동
		
	}else if(sort.equals("d")){
		//result = dao.deleteData(dto);
		result = dao.delete_Data("Board.deleteData", map);
		message = "삭제가";
		url = "board_list.jsp?pg=" + pg + "&searchType=" + searchType + "&keyword=" + keyword; // 보던 페이지로 이동 
		
	}else if(sort.equals("u")){
		//result = dao.updateData(dto);
		result = dao.update_Data("Board.updateData", map);
		message = "수정이";
		url = "boardView.jsp?num=" + num + "&pg=" + pg + "&searchType=" + searchType + "&keyword=" + keyword; // 보고있던 뷰페이지로 이동
		
	}else{
		System.out.println("sort 확인불가");
	}
	
	if(result != 0){
		
		out.println(common.jsAlertUrl("게시글 "+ message + " 완료되었습니다.", url));

	}else{
		out.println(common.jsAlertUrl("게시글 "+ message + " 실패!  result : ", url));
	}
	
%>

	<%-- 
	<script type="text/javascript">
	   alert("게시글 " + "<%=message%>" + " 완료되었습니다.");
	   location.href="<%=url%>";
	</script>


	<script type="text/javascript">
       alert("게시글 " + "<%=message%>" + " 실패!  result : " + "<%=result%>" );
       location.href="<%=url%>";
	</script>	 
	--%>

</head>
</html>
