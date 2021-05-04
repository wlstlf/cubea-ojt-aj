<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardver3.dao.Encryption" %>
<%@ page import="boardver3.common.CommonUtil" %>
<%@ page import="boardver3.dao.CommonDAO" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>


<%

	request.setCharacterEncoding("UTF-8");
	CommonUtil common = CommonUtil.getInstance(); // 유틸 선언 

	String id = request.getParameter("id") == null?"":request.getParameter("id");
	String pwd = request.getParameter("pwd")==null?"":request.getParameter("pwd");
	
	if(id.equals("") || pwd.equals("")){  		  // id 또는 pwd가 null이면 (앞에서 했어도 뒤에서도 null체크 해야함.)
		out.print(common.jsAlertUrl("입력값 없음!", "login.jsp"));
		return;
	}
	
	CommonDAO dao = CommonDAO.getInstance();
	
	// 담을 객체 선언 
	Map<String, Object> map = new HashMap<String, Object>(); // map으로 돌려받을 값
	
	
	/* 로그인 정보처리 
	(1) id로 count 체크 -> 1개보다 크면 -> 
 	(2) 받은 비밀번호 암호화 시키기 -> 
	(3) id랑 암호화된 pwd 로 where로 입력값 찾기 -> * 말고 필요한 컬럼들로만 가지고 온다. */	
 	
	// (1) 
	Map<String, Object> input = new HashMap<String,Object>();
    input.put("id", id);
    int result = dao.select_One("Member.idCheck",input);
	String input_pwd = "";			 
				 
	if(result == 0) {
		out.print(common.jsAlertUrl("회원 정보가 없습니다.", "login.jsp"));
		return;   // JSP에서 return 은 자바 코드를 아래 더 이상 읽지 않는다는! 
	}
	
	System.out.println("result: id 카운트 체크 " + result);
	
	// (2) 받아온 패스워드를 해싱 처리 
	byte[] temp = pwd.getBytes();
	Encryption encrypt = new Encryption();
	input_pwd = encrypt.get_pwd(temp); // 암호화를 시킨다.
	
	//(3) id + 암호화 pwd로 검색 
	input.put("pwd", input_pwd);
	
	// DB 조회 
	map = dao.select_Row("Member.login",input);   
	
	// id+pwd 조건 두개로 넣었는데 값이 없다면 비밀번호가 틀린것 
	if(map == null || map.isEmpty()){
		out.print(common.jsAlertUrl("비밀번호가 달라요!", "login.jsp"));
		return;
	}
	
	// 세션 저장 
	HttpSession sessionAJ = request.getSession();   // 맵퍼에서 resultMap 없이 그냥 Map으로 받을 경우 대문자로 받아야 된다. 
	session.setAttribute("memberInfo", map); // 가져온걸 그냥 memberInfo로 넣어버림.
		
	// 세션 유효기간 설정 - 12시간 - 요청으로 딱히 정해진게 없다면 하지 않는다.
	// sessionAJ.setMaxInactiveInterval(12*60*60);
	out.print(common.jsAlertUrl("로그인 성공!", "../board/board_list.jsp"));

%>

