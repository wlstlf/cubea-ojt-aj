<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
 
<!-- 한글 안깨지게 처리 & 로그인 세션처리  -->
<%@ include file="../inc/login_chk.jsp" %>
 
<%
    // 파일 업로드된 경로
    String root = request.getSession().getServletContext().getRealPath("/");
    String savePath = root + "board" + File.separator + "fileBox";    
    /* Java 문법 깨끗하게 사용가능 File.separator = \ */
    
    System.out.println("----------------root" + root);  
    System.out.println("----------------savePath" + savePath);  
    
    // 서버에 실제 저장된 파일명
    String filename = request.getParameter("fileName") == null? "" : request.getParameter("fileName");
     
    // 실제 내보낼 파일명
    String uploadName = request.getParameter("uploadName") == null? "" : request.getParameter("uploadName");
    String orgfilename = uploadName;
 
    InputStream in = null;
    OutputStream os = null;
    File file = null;
    boolean skip = false;
    String client = "";
 
    try{
        // 파일을 읽어 스트림에 담기
        try{
            file = new File(savePath, filename);
            in = new FileInputStream(file);
        }catch(FileNotFoundException fe){
            skip = true;
        }
         
        client = request.getHeader("User-Agent");
 
        // 파일 다운로드 헤더 지정
        response.reset() ;
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Description", "JSP Generated Data");
 
        if(!skip){
            // IE
            if(client.indexOf("MSIE") != -1){
                response.setHeader ("Content-Disposition", "attachment; filename=" + new String(orgfilename.getBytes("KSC5601"),"ISO8859_1"));
 
            }else{
                // 한글 파일명 처리
                orgfilename = new String(orgfilename.getBytes("utf-8"),"iso-8859-1");
 
                response.setHeader("Content-Disposition", "attachment; filename=\"" + orgfilename + "\"");
                response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
            } 
             
            response.setHeader ("Content-Length", ""+file.length() );
 
            /*
            	4월 14, 2021 5:12:23 오후 org.apache.catalina.core.StandardWrapperValve invoke
				java.lang.IllegalStateException:  에러에 관하여 
	            JSP를 Servlet으로 변하는 과정에 생기는 OutputStream 때문인데, 
	            다음을 통해 JSP 자체의 OutputStream을 제거할 필요가 있다. 반드시 getOutputStream() 앞에 위치시킨다.
	            아래 두줄 추가함.
	            out.clear();
	            out = pageContext.pushBody();
            */
            out.clear();
            out = pageContext.pushBody();

            os = response.getOutputStream();
            byte b[] = new byte[(int)file.length()];
            int leng = 0;
             
            while( (leng = in.read(b)) > 0 ){
                os.write(b,0,leng);
            }
            
	        in.close();
	        os.close();
            
        }else{
            response.setContentType("text/html;charset=UTF-8");
            out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
        }
        
    }catch(Exception e){
      e.printStackTrace();
    } 
    
%>


