package boardver2.dao;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import boardver2.dto.MemberDTO;
import boardver2.sqlMap.SqlSessionManager;


public class MemberDAO {
   
   // dao 싱글톤 선언
   private static MemberDAO dao = new MemberDAO();
   public static MemberDAO getInstance() {
      return dao;
   }
   
   private MemberDAO() {}
   
    SqlSessionFactory sqlSessionFactory = SqlSessionManager.getSqlSession();
   	SqlSession sqlSession = null;
   
   
   // 로그인 처리 
   public MemberDTO login(String id) throws Exception {
	   MemberDTO dto = new MemberDTO();
      try {
    	  sqlSession = sqlSessionFactory.openSession();
    	  dto = sqlSession.selectOne("Member.login", id);
	   }catch(Exception e) {
		   e.printStackTrace() ;
	   }finally {
		   sqlSession.close();
	   }
      return dto;
   }
   
   
   // 아이디 중복체크 
   public int idChk(String id) throws Exception {
	   int result = 0;
	   try {
	    	  sqlSession = sqlSessionFactory.openSession();
	    	  result = sqlSession.selectOne("Member.idCheck", id);
		   }catch(Exception e) {
			   e.printStackTrace() ;
		   }finally {
			   sqlSession.close();
		   }
	   return result;
   }
   
   
   // 회원가입 - insert
   public int insertMember(MemberDTO dto) throws Exception {
	   int result = 0;
	   
	   System.out.println("컨테늧~~: " + dto.getId());
	   System.out.println("컨테늧~~: " + dto.getPwd());
	   System.out.println("컨테늧~~: " + dto.getName());
	   System.out.println("컨테늧~~: " + dto.getGubun());

	   try {
//    	   sqlSession = sqlSessionFactory.openSession();
    	   sqlSession = sqlSessionFactory.openSession(true);
    	   result = sqlSession.insert("Member.insertMember", dto); 
    	   
    	   if(result > 0) {
    		   sqlSession.commit(); // 커밋해야함!!!
			}else {
				sqlSession.rollback();
			}
	    }catch(Exception e) {
		   e.printStackTrace() ;
	    }finally {
		    sqlSession.close();
	    }
       
      return result;
   }
   

}