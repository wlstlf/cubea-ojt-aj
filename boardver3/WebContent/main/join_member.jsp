<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
	
	
	function idDupchk(){
		var id = document.getElementById("id");
		if(id.value == ""){
			alert("아이디를 입력해 주세요!");
			joinFrm.id.focus();
		}else{  // 중복확인전에도 id 한번더 체크 
			var id_regular = /^[a-zA-Z0-9]{6,12}$/; 
			if(!chk(id_regular,id,"아이디는 6~12자의 영문 대소문자와 숫자로만 입력")) {
	            return false;
	        }else{
				idChkFunc();
	        }
		}
	}
	
/* 	function idChkFunc(id){ // html 
		alert("idChkFunc 타는지 체크!");
		$.ajax({
			type:"get",
			url: "id_check.jsp?id="+id.value,
			dataType:'text',
			success:function(result){
				if(result == 0){
					document.getElementById("ck").innerText="사용가능 아이디";
					document.getElementById("ck").style.color="green";
					document.getElementById("idChk").value='Y'; // id check 변경
				}else{
					document.getElementById("ck").innerText="사용 불가능한 아이디입니다.";
					document.getElementById("ck").style.color="red";
					document.getElementById("id").value= "";
					joinFrm.id.focus();
				}
			}, error : function(){
				alert("에러났다!");
			}
		});
	} */
	
	
	function idChkFunc(){ // json - lib > gson-2.8.6.jar 추가 
		//alert("idChkFunc 타는지 체크!");
	
		query ={id:document.getElementById("id").value}
		$.ajax({
			type:"post",
			url: "id_check.jsp",
			data: query,
			success:function(data){
				obj = JSON.parse(data);  // json 객체로 받는다
				if(obj.result == 0){
					document.getElementById("ck").innerText="사용가능 아이디";
					document.getElementById("ck").style.color="green";
					document.getElementById("idChk").value='Y'; // id check 변경
				}else{
					document.getElementById("ck").innerText="사용 불가능한 아이디입니다.";
					document.getElementById("ck").style.color="red";
					document.getElementById("id").value= "";
					document.getElementById("idChk").value='N'; // 불가능한 아이디시 다시 N으로 수정
					joinFrm.id.focus();
				}
			}, error : function(){
				alert("에러났다!");
			}
		});
	}
	
	
	// 유효성 검사
	function validate(){
		
		 var id_regular = /^[a-zA-Z0-9]{6,12}$/;   
		 var pwd_regular = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z0-9\d!@#$%^&*]{10,15}$/;   
         var email_regular = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
         var tel_regular = /^[0-9]*$/;  // 숫자만 입력가능 
         
         /*
         	정규표현식(Regular Expression)이다.
			→ / : 자바스크립트의 정규표현식의 처음과 끝을 의미한다.
			→ [] : 문자셋이다. 예를 들면 [a-z]라고 적을경우 정규표현식에 만족해야하는 값들은 반드시 a~z사이의 값만 넣을 수 있다. || [^] : 문자셋 부정, 괄호안의 문자가 아닐때
			→ ^ : 문장의 시작. ||  $ : 문장의 끝
			→ {} : 문자열 길이를 뜻한다. 예를 들어 {4,12}일 경우 최소 길이 4, 최대 길이 12이다. || {n} 일경우는 n번 반복을 의미 
			→ () : 꼭 포함되어야하는 기호 
			→ \d : 10진수문자 0~9까지의 문자그룹 [0-9]와 동일한 역할을 하는 단축어  ||  \D : 는 역집합으로 숫자가 아닌 것만 찾는 역할
			→ \s : space 공백 ||  \S : space 공백 아님
			→ ? : 있거나 없거나 (Zero or one)  || * : 없거나 있거나 많거나 (Zero or more) || + : 하나 또는 많이 (one or more) 
         */
         
         var id = document.getElementById("id");
		 var idChk = document.getElementById("idChk");
         var pwd = document.getElementById("pwd");
         var pwd2 = document.getElementById("pwd2");
         var email = document.getElementById("email"); 
 	 /*  var tel1 = document.getElementById("tel1");  	// 일단 없어도 회원가입 가능 
         var tel2 = document.getElementById("tel2");
         var tel3 = document.getElementById("tel3");
         
          */
         
         if(!chk(id_regular,id,"아이디는 6~12자의 영문 대소문자와 숫자로만 입력")) {
             return false;
         }
         
         if(idChk.value == 'N'){
        	 alert("아이디 중복체크를 해주세요.");
        	 return false;
         }
         
         if(!chk(pwd_regular,pwd,"패스워드는 10~15자의 영문 대소문자와 숫자로만, 특수문자(1~8번까지 !@#$%^&*) \n - 문자,숫자, 특수문자 꼭 한개씩은 입력되어야합니다.")) {
             return false;
         }

         if(joinFrm.pwd.value != joinFrm.pwd2.value) {
             alert("입력한 확인 비밀번호가 다릅니다. 다시 확인해 주세요.");
             joinFrm.pwd2.value = "";
             joinFrm.pwd2.focus();
             return false;
         }
         
         if(joinFrm.id.value == joinFrm.pwd.value) {
             alert("아이디랑 비밀번호는 같을 수 없습니다.");
             joinFrm.pwd.value = "";
             joinFrm.pwd.focus();
             return false;
         }
         
         if(!chk(email_regular, email, "적합하지 않은 이메일 형식입니다.")) {
             return false;
         }
         
  /*     if(!chk(tel_regular, tel1, "전화번호에는 숫자만 입력 가능합니다.")) {
             return false;
         }
         
         if(!chk(tel_regular, tel2, "전화번호에는 숫자만 입력 가능합니다.")) {
             return false;
         }
         
         if(!chk(tel_regular, tel3, "전화번호에는 숫자만 입력 가능합니다.")) {
             return false;
         } */
         
         // 체크되면 form 전송
         joinFrm.submit();
         
	}
	
	function chk(regular, name, message){ 	// (정규식, input이름, 메시지)
		if(regular.test(name.value)){   	// 정규식에서 사용되는 함수  search() || test() || replace() 
			return true;
		}
		alert(message);
		name.value = "";
		name.focus();
	}
	
	
