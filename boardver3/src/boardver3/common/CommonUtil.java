package boardver3.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

public class CommonUtil {
	
	// 싱글톤 선언
    private static CommonUtil common = new CommonUtil();
    public static CommonUtil getInstance() {
       return common;
    }
	
	public CommonUtil() {}

	// javascript- alert 띄우고 url 이동 
	public String jsAlertUrl(String message, String url) {
		
		StringBuffer strBuffer = new StringBuffer();
		strBuffer.append("<script type=\'text/javascript\'>");
		strBuffer.append("alert(\'" + message + "\');");
		strBuffer.append("location.href=\'"+ url + "\'; ");
		strBuffer.append("</script>");
		
		return strBuffer.toString();
	}
	
	
	// 파일 등록 
	public String fileUpload(String savePath, String uploadFile) {
        
	    int read = 0;
	    byte[] buf = new byte[1024];
	    FileInputStream fin = null;
	    FileOutputStream fout = null;
	    long currentTime = System.currentTimeMillis();
	    SimpleDateFormat simDf = new SimpleDateFormat("yyyyMMdd"); // 테이터 날짜 저장 포맷 "yyyyMMddHHmmss"
		
		String uuid = UUID.randomUUID().toString();
        String newFileName = uuid +"_" + simDf.format(new Date(currentTime)) + "." + uploadFile.substring(uploadFile.lastIndexOf(".") +1); // 저장파일이름 + 확장자
        
        File oldFile = new File(savePath + uploadFile);  // 직접 올린(업로드된) 파일명 
        File newFile = new File(savePath + newFileName); // 변경해 저장될 파일명 
        
        try {
        	// 파일명 rename 
        	if(!oldFile.renameTo(newFile)){
        		// rename이 되지 않을 경우 강제로 파일을 복사하고 기존 파일은 삭제 
        		buf = new byte[1024];
        		fin = new FileInputStream(oldFile);
        		fout = new FileOutputStream(newFile);
        		read = 0;
        		while((read=fin.read(buf,0,buf.length))!=-1){
        			fout.write(buf, 0, read);
        		}
        		fin.close();
        		fout.close();
        		oldFile.delete();
        	} 
        }catch(Exception e) {
        	e.printStackTrace();
        }
        
        return newFileName;
	}
	
	
	// 파일 삭제
	public void fileDelete(HttpServletRequest request, String saveFileName) {
		// 물리적 파일 삭제 	
		String root = request.getSession().getServletContext().getRealPath("/");
		String path = root + "board" + File.separator + "fileBox" + File.separator;
		path += saveFileName;
		
		System.out.println("path 찍어보기 ::: " + path);
		
		File f = new File(path); // 파일 객체생성
		if(f.exists()){ 
			boolean df  = f.delete(); // 파일이 존재하면 파일을 삭제한다.
			if(df){
				System.out.println("파일 물리적 삭제처리ok!");
				// 파일에서는 확인되는데 이클립스 fileBox여기서는 사라지지 않음 
			}else{
				System.out.println("삭제기능 미작동!!!!!!!");
			}
		}else{
			System.out.println("파일 없음");
		}
	}
	
	
	
	// num 값에 특수문자 섞여있는지 확인해서 int로 돌려주는 함수 
	public int stringToint(String num) throws Exception {
		num = num.replaceAll("[^0-9]", "");
		int result = Integer.parseInt(num);
		
		return result;
	}
	
}
