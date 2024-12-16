package user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.co.sist.dao.DbConnection;
import user.vo.UserVO;

public class UserAuthenticationDAO {
	private static UserAuthenticationDAO uDAO;

	private UserAuthenticationDAO() {

	}

	public static UserAuthenticationDAO getInstance() {
		if (uDAO == null) {
			uDAO = new UserAuthenticationDAO();

		} // end if
		return uDAO;
	}// getInstance

	/**
	 * 로그인
	 * 
	 * @param userId
	 * @param password
	 * @return
	 * @throws SQLException
	 */
	public UserVO selectUserForLogin(String userId, String password) throws SQLException {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		UserVO uVO = null; // 결과를 담을 객체

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder select = new StringBuilder();
			select.append("select user_id, password, name, email, phone, zipcode, ")
					.append("       address_1, address_2, security_answer, question_id ").append("from member ")
					.append("where user_id = ? and password = ?");

			pstmt = con.prepareStatement(select.toString());
			pstmt.setString(1, userId);
			pstmt.setString(2, password);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 결과가 있을 경우 uVO 객체에 데이터 설정
				uVO = new UserVO();
				uVO.setUserId(rs.getString("user_id"));
				uVO.setPassword(rs.getString("password"));
				uVO.setName(rs.getString("name"));
				uVO.setEmail(rs.getString("email"));
				uVO.setPhone(rs.getString("phone"));
				uVO.setZipcode(rs.getString("zipcode"));
				uVO.setAddress1(rs.getString("address_1"));
				uVO.setAddress2(rs.getString("address_2"));
				uVO.setSecurityAnswer(rs.getString("security_answer"));
				uVO.setQuestion_id(rs.getInt("question_id"));
				;
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return uVO;
	}// selectUserForLogin

	/**
	 * 회원가입
	 * 
	 * @param uVO
	 * @return
	 * @throws SQLException
	 */
	public int insertUser(UserVO uVO) throws SQLException {
		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		// 1. JNDI사용객체 생성
		// 2. DBCP에서 DataSource 얻기
		DbConnection dbCon = DbConnection.getInstance();
		try {

			// 3. Connection 얻기
			con = dbCon.getConn();
			// 4. 쿼리문 생성객체 얻기
			StringBuilder insertUser = new StringBuilder();
			insertUser.append("insert into member").append(
					"( user_id, password, name, email, phone, gender, zipcode, address_1, address_2, birth, security_answer, question_id) ")
					.append("values(?,?,?,?,?,?,?,?,?,?,?,?)");

			pstmt = con.prepareStatement(insertUser.toString());

			// 5. 바인드 변수에 값 설정
			pstmt.setString(1, uVO.getUserId());
			pstmt.setString(2, uVO.getPassword());
			pstmt.setString(3, uVO.getName());
			pstmt.setString(4, uVO.getEmail());
			pstmt.setString(5, uVO.getPhone());
			pstmt.setString(6, uVO.getGender());
			pstmt.setString(7, uVO.getZipcode());
			pstmt.setString(8, uVO.getAddress1());
			pstmt.setString(9, uVO.getAddress2());
			pstmt.setString(10, uVO.getBirth());
			pstmt.setString(11, uVO.getSecurityAnswer());
			pstmt.setInt(12, uVO.getQuestion_id());

			// 6. 쿼리문 수행 후 결과 얻기
			rowCnt = pstmt.executeUpdate();

		} finally {
			// 7. 연결끊기
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;
	}// insertUser

	/**
	 * 아이디 중복 확인
	 * 
	 * @param id
	 * @return
	 * @throws SQLException
	 */
	public boolean selectDupId(String id) throws SQLException {
		boolean flag = false;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		// 1. JNDI 사용 객체 생성
		// 2. DBCP에서 DataSource 얻기
		DbConnection dbCon = DbConnection.getInstance();
		try {

			// 3. Connection 얻기
			con = dbCon.getConn();

			// 4. 쿼리문 생성 객체 얻기
			String selectId = "select user_id from member where user_id=?";
			pstmt = con.prepareStatement(selectId);

			// 5. 바인드에 변수 값 설정
			pstmt.setString(1, id);

			rs = pstmt.executeQuery();
			// 6. 쿼리문 수행 후 결과얻기

			flag = rs.next();

		} finally {
			// 7. 연결끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return flag;
	}// selectIDupId

	/**
	 * id 찾기 이름, 휴대전화, 생년월일을 입력하여 그에맞는 id를 찾음
	 * 
	 * @param uVO
	 * @return
	 * @throws SQLException
	 */
	public UserVO selectUserId(UserVO uVO) throws SQLException {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		UserVO resultVO = null;

		// 1. JNDI 사용 객체 생성
		// 2. DBCP에서 DataSource 얻기
		DbConnection dbCon = DbConnection.getInstance();
		try {

			// 3. Connection 얻기
			con = dbCon.getConn();

			// 4. 쿼리문 생성 객체 얻기
			StringBuilder selectId = new StringBuilder();
			selectId.append("	select	user_id, name	").append("	from	member	").append("	where 	name = ?	")
					.append("	and	 	phone = ?	").append("	and 	birth = ?	");

			pstmt = con.prepareStatement(selectId.toString());

			// 5. 바인드에 변수 값 설정
			pstmt.setString(1, uVO.getName());
			pstmt.setString(2, uVO.getPhone());
			pstmt.setString(3, uVO.getBirth());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 결과가 있을 경우 uVO 객체에 데이터 설정
				resultVO = new UserVO();
				resultVO.setUserId(rs.getString("user_id"));
				resultVO.setName(rs.getString("name"));
			} // end if
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return resultVO;
	}// selectUserId

	/**
	 * 아이디를 입력받고 그에 해당하는 question_id를 finding_password테이블에서 참조하여 question을 가져오는 메소드
	 * 
	 * @param userId
	 * @return
	 * @throws SQLException
	 */
	public UserVO selectQuestion(String userId) throws SQLException {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		UserVO resultVO = null;

		// 1. JNDI 사용 객체 생성
		// 2. DBCP에서 DataSource 얻기
		DbConnection dbCon = DbConnection.getInstance();
		try {

			// 3. Connection 얻기
			con = dbCon.getConn();

			// 4. 쿼리문 생성 객체 얻기
			StringBuilder selectId = new StringBuilder();
			selectId.append("	select	user_id, security_answer, pf.question	").append("	from	member m	")
					.append("	join	password_finding pf on m.question_id = pf.question_id	")
					.append("	where	m.user_id = ?	");

			pstmt = con.prepareStatement(selectId.toString());

			// 5. 바인드에 변수 값 설정
			pstmt.setString(1, userId);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 결과가 있을 경우 uVO 객체에 데이터 설정
				resultVO = new UserVO();
				resultVO.setUserId(rs.getString("user_id"));
				resultVO.setSecurityAnswer(rs.getString("security_answer"));
				resultVO.setSecurityQuestion_id(rs.getString("question"));
			} // end if
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return resultVO;
	}// selectQuestion

	/**
	 * 비밀번호 찾기 기능을 통해 업데이트
	 * 
	 * @param userId
	 * @param newPassword
	 * @return
	 * @throws SQLException
	 */
	public int updatePassword(String userId, String newPassword) throws SQLException {

		Connection con = null;
		PreparedStatement pstmt = null;
		int rowCnt = 0;

		// 1. JNDI 사용 객체 생성
		// 2. DBCP에서 DataSource 얻기
		DbConnection dbCon = DbConnection.getInstance();
		try {

			// 3. Connection 얻기
			con = dbCon.getConn();

			// 4. 쿼리문 생성 객체 얻기
			StringBuilder selectId = new StringBuilder();
			selectId.append("	update	member	").append("	set 	password = ?	").append("	where	user_id = ?	");

			pstmt = con.prepareStatement(selectId.toString());

			// 5. 바인드에 변수 값 설정
			pstmt.setString(1, newPassword);
			pstmt.setString(2, userId);

			rowCnt = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;
	}// selectQuestion

	public int updateChangePassword(String userId, String currentPassword, String newPassword) throws SQLException {

		Connection con = null;
		PreparedStatement pstmt = null;
		int rowCnt = 0;

		// 1. JNDI 사용 객체 생성
		// 2. DBCP에서 DataSource 얻기
		DbConnection dbCon = DbConnection.getInstance();
		try {

			// 3. Connection 얻기
			con = dbCon.getConn();

			// 4. 쿼리문 생성 객체 얻기
			StringBuilder selectId = new StringBuilder();
			selectId.append("	update	member	").append("	set 	password = ?	")
					.append("	where	user_id = ? and password= ?	");

			pstmt = con.prepareStatement(selectId.toString());

			// 5. 바인드에 변수 값 설정
			pstmt.setString(1, newPassword);
			pstmt.setString(2, userId);
			pstmt.setString(3, currentPassword);

			rowCnt = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;
	}// selectQuestion

}// class