</script>



<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>

	<h2> 회원가입 </h2>

	<form name="joinFrm" action="./join_action.jsp" method="post" onsubmit="return false"> 
	<!-- onsubmit="return false" : onsubmit 강제막기 -->  
	
		<input type="hidden" name="idChk" id="idChk" value="N">
	
		<table class="logintb">
			<tr>
				<td>아이디 : </td>
				<td colspan="3"><input type="text" name="id" id="id" autofocus required/>  6~12자의 영문 대소문자와 숫자로만 입력(대소문자 구분 X)</td>
			</tr>			
			<tr>
				<td></td>
				<td colspan="3"><input type="button" value="중복확인" name="dupChk" onclick="idDupchk();" /><span id="ck"></span></td>
			</tr>	
			<tr>
				<td>비밀번호 : </td>
				<td colspan="3"><input type="password" name="pwd" id="pwd" required/>  10자~15자의 영문 대소문자와 숫자, 특수문자(대소문자 구분 O)</td>
			</tr>
			<tr>
				<td>비밀번호 확인 : </td>
				<td colspan="3"><input type="password" name="pwd2" id="pwd2" required/>  비밀번호 재확인</td>
			</tr>
			<tr>
				<td>이름 : </td>
				<td colspan="3"><input type="text" name="name" id="name" required/></td>
			</tr>
			<tr>
				<td>이메일 : </td>
				<td colspan="3"><input type="email" name="email"  id="email" required/></td>
			</tr>
			<!-- <tr>
				<td>전화번호 : </td>
				<td>
					<input type="tel" name="tel1" id="tel1" style="width:45px;" />-
					<input type="tel" name="tel2" id="tel2" style="width:45px;" />-
					<input type="tel" name="tel3" id="tel3" style="width:45px;" />
				</td>
			</tr> -->
			<tr>
				<td>권한 : </td>
				<td>
				 	<input type="radio" name="gubun" value="user" checked="checked">
						<label for="user">일반사용자</label> 
					<input type="radio" name="gubun" value="admin">
						<label for="admin">관리자</label> 
				</td>
			</tr>
			<tr>
				<td><input type="button" value="취소" onclick="javascript:history.go(-1);"/></td> <!-- 뒤로가기 -->
				<td><input type="button" value="등록" onclick="validate();" /></td> 
				<!-- 등록 onclick으로 하면 required가 안먹음 -->
			</tr>
		</table>
	
	</form>
	
	
	<!-- 아이디 대문자를 소문자로 변환 -->
	<script type="text/javascript">
	
	    var id = document.getElementById('id');
	    id.addEventListener('keyup', (e) => {
	    	
	    	var upper = id.value;
	    	upper = upper.toLowerCase();
	    	id.value = upper; // 소문자로 변경! 
	    	document.getElementById("ck").innerText="";  // 키업하고나면 다시 값 없애기
	    	document.getElementById("idChk").value='N';  // 키업하고나면 다시 N으로 수정
	   	});
	    
	</script>

</body>
</html>