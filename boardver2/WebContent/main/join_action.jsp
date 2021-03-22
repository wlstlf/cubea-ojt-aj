<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- <%@ page import="boardver2.dao.MemberDAO" %>
<%@ page import="boardver2.dto.MemberDTO" %> --%>
<%@ page import="boardver2.dao.Encryption" %>
<%@ page import="boardver2.common.CommonUtil" %>
<%@ page import="boardver2.dao.CommonDAO" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

   
   
<!-- <!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"> -->


<%
	request.setCharacterEncoding("UTF-8");

	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	String tel1 = request.getParameter("tel1");
	String tel2 = request.getParameter("tel2");
	String tel3 = request.getParameter("tel3");
	String gubun = request.getParameter("gubun"); 
	
	//MemberDAO dao = MemberDAO.getInstance();
	CommonDAO dao = CommonDAO.getInstance();

	int result = 0;
	
	// 등록할 값 보낼 객체 선언 
	//MemberDTO dto = new MemberDTO();
	Map<String,Object> map = new HashMap<String,Object>();
	
	// 비밀번호는 암호화 시켜서 보냄 
	byte[] temp = pwd.getBytes();
	Encryption encrypt = new Encryption();
	String temp2 = encrypt.set_Pwd(temp); // 암호화 시킨다.
	//dto.setPwd(temp2); // 암호화된게 들어가겠지?
	map.put("pwd", temp2);
			
	// 나머지
	/* dto.setId(id);
	dto.setName(name);
	dto.setEmail(email);
	dto.setTel1(tel1);
	dto.setTel2(tel2);
	dto.setTel3(tel3);
	dto.setGubun(gubun); */
	
	map.put("id", id);
	map.put("name", name);
	map.put("email", email);
	map.put("tel1", tel1);
	map.put("tel2", tel2);
	map.put("tel3", tel3);
	map.put("gubun", gubun);
	
	
	// insert 회원처리 
	//result = dao.insertMember(dto);
	result = dao.insert_Data("Member.insertMember", map);
	
	CommonUtil common = new CommonUtil();
	if(result != 0 ){  // js-> common 유틸로 수정 
		out.println(common.jsAlertUrl("회원가입이 완료되었습니다.", "login.jsp"));
	}else{
		out.println(common.jsAlertUrl("회원가입 실패!!", "login.jsp"));
	}

%>
	<!-- <script type="text/javascript">
	   alert("회원가입이 완료되었습니다.");
	   location.href="login.jsp";  
	</script> -->

	<!--<script type="text/javascript">
       alert("회원가입 실패!!" );    
       location.href="login.jsp";
	</script>	 -->





</head>
</html>