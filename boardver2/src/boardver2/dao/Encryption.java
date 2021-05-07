package boardver2.dao;

import java.security.MessageDigest;

public class Encryption {

	//Map<String,String> temp = new HashMap<String,String>();
	
	// 솔트를 임의로 하나 지정하겠습니다.. ㅎㅎ 
	// String salt = "c7732b77265f056bd0b6c5a4ab76c425";
	//ORA-12899: "PRIVATE_AJ"."MEMBER_AJ"."PWD" 열에 대한 값이 너무 큼(실제: 64, 최대값: 50)
	//너무 길어서 다시 수정함 
	String salt = "c7732b77265f";
	
	// 새로운 계정 user
	public String set_Pwd(byte[] pwd) throws Exception {
		String dd = Hashing(pwd, salt);
		System.out.println("만들어진 해싱함수를 써보자 : " + dd);
		return dd;  // DB에 저장할 값을 넘겨준다.
	}
	
	
	// 비밀번호 해싱 (만들때)
	private String Hashing(byte[] pwd, String salt) throws Exception {
		MessageDigest md = MessageDigest.getInstance("SHA-256");	// SHA-256 해시함수를 사용
		// key-stretching
		for(int i = 0; i < 10000; i++) {
			String temp = Byte_to_String(pwd) + salt;	// 패스워드와 지정되어있는 salt 를 합쳐 새로운 문자열 생성 
			md.update(temp.getBytes());					// temp 의 문자열을 해싱하여 md 에 저장해둔다 
			pwd = md.digest();							// md 객체의 다이제스트를 얻어 password 를 갱신한다 
		}
		return Byte_to_String(pwd);
	}
	
	// 바이트 값을 16진수로 변경해준다 (만들때)
	private String Byte_to_String(byte[] temp) {
		StringBuilder sb = new StringBuilder();
		for(byte a : temp) {
			sb.append(String.format("%02x", a));
		}
		return sb.toString();
	}
	
	
	//---------------- 로그인 처리 (풀 때) -------------------------
	public String get_pwd(byte[] password) throws Exception {
		String temp_pass = Hashing(password, salt);	// 받아온 비번 + salt
		return temp_pass;  // 비밀번호 맞는 지 체크 한 값 리턴 
	}  
	
	
	
	// --- salt 값 ---- 
	// SALT 값 생성  (찾을땐 DB에서 찾는다.)
//	private static final int SALT_SIZE = 16;
//	private String getSALT() throws Exception {
//		SecureRandom rnd = new SecureRandom();
//		byte[] temp = new byte[SALT_SIZE];
//		rnd.nextBytes(temp);
//		
//		return Byte_to_String(temp);
//		
//	}
	
}
