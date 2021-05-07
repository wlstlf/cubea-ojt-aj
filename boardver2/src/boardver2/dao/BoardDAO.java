package boardver2.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import boardver2.dto.BoardDTO;
import boardver2.sqlMap.SqlSessionManager;


public class BoardDAO {
   
   // dao 싱글톤 선언
   private static BoardDAO dao = new BoardDAO();
   public static BoardDAO getInstance() {
      return dao;
   }
   
   private BoardDAO() {}
   
    SqlSessionFactory sqlSessionFactory = SqlSessionManager.getSqlSession();
   	SqlSession sqlSession = null;
   
   // 게시판 총 갯수	
   public int listCount(String searchType, String keyword)  throws Exception{ 
	   int result = 0; 
	   Map<String, Object> map = new HashMap<String, Object>();
	   map.put("searchType",searchType);
	   map.put("keyword",keyword);
	   
	   try {
		   sqlSession = sqlSessionFactory.openSession();
		   result = sqlSession.selectOne("Board.listCount",map);
	   }catch(Exception e) {
		   e.printStackTrace() ;
	   }finally {
		   sqlSession.close();
	   }
	   return result;
   }
   
   
   // selectAll 리스트 가져오기
   public List<BoardDTO> selectData(String searchType, String keyword) throws Exception  {
      List<BoardDTO> dtoList = new ArrayList<BoardDTO>();
      Map<String, Object> map = new HashMap<String, Object>();
	   map.put("searchType",searchType);
	   map.put("keyword",keyword);
      
      try {
    	  sqlSession = sqlSessionFactory.openSession();
    	  dtoList = sqlSession.selectList("Board.boardList",map);
	   }catch(Exception e) {
		   e.printStackTrace() ;
	   }finally {
		   sqlSession.close();
	   }
      return dtoList;
   }
   
   
   // select - 1개
   public BoardDTO selectOne(int num) throws Exception {
      BoardDTO dto = new BoardDTO();
      try {
    	  sqlSession = sqlSessionFactory.openSession();
    	  dto = sqlSession.selectOne("Board.selectOne", num);
	   }catch(Exception e) {
		   e.printStackTrace() ;
	   }finally {
		   sqlSession.close();
	   }
      return dto;
   }
   
   
   // insert - 게시글 등록 
   public int insertData(BoardDTO dto) throws Exception {
	   int result = 0;
	   
	   System.out.println("컨테늧~~: " + dto.getId());
	   System.out.println("컨테늧~~: " + dto.getContents());
	   System.out.println("컨테늧~~: " + dto.getNum());
	   System.out.println("컨테늧~~: " + dto.getTitle());
	   System.out.println("컨테늧~~: " + dto.getName());

	   try {
    	   sqlSession = sqlSessionFactory.openSession();
    	   int test = sqlSession.insert("Board.insertData", dto); // 여기서 selectKey가 넘어오려나
    	   
    	   result = dto.getNum(); // 여기에 담겨져서 온다. 신기방기 
    	   
    	   System.out.println("result!!!! "+ result);  // 찍어보자
    	   System.out.println("test!!!! "+ test);  // 찍어보자 
    	   
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
   
   
   // update - 게시글 수정 
   public int updateData(BoardDTO dto) throws Exception {
	   int result = 0;
	   
	   try {
    	   sqlSession = sqlSessionFactory.openSession();
    	   result = sqlSession.update("Board.updateData", dto);
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
   
   
   // delete - 게시판 삭제
   public int deleteData(BoardDTO dto) throws Exception {
	  int result = 0;
	  try {
    	  sqlSession = sqlSessionFactory.openSession();
    	  result = sqlSession.delete("Board.deleteData", dto);
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
   
   
   // 뷰 카운트 - 정리해야함.
   public int viewPlus(int num) throws Exception {
      int result = 0;
      return result;
   }
   
   

}