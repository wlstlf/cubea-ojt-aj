<%@page import="boardver3.dao.CommonDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!-- 한글 안깨지게 처리 & 로그인 세션처리  -->
<%@ include file="../inc/login_chk.jsp" %>

<%
	Map<String,Object> map = new HashMap<String,Object>();

	if(mem_id != null){
		map = dao.select_Row("", mem_id); // 회원정보 갖고오기 
	} 

%>    
    
    
<!DOCTYPE html>
<html>
<head>

<style type="text/css">
	#main_left{background-color:#FCF; width:20%;height:200px; float:left;}
	#main_right{width:40%;height:700px; background-color:#CCF; float:left;}
</style>

<script type="text/javascript">


</script>

<meta charset="UTF-8">
<title>회원 정보 관리</title>
</head>

<body>

	<h2>회원 정보</h2>
	
	<div id="main_left">
		<div><strong>아이디</strong></div>
		<div><strong>이름</strong></div>
	</div>
	
	<div id="main_right">
		<strong>MY 정보</strong>
		<dl style="text-align:center;">
			<dt>id</dt>
			<dd>oooo</dd>
			<dt>name</dt>
			<dd>oooo</dd>
			<dt>pwd 수정</dt>
			<dd>oooo</dd>
			<dt>Email</dt>
			<dd>oooo</dd>
			<dt>생년월일</dt>
			<dd>oooo</dd>
			<dt>등록일</dt>
			<dd>oooo</dd>
		</dl>
	</div>


</body>
</html>