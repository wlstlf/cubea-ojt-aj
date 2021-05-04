package boardver3.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import boardver3.sqlMap.SqlSessionManager;


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
	    	  if(map == null) map = new HashMap<String, Object>();
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
	   
	   
	   // insert  (게시판 등록/ 회원가입 / 댓글 등록 / 의견 등록) 
	   public int insert_Data(String targetNamespace, Map<String, Object> map) {
		   int result = 0;
		   try {
	    	   sqlSession = sqlSessionFactory.openSession(true);
    		   result = sqlSession.insert(targetNamespace, map); // 여기서 selectKey값이 넘어온다(sequence로 만들어진 max값)

    		   if(map.get("num") != null) {  // 게시판 등록의 경우 num값을 리턴 - 게시판 등록시만 넘오오는 이름이 num
    			   result = (int) map.get("num"); 
    			   System.out.println(result + "~~~~~ insert시 받는 result 값");
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
	   		   sqlSession.commit(); // 커밋해야함!!! -> 아니면 위 함수처럼 openSession(true)로 처리
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
