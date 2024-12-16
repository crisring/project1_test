package manage.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.co.sist.dao.DbConnection;

public class AdminAuthenticationDAO {
	private static AdminAuthenticationDAO aDAO;

	private AdminAuthenticationDAO() {

	}

	public static AdminAuthenticationDAO getInstance() {
		if (aDAO == null) {
			aDAO = new AdminAuthenticationDAO();

		} // end if
		return aDAO;
	}// getInstance

	/**
	 * 관리자 로그인
	 * 
	 * @param admin_id
	 * @param password
	 * @return
	 * @throws SQLException
	 */
	public AdminVO selectAdminId(String admin_id, String password) throws SQLException {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		AdminVO aVO = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder select = new StringBuilder();
			select.append("	select	admin_id, password	").append("	from	manager ")
					.append("	where	admin_id = ? and password = ?");

			pstmt = con.prepareStatement(select.toString());
			pstmt.setString(1, admin_id);
			pstmt.setString(2, password);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 결과가 있을 경우 uVO 객체에 데이터 설정
				aVO = new AdminVO();
				aVO.setAdmin_id(rs.getString("admin_id"));
				aVO.setPassword(rs.getString("password"));
			} // end if
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return aVO;
	}// selectAdminId
}
