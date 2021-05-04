<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="boardver3.common.ValidationCheck"%>
<%@page import="boardver3.common.CommonUtil"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Enumeration"%>
<%@ page import="boardver3.dao.CommonDAO" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<!-- 파일 처리 -->
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@page import="java.util.UUID" %>
<%@page import="java.io.*" %>


<!-- 한글 안깨지게 처리 & 로그인 세션처리  -->
<%@ include file="../inc/login_chk.jsp" %>

<%
	String title = "";
	String name = "";
	String contents = "";
	String id = "";
	String gubn = "";
	String pg = "";
	String searchType = "";
	String keyword = "";
	String sort= "";
	int num = 0; 				// 뷰에서 넘어오는값 (1)
    String uploadFile=""; 	 	// 업로드 파일명 
    String newFileName = ""; 	// 실제 저장할 파일명  
    //String fileTitle = "";	// 작성된 파일명 
    String alreadyFile_ = "";   // 이미 있는 파일 담을 변수  
	
   	// 보내는 값 담을 객체 선언
	Map<String,Object> map = new HashMap<String,Object>();
	
	int result = 0;
	String message = "";
	String url = "";
	
 
    try{
    	
    	System.out.println("콘텐트타입 : " + request.getContentType()); 
    	
    	// ---------------------------boardView.jsp 에서 바로 넘어오는 delete의 경우(회원의 경우) multipart/form-data가 아니다.---------------
    	if(request.getContentType() == null){

    		// 뷰에서 넘어오는값 - 페이징 
    		pg = request.getParameter("pg") == null? "": request.getParameter("pg");
    		searchType  = request.getParameter("searchType") == null? "": request.getParameter("searchType"); 
    		keyword  = request.getParameter("keyword") == null? "": request.getParameter("keyword");
    		
    		// 뷰에서 넘어오는값 - 필수항목 체크 
    		String[] arr = {"num","sort"}; // 순서 확인용
    		boolean returnchk = (boolean)valid.validation(request, arr).get("succ");
    		
    		if(!returnchk) { // false인 경우 
    			System.out.println(valid.validation(request, arr).get("message").toString());
    			out.println(common.jsAlertUrl("필수항목이 넘어오지 않았습니다.", "javascript:window.history.back();"));
    			return;
    		}
    		
    		num = Integer.parseInt(request.getParameter("num"));
    		sort = request.getParameter("sort");
//    		id = request.getParameter("id");
//    		gubn = request.getParameter("gubn");
			id = mem_id;
    		gubn = mem_gubun;
    		
    		// 사용자 처리전 동일id가 맞는지 한번더 확인 
    		Map<String,Object> output = dao.select_Row("Board.selectOne", num);
    		String outputId = output.get("ID") == null? "" : output.get("ID").toString(); // null 체크 한번더 
    		
    		if(!outputId.equals(id) && !gubn.equals("admin")){
    			out.println(common.jsAlertUrl("삭제할 권한이 없습니다.", "javascript:window.history.back();"));
    		}else{
	    		// 보낼 값 셋팅
	    		if(sort.equals("d")){    // -- 회원 boardview에서 넘어오는건 게시글 삭제 밖에 없다.
		    		map.put("num", num); // 보낼 값 
	    			result = dao.delete_Data("Board.deleteData", map);

		    		// 게시판 삭제시 하위 테이블도 삭제
					if(result != 0){
						dao.delete_Data("selDelComment",map); // (1) 댓글 TB 삭제 
						dao.delete_Data("selDelOpinion", map); // (2) 의견 TB 삭제 
						
						// (3) 물리적 파일삭제 
						List<Map<String,Object>> fileReturn = new ArrayList<Map<String,Object>>();
						fileReturn = dao.select_List("Board.selectFile", map);
						for(int i =0; i<fileReturn.size(); i++){
							
							// 물리파일 삭제
							String temp = fileReturn.get(i).get("SAVE_NAME").toString();
							common.fileDelete(request, temp);
						}
						
						dao.delete_Data("selDelFile", map); // (4)파일 TB 삭제 
					}
		    		
	    			message = "삭제가";
	    			url = "board_list.jsp?pg=" + pg + "&searchType=" + searchType + "&keyword=" + keyword; // 보던 페이지로 이동 
	    		}
    		}
    		
    		
    	}else{ 
    	// ---------------------------multipart/form-data 인 경우 - update, insert -----------------------------
    		/*
				form에서 파일 또는 이미지를 전송하기 위해서는 enctype이 “multipart/form-data”로 설정되어 있어야 한다. 
				따라서, request.getParameter()로 데이터를 불러올 수 없게 된다.
				enctype이 multipart일 때 request.getParameter()로 데이터를 뽑아낼 수 없지만,
				MultipartRequest객체를 이용하면 똑같이 getParameter()메서드로 일반 데이터를 뽑아낼 수 있다.
				따라서, MultipartRequest객체.getParameter(“네임”) 을 하게 되면 똑같이 데이터를 뽑아낼 수 있다.
			*/		
		    int maxSize = 100*1024*1024;  // 100MB 제한 용량 설정 
		    String savePath = "D:/workspace/boardver3/WebContent/board/fileBox/";  // 저장할 경로 
		    String format = "UTF-8";
		    
		    // 멀티 파트 객체 생성
	        MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, format, new DefaultFileRenamePolicy());
		    
	        // 게시글 내용 뷰에서 넘어오는값 (1)
	      	title = multi.getParameter("title") == null? "" : multi.getParameter("title");
		 	name = multi.getParameter("name") == null? "" : multi.getParameter("name");
			contents = multi.getParameter("contents") == null? "" : multi.getParameter("contents"); 
			//id = multi.getParameter("id") == null? "" : multi.getParameter("id") ;  // id 값 
			num = Integer.parseInt(multi.getParameter("num") == null? "0": multi.getParameter("num")); 
			id = mem_id;
    		gubn = mem_gubun;
			
			// 뷰에서 넘어오는값 (2)- 페이징 
			pg = multi.getParameter("pg") == null? "0" : multi.getParameter("pg");
			searchType  = multi.getParameter("searchType") == null? "" : multi.getParameter("searchType"); 
			keyword  = multi.getParameter("keyword") == null? "" : multi.getParameter("keyword");
			
			// 구분 값 뷰에서 넘어오는값 (3)
			sort = multi.getParameter("sort") == null? "" : multi.getParameter("sort"); 
			//gubn = multi.getParameter("gubn") == null? "" : multi.getParameter("gubn"); 
    		gubn = mem_gubun;
			
			// 파일 업로드 값 (4)	
			//fileTitle = multi.getParameter("fileTitle") == null? "" : multi.getParameter("fileTitle");
			//fileTitle = new String(fileTitle.getBytes("8859_1"), "UTF-8");  // 한글깨짐 방지 
			
			// 넘길 값 셋팅 
			map.put("num", num);
			map.put("id", id);
			map.put("name", name);
			map.put("title", title);
			map.put("contents", contents.replace("\r\n", "<br>"));
			int fileResult = 0;
			
			// -------------------------- 게시글 수정 -----------------------
			if(sort.equals("u")){   
				
		   		// 처리전 동일id가 맞는지 한번더 확인 
	    		Map<String,Object> output = dao.select_Row("Board.selectOne", num);
				String outputId = output.get("ID") != null ? output.get("ID").toString() : ""; 

				if(!outputId.equals(id) && !gubn.equals("admin")){
	    			out.println(common.jsAlertUrl("처리할 권한이 없습니다.", "javascript:window.history.back();"));
	    		}else{
				
					int temp = 0;
					result = dao.update_Data("Board.updateData", map); // 글 수정 
				
					// (1) 게시판 번호에 맞는 파일이 있는지 확인한다. 
					List<Map<String,Object>> fileReturn = new ArrayList<Map<String,Object>>();
					fileReturn = dao.select_List("Board.selectFile", map);
					
					// (2) alreadyFile_i 의 값들 중에서 없어진 파일이 있는지 확인한다. - 없어지면 삭제
					for(int i=0; i<fileReturn.size(); i++){
						alreadyFile_ = multi.getParameter("alreadyFile_"+i) == null? "0" : multi.getParameter("alreadyFile_"+i);
						// 그런다음 비교 
						if(!alreadyFile_.equals("0")){
							if(alreadyFile_.equals(fileReturn.get(i).get("SAVE_NAME").toString())){
								System.out.println("같은 파일이 존재!");
							}
						}
						
						if(alreadyFile_.equals("0")){  // 없어진거 => 삭제
							
							// 물리적 파일 삭제 	
							String tempFileName = fileReturn.get(i).get("SAVE_NAME").toString();
							common.fileDelete(request, tempFileName);
						
							// DB 파일 삭제 	
							map.put("idx", fileReturn.get(i).get("IDX").toString()); // IDX값을 string으로 넣음
							temp = dao.delete_Data("Board.deleteFile", map); // 파일 삭제 처리 
						}
					}
					
					// (3) 추가된 파일이 있는지 확인해서 파일 생성해서 저장한다. (insert와 동일) - 있으면 추가 
					Enumeration<String> enumer = multi.getFileNames(); 
					// 파일 이름으로 받는게 아니라 Enumeration으로 받을 수 있다. getFilesystemName --> getFileNames();
					while(enumer.hasMoreElements()) {  
						String inputTagFileName = (String) enumer.nextElement();  // input name값 : uploadFile1, uploadFile2, uploadFile3.. 
						uploadFile = multi.getFilesystemName(inputTagFileName) == null? "0" :  multi.getFilesystemName(inputTagFileName);   // intput name 값의 value
						
						if(!uploadFile.equals("0")){
							System.out.println("찍어본다 파일들  : " + uploadFile);
							
						    // 파일 생성 
					        newFileName = common.fileUpload(savePath, uploadFile);
					        
					     	// 파일추가 
							map.put("uploadFile", uploadFile);
							map.put("newFileName", newFileName);
							map.put("newBoardnum", num); // num으로 바꿔치기 ㅋ 
							//map.put("fileTitle", fileTitle);
					        fileResult = dao.insert_Data("Board.insertFile",map);  // 파일테이블 insert
							// 파일이 여러개 있을 수 있다. 
						}
					} // while 문 끝
				
					message = "수정이";
					url = "boardView.jsp?num=" + num + "&pg=" + pg + "&searchType=" + searchType + "&keyword=" + keyword; // 보고있던 뷰페이지로 이동
	    		}	
					
			}
			
			//  ----------------------- 게시글 등록 ---------------------
			if(sort.equals("i")){    
				
				// 등록도 user의 경우 불가 
				if(!gubn.equals("admin")){
					out.println(common.jsAlertUrl("처리할 권한이 없습니다.", "javascript:window.history.back();"));
				}else{
					
					result = dao.insert_Data("Board.insertData", map);
					map.put("newBoardnum", result); // 그전에 돌아온 result 값을(= 만들어진 board_num) 넣는다.. 
					
		 			// 처음 등록된 파일들을 돌린다. 
					Enumeration<String> enumer = multi.getFileNames(); 
					// 파일 이름으로 받는게 아니라 Enumeration으로 받을 수 있다. getFilesystemName --> getFileNames();
					while(enumer.hasMoreElements()) {  
						String inputTagFileName = (String) enumer.nextElement();  // input name값 : uploadFile1, uploadFile2, uploadFile3.. 
						uploadFile = multi.getFilesystemName(inputTagFileName) == null? "0" :  multi.getFilesystemName(inputTagFileName);   // intput name 값의 value
						
						if(!uploadFile.equals("0")){
							System.out.println("찍어본다 파일들  : " + uploadFile);
							
					        // 파일 생성 
					        newFileName = common.fileUpload(savePath, uploadFile);
					        
					     	// 파일추가 
							map.put("uploadFile", uploadFile);
							map.put("newFileName", newFileName);
							//map.put("fileTitle", fileTitle);
					        fileResult = dao.insert_Data("Board.insertFile",map);  // 파일테이블 insert
							// 파일이 여러개 있을 수 있다. 
						}
					} // while 문 끝
					
					message = "등록이";
					url = "boardView.jsp?num=" + result + "&pg=" + pg + "&searchType=" + searchType + "&keyword=" + keyword; // 등록 된 뷰페이지로 이동
				}
				
   			} // 등록 끝!
		
			//  ----------------------- sort 확인 불가 ---------------------
			if(sort.equals("") || sort == null){ 
				System.out.println("sort 확인불가");
				message = "sort가 확인이 안되!!!";
				url = "boardView.jsp?num=" + num + "&pg=" + pg + "&searchType=" + searchType + "&keyword=" + keyword; // 보고있던 뷰페이지로 이동
			}  
				
    	}
			
    }catch(Exception e){
    	System.out.println("MultipartRequest 익센셥탔따!");
        e.printStackTrace();
    }
	
	
	// 리턴할 메시지 출력 
	if(result != 0){
		out.println(common.jsAlertUrl("게시글 "+ message + " 완료되었습니다.", url));
	}else{
		out.println(common.jsAlertUrl("게시글 "+ message + " 처리 실패! ", url));
	}
	
%>