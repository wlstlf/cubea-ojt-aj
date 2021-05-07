package boardver3.sqlMap;

import java.io.IOException;
import java.io.Reader;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class SqlSessionManager {
	
   public static SqlSessionFactory sqlSession;
   // Mybatis에서는 SqlSession 객체가 실제 SQL을 실행한다. 
   // SqlSession 객체는 SqlSessionFactory로부터 얻을 수 있다.
   
    static {
        String resource = "boardver3/sqlMap/Configuration.xml"; // DB정보를 품고있는 설정xml을 자원으로 사용
        Reader reader;
        
        try {
            reader = Resources.getResourceAsReader(resource);  // 그 자원을 읽어서 객체에 저장 
            sqlSession = new SqlSessionFactoryBuilder().build(reader); // sqlSessionFactoryBuilder 객체로 생성
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
     
     
    public static SqlSessionFactory getSqlSession() {
        return sqlSession; // static 으로 new 객체 반환 
    }

}
