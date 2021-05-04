/**
 * 코멘트 처리 js
 */

const cmtAction = {};  // 객체니깐..
/**
	재할당이 필요한 변수들에는 한정해 let을 사용 (재선언 불가능)
	재할당이 필요없는 상수나 객체에는 const 사용 
	var는 같은 이름으로 선언해서 사용해도 재선언이 가능해, 코드가 길어질경우 중복되어 값이 변할 위험성이 있다. 
 */


	// 답글에 답글달기(대댓글) depth는 2까지만 가능하다.=> 웃대처럼!
	cmtAction.rere = function(conum){ 
			
		// 대댓글란 보이기 
		let obj = document.getElementById('re_comm_' + conum);
		if (obj.style.display == 'none') {
			obj.style.display='table-row';  // <tr>태그가 inline속성이라서 'block'으로 처리시 속성이사라짐.
		} else {  
			obj.style.display='none';
		}
		
		document.getElementById('co_num_' + conum).value = conum;
		document.getElementById('re_comment_' + conum).focus();
	}
		
		
	// 리코멘트(대댓글) 등록하기
	cmtAction.comment_save = function(re_comments, cmt_no){
		alert(re_comments + " :: " + cmt_no);
		
		if(re_comments == "" || re_comments == null){
			alert("내용을 입력하세요.");
		}
		
		if(cmt_no != "" && re_comments != ""){
			// 리코멘트로 수정
			document.getElementById('parent_cmt').value = cmt_no; 
			document.getElementById('depth').value = '2';
			document.getElementById('comments').value = re_comments;
			
			// 코멘트 등록하기로 
			comment_submit();
		}		
	}
	
	// 댓글 수정 
	cmtAction.updateCmt = function(comment_no){
		//window.name="parentForm";
		// 팝업은 쓰면 안됨 => 모바일 같은데서는 사용을 못함.
		/*window.open("commentUpdate.jsp?cmt_no=" + comment_no + "&sort=" + sort,
				"updateForm","width=570, height=350, resizable = no, scrollbars =no");*/
				
		// 댓글 컨텐츠 input 으로 변경하기 
		let obj = document.getElementById('update_cmt_' + comment_no);
		let value = obj.innerText;  // 기존 글은 지우고 
		
		let obj2 = document.getElementById('fade_' + comment_no);
		obj2.style.display = 'none';
		
		// input 태그 만들기
		let updateInput = document.createElement("input");
		updateInput.type = "text";
		updateInput.value = value;
		updateInput.name = "comment_content"; 
		updateInput.id = "updateComment_" + comment_no;  // 아이디를 지정
		obj.appendChild(updateInput);
		updateInput.focus();
		
		// 등록버튼 -> 수정등록으로 수정 
		let btn = document.getElementById('u_botton_' + comment_no);
		btn.value = '수정등록';
		btn.setAttribute("onclick","updeteCmt(" + comment_no + ", 'U');");  // 여기서 sort를 'U'로 밖음
		
		// 삭제버튼-> 취소버튼 수정
		let btn2 = document.getElementById('d_botton_' + comment_no);
		btn2.value = '수정취소';
		btn2.setAttribute("onclick","cmtAction.contentRestore(" + comment_no + ");"); 
	}
	
	
	// 수정취소 
	cmtAction.contentRestore = function(comment_no){
		
		// 기존 값 다시 보이기 
		let obj2 = document.getElementById('fade_' + comment_no);
		obj2.style.display = '';  // 다시 보이게 
		
		// 수정 input 삭제하기 
		let updateobj = document.getElementById('updateComment_' + comment_no);
		updateobj.remove();
		
		// 삭제 버튼 원복 
		let btn2 = document.getElementById('d_botton_' + comment_no);
		btn2.value = '삭제';
		btn2.setAttribute("onclick","javascript:deleteCmt(" + comment_no + ", 'D');"); 
		
		// 수정 버튼 원복 
		let btn = document.getElementById('u_botton_' + comment_no);
		btn.value = '수정';
		btn.setAttribute("onclick","javascript:cmtAction.updateCmt(" + comment_no +");");  // 여기서 sort를 'U'로 밖음
	}
	
	
	// 댓글 (부모만가능) 찬성 / 반대
	cmtAction.opinion = function(comment_no, id, opinion, board_num){
		
		let gubun = "N";
		// 댓글 저장이 되어있는지 미리 한번 탄다. 
		$.ajax({
			async : false, // 안에 ajax또 타야되서 순서대로 하려면 이게 있어야한다규
			type:"post",
			url: "opinion_chk.jsp",
			data: "cmt_no=" + comment_no + "&id=" + id + "&opinion=" + opinion,
			dataType : 'json',
			success : function(result){
				
				if(result.result == "0"){  // json은 단순형 비교, 둘다 의견 없을때 
					cmtAction.opinion2(comment_no, id, opinion, gubun, board_num);  // opinion2를 부른다. gubun = N
				}else if(result.result == "agree"){
					if(opinion == 'Y'){
						alert("이미 찬성을 하셨습니다!" + result.result);
					}else if(opinion == 'N'){ // 찬성값이 있는데 의견이 반대일때!
						gubun = "Y"; // 반대 가능 
						cmtAction.opinion2(comment_no, id, opinion, gubun, board_num);
					}
				}else if(result.result == "oppo"){
					if(opinion == 'N'){
						alert("이미 반대를 하셨습니다!" + result.result);
					}else if(opinion == 'Y'){ // 반대값이 있는데 의견이 찬성일때!
						gubun = "Y"; // 찬성 가능 
						cmtAction.opinion2(comment_no, id, opinion, gubun, board_num);
					}
				}else if(result.result == "error"){
					alert("에러입니다! 안되요!!" + result.result);
				}else{
					alert("이거라도 타야지" + result.result + "오피니언 체크 : " + opinion + "SDFSDF : " + opinion =='N'?true:false);
				}
				
				//alert("타고왔나??" + result.result);
	/*			if(result.result == "0"){  // json은 단순형 비교, 둘다 의견 없을때 
					cmtAction.opinion2(comment_no, id, opinion, gubun);  // opinion2를 부른다. gubun = N
					
				}else if(result.result == "agree" && opinion == 'Y'){
					alert("이미 찬성을 하셨습니다!" + result.result);
					
				}else if(result.result == "oppo" && opinion == 'N'){
					alert("이미 반대를 하셨습니다!" + result.result);
					
				}else if(result.result == "agree" && opinion == 'N'){ 	// 찬성값이 있는데 의견이 반대일때!
					gubun = "Y"; // 반대 가능 
					cmtAction.opinion2(comment_no, id, opinion, gubun);
					
				}else if(result.result == "oppo" && opinion == 'Y'){  	// 반대값이 있는데 의견이 찬성일때!
					gubun = "Y"; // 찬성 가능 
					cmtAction.opinion2(comment_no, id, opinion, gubun);
					
				}else if(result.result == "error"){
					alert("안되요!!" + result.result);
					
				}else{
					alert("이거라도 타야지" + result.result + "오피니언 체크 : " + opinion + "SDFSDF : " + opinion =='N'?true:false);
				}*/
				
			},error : function(msg){
				alert("opinion_chk - ajax 에러! ::" + msg);
			}
		});
	}
	
	
	// 댓글 찬-반 등록, 수정 처리  - opinion1에서 넘어옴
	cmtAction.opinion2 = function(comment_no, id, opinion, gubun, board_num){
		
		$.ajax({
			type:"post",
			url: "opinion_action.jsp",
			data: "cmt_no=" + comment_no + "&id=" + id + "&opinion=" + opinion + "&gubun=" +gubun + "&board_num=" + board_num,
			dataType : 'json',
			success : function(result){
				
				if(result.result == "0"){
					alert("찬/반 처리가 되지 않았습니다!!");						
				}else{
					//값 셋팅
					document.getElementById('agree_' + comment_no).innerText = result.agree;
					document.getElementById('oppo_' + comment_no).innerText = result.oppo;
				}
			},error : function(msg){
				alert("opinion_action - ajax 에러! ::" + msg);
			}
		});
	}
	
	




