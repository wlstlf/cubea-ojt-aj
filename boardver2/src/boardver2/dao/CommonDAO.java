package boardver2.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

//import boardver2.dto.BoardDTO; // 지울거 
//import boardver2.dto.MemberDTO; // 지울거 
import boardver2.sqlMap.SqlSessionManager;



/*------------------------ 
 * DTO 대신 Map 사용 - dao를 하나로 합침
 * -------------------------*/

public class CommonDAO {

	  // dao 싱글톤 선언
	   private static CommonDAO dao = new CommonDAO();
	   public static CommonDAO getInstance() {
	      return dao;
	   }
	   
	   private CommonDAO() {}
	   
	   // 세션 메니저 갖고오기 
	   SqlSessionFactory sqlSessionFactory = SqlSessionManager.getSqlSession();
	   SqlSession sqlSession = null;
	   
	   // 사용할 Map 선언
	   Map<String,Object> map = new HashMap<String,Object>();
	   	
	   
	   
	   // 한개의 _Row값 가져오기  (Mapper-namespace 파라미터로 받기)  - 로그인 / login()
	   public Map<String, Object> select_Row(String targetNamespace, Map<String, Object> map){  
		   try {
	    	  sqlSession = sqlSessionFactory.openSession();
	    	  map = sqlSession.selectOne(targetNamespace, map);  // Mapper-namespace 이름을 파라미터로 받는다.
		   }catch(Exception e) {
			   e.printStackTrace() ;
		   }finally {
			   sqlSession.close();
		   }
		   return map;
	   }
	   
	   // 파라미터 다른걸로 하나더 - 게시판1개보기 / selectOne() 
	   public Map<String, Object> select_Row(String targetNamespace, Object num){  
		   try {
	    	  sqlSession = sqlSessionFactory.openSession();
	    	  map = sqlSession.selectOne(targetNamespace, num);  
		   }catch(Exception e) {
			   e.printStackTrace() ;
		   }finally {
			   sqlSession.close();
		   }
		   return map;
	   }
	   
	   // 게시판 수 구하기 listCount() - 아이디 중복체크 
	   public int select_One(String targetNamespace, Map<String, Object> map){  
		   int result = 0; 
		   try {
			   sqlSession = sqlSessionFactory.openSession();
			   result = sqlSession.selectOne(targetNamespace,map);
		   }catch(Exception e) {
			   e.printStackTrace() ;
		   }finally {
			   sqlSession.close();
		   }
		   return result;
	   }
	   
	   // 게시판 리스트 가지고오기 
	   public List<Map<String,Object>> select_List(String targetNamespace, Map<String, Object> map){
			List<Map<String, Object>> dtoList = new ArrayList<Map<String, Object>>();
			try {
		    	sqlSession = sqlSessionFactory.openSession();
		    	dtoList = sqlSession.selectList(targetNamespace,map);
			 }catch(Exception e) {
				 e.printStackTrace() ;
			 }finally {
				 sqlSession.close();
			 }
		    return dtoList;
	   }
	   
	   
	   // insert  (게시판 등록/ 회원가입) 
	   public int insert_Data(String targetNamespace, Map<String, Object> map) {
		   int result = 0;
		   try {
	    	   sqlSession = sqlSessionFactory.openSession(true);

	    	   if(targetNamespace.equals("Board.insertData")) {  // 게시판 등록일 경우 
	    		   result = sqlSession.insert(targetNamespace, map); // 여기서 selectKey가 넘어오려나
	    		   result = (int) map.get("num"); // 여기에 담겨져서 온다. 신기방기 
	    	   }else if(targetNamespace.equals("Member.insertMember")) {
	    		   result = sqlSession.insert(targetNamespace, map); 
	    	   }
		    }catch(Exception e) {
			   e.printStackTrace() ;
		    }finally {
			    sqlSession.close();
		    }
		   return result;
	   }
	   
	   
	   // update - 게시글 수정 
	   public int update_Data(String targetNamespace, Map<String,Object> map) {
		   int result = 0;
		   try {
	    	   sqlSession = sqlSessionFactory.openSession(true);
	    	   result = sqlSession.update(targetNamespace, map);
	    	   
		    }catch(Exception e) {
		       e.printStackTrace() ;
		    }finally {
			   sqlSession.close();
		    }
	      return result;
	   }
	   
	   
	   // delete - 게시판 삭제
	   public int delete_Data(String targetNamespace, Map<String,Object> map) {
		  int result = 0;
		  try {
	    	  sqlSession = sqlSessionFactory.openSession();
	    	  result = sqlSession.delete(targetNamespace, map);
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

	   
	   // 뷰 카운트  
	   public int insert_Data(String targetNamespace, int num) {
	      int result = 0;
	      try {
	    	   sqlSession = sqlSessionFactory.openSession(true); // true로 하면 자동커밋
	    	   result = sqlSession.insert(targetNamespace, num);  
		    }catch(Exception e) {
			   e.printStackTrace() ;
		    }finally {
			    sqlSession.close();
		    }
	      return result;
	   }
	   
	   
}
