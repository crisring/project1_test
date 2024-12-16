package user.dao;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;
import manage.inquiry.InquiryVO;
import user.vo.InquirySearchVO;

public class UserInquiryDAO {
	private static UserInquiryDAO uiDAO;

	private UserInquiryDAO() {

	}

	public static UserInquiryDAO getInstance() {
		if (uiDAO == null) {
			uiDAO = new UserInquiryDAO();

		} // end if
		return uiDAO;
	}// getInstance

	public void insertInquiry(InquiryVO iVO) throws SQLException {
		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성 객체 얻기
			StringBuilder insertInquiry = new StringBuilder();
			insertInquiry.append("	insert into inquiry(inquiry_id, user_id, category, title, content)	")
					.append("values(inquiry_id_seq.nextval,?, ?, ?, ?)	");

			pstmt = con.prepareStatement(insertInquiry.toString());
			// 바인드변수 값 설정
			pstmt.setString(1, iVO.getUserId());
			pstmt.setString(2, iVO.getCategory());
			pstmt.setString(3, iVO.getTitle());
			pstmt.setString(4, iVO.getContent());

			// 쿼리문 수행 후 결과얻기
			pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

	}// insertInquiry

	public List<InquiryVO> selectUserAllInquiry(InquirySearchVO isVO) throws SQLException {
		List<InquiryVO> list = new ArrayList<InquiryVO>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성 객체 얻기
			StringBuilder selectInquiry = new StringBuilder();
			selectInquiry.append(" select inquiry_id, category, title, user_id, create_at ").append(" from inquiry ")
					.append(" where user_id = ? ");

			// 검색 키워드가 존재할 경우 제목 검색 조건 추가
			if (isVO.getKeyword() != null && !"".equals(isVO.getKeyword().trim())) {
				selectInquiry.append(" and title like '%' || ? || '%' ");
			}

			// 최신순 정렬
			selectInquiry.append(" order by create_at desc ");

			pstmt = con.prepareStatement(selectInquiry.toString());

			// 바인드변수 값 설정
			int bindIndex = 1;
			pstmt.setString(bindIndex++, isVO.getUserId()); // userId 설정

			// 검색 키워드가 존재할 경우 바인드 변수 설정
			if (isVO.getKeyword() != null && !"".equals(isVO.getKeyword().trim())) {
				pstmt.setString(bindIndex++, isVO.getKeyword());
			}

			// 쿼리문 수행 후 결과얻기
			rs = pstmt.executeQuery();

			InquiryVO iVO = null;
			while (rs.next()) {
				iVO = new InquiryVO();
				iVO.setInquiryId(rs.getInt("inquiry_id"));
				iVO.setCategory(rs.getString("category"));
				iVO.setTitle(rs.getString("title"));
				iVO.setUserId(rs.getString("user_id"));
				iVO.setCreateAt(rs.getTimestamp("create_at"));

				list.add(iVO);
			} // end while

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return list;
	}// selectUserAllInquiry

	public InquiryVO selectUserOneInquiry(String userId, int inquiry_id) throws SQLException {

		InquiryVO iVO = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			StringBuilder selectOneInquiry = new StringBuilder();
			selectOneInquiry.append(" select inquiry_id, category, user_id, create_at, content, admin_id, admin_ad ")
					.append(" from inquiry ").append(" where user_id = ? AND inquiry_id=?");

			pstmt = con.prepareStatement(selectOneInquiry.toString());
			pstmt.setString(1, userId);
			pstmt.setInt(2, inquiry_id);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				iVO = new InquiryVO();
				iVO.setInquiryId(rs.getInt("inquiry_id"));
				iVO.setCategory(rs.getString("category"));
				iVO.setUserId(rs.getString("user_id"));
				iVO.setCreateAt(rs.getTimestamp("create_at"));
				iVO.setAdminAd(rs.getString("admin_id"));
				iVO.setAnswer(rs.getString("admin_ad"));

				// CLOB데이터를 읽어들이기
				java.sql.Clob clob = rs.getClob("content");
				if (clob != null) {
					BufferedReader br = new BufferedReader(clob.getCharacterStream());

					StringBuilder content = new StringBuilder();
					String temp;

					try {
						while ((temp = br.readLine()) != null) {
							content.append(temp).append("\n");
						}

						iVO.setContent(content.toString().replace("CLOB", "").trim());
					} catch (IOException e) {
						e.printStackTrace();
					}
					iVO.setContent(content.toString());
				} else {
				}
			} else {
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return iVO;
	}

	public int deleteInquiry(String inquiryId, String userId) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder deleteQuery = new StringBuilder();
			deleteQuery.append(" delete from inquiry ").append(" where inquiry_id = ? and user_id = ? ");

			pstmt = con.prepareStatement(deleteQuery.toString());
			pstmt.setString(1, inquiryId);
			pstmt.setString(2, userId);

			result = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // finally

		return result;
	}// deleteInquiry

}
