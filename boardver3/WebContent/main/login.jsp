<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<script type="text/javascript">
		

	function validate(){
		var id_regular = /^[a-zA-Z0-9]{2,12}$/;
		var id = document.getElementById("id");
		if(!chk(id_regular,id,"아이디는 6~12자의 영문 대소문자와 숫자로만 입력 \n스페이스도 입력금지")) {
	           return false;
	    }
		
		// 체크되면 form 전송
        loginFrm.action = "login_action.jsp";
        loginFrm.submit();
	}
	
	function chk(regular, name, message){
		if(regular.test(name.value)){
			return true;
		}
		alert(message);
		name.value = "";
		name.focus();
	}
</script>

<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>

	<form name="loginFrm" action="" method="post" onsubmit="return validate();" > 
	
		<h2>로그인 하세요.</h2>
		<table>
			<tr>
				<td>아이디 : </td>
				<td><input type="text" name="id" placeholder="아이디를 입력하세요" id="id" autofocus required/></td>
			</tr>			
			<tr>
				<td>비밀번호 : </td>
				<td><input type="password" name="pwd" placeholder="비밀번호를 입력하세요" required/></td>
			</tr>
			<tr style="padding-top:10px;">
				<!-- <td>아이디저장 <input type="checkbox"/></td> -->
				<td style="padding-top:30px;"><input type="submit" value="로그인"/></td>
				<td style="padding-top:30px;"><input type="button" value="회원가입" onClick="location.href='join_member.jsp'"/></td>
			</tr>
		</table>
	
	</form>


	<!-- 아이디 대문자로 변환 -->
	<script type="text/javascript">
	
	    var id = document.getElementById('id');
	    id.addEventListener('keyup', () => {
	    	var upper = id.value;
	    	upper = upper.toLowerCase();
	    	id.value = upper; // 소문자로 변경! 
	   	});
		
	</script>

</body>
</html>