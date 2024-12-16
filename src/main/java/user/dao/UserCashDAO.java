package user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.co.sist.dao.DbConnection;

/**
 * @author : S.H.CHA
 */
public class UserCashDAO {
	public int selectUserCash(String userId) throws SQLException {
		int userCash = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DbConnection.getInstance().getConn();

			String selectQuery = "SELECT CASH_AMOUNT FROM USER_CASH WHERE USER_ID = ?";

			pstmt = con.prepareStatement(selectQuery);
			pstmt.setString(1, userId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				userCash = rs.getInt("CASH_AMOUNT");
			}

		} finally {
			DbConnection.getInstance().dbClose(rs, pstmt, con);
		}

		return userCash;
	}

	public int updateCash(String userId, int userCash) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DbConnection.getInstance().getConn();

			String updateQuery = "UPDATE USER_CASH SET CASH_AMOUNT = ? WHERE USER_ID = ?";

			pstmt = con.prepareStatement(updateQuery);
			pstmt.setInt(1, userCash);
			pstmt.setString(2, userId);

			result = pstmt.executeUpdate();

		} finally {
			DbConnection.getInstance().dbClose(null, pstmt, con);
		}

		return result;
	}

	public int insertCash(String userId, int userCash) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DbConnection.getInstance().getConn();

			String insertQuery = "INSERT INTO USER_CASH (USER_ID, CASH_AMOUNT) VALUES (?, ?)";

			pstmt = con.prepareStatement(insertQuery);
			pstmt.setString(1, userId);
			pstmt.setInt(2, userCash);

			result = pstmt.executeUpdate();

		} finally {
			DbConnection.getInstance().dbClose(null, pstmt, con);
		}

		return result;
	}
}
