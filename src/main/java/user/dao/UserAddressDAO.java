package user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.co.sist.dao.DbConnection;
import user.vo.ShippingVO;
import user.vo.UserAddressVO;

/**
 * @author : S.H.CHA
 */
public class UserAddressDAO {
	public int insertAddress(UserAddressVO uaVO) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DbConnection.getInstance().getConn();

			String insertQuery = "INSERT INTO USER_ADDRESS (ADDRESS_ID, USER_ID, " + "ADDRESS, IS_DEFAULT) VALUES "
					+ "(USER_ADDRESS_SEQ.NEXTVAL, ?, ?, ?)";

			pstmt = con.prepareStatement(insertQuery);
			pstmt.setInt(1, uaVO.getUserId());
			pstmt.setString(2, uaVO.getAddress());
			pstmt.setString(3, uaVO.isDefault() ? "Y" : "N");

			result = pstmt.executeUpdate();

		} finally {
			DbConnection.getInstance().dbClose(null, pstmt, con);
		}

		return result;
	}

	public String selectShippingStatus(String shippingStatus) throws SQLException {
		String status = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DbConnection.getInstance().getConn();

			String selectQuery = "SELECT STATUS_NAME FROM SHIPPING_STATUS " + "WHERE STATUS_CODE = ?";

			pstmt = con.prepareStatement(selectQuery);
			pstmt.setString(1, shippingStatus);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				status = rs.getString("STATUS_NAME");
			}

		} finally {
			DbConnection.getInstance().dbClose(rs, pstmt, con);
		}

		return status;
	}

	public ShippingVO selectShippingByOrderId(int orderId) throws SQLException {
		ShippingVO sVO = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DbConnection.getInstance().getConn();

			String selectQuery = "SELECT S.SHIPPING_ID, S.ORDER_ID, S.RECIPIENT, "
					+ "S.PHONE, S.ADDRESS, S.MEMO, S.SHIPPING_STATUS, " + "SS.STATUS_NAME " + "FROM SHIPPING S "
					+ "JOIN SHIPPING_STATUS SS ON S.SHIPPING_STATUS = SS.STATUS_CODE " + "WHERE S.ORDER_ID = ?";

			pstmt = con.prepareStatement(selectQuery);
			pstmt.setInt(1, orderId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				sVO = new ShippingVO();
				sVO.setShippingId(rs.getInt("SHIPPING_ID"));
				sVO.setOrderId(rs.getInt("ORDER_ID"));
				sVO.setRecipient(rs.getString("RECIPIENT"));
				sVO.setPhone(rs.getString("PHONE"));
				sVO.setAddress(rs.getString("ADDRESS"));
				sVO.setMemo(rs.getString("MEMO"));
				sVO.setStatus(rs.getString("STATUS"));
			}

		} finally {
			DbConnection.getInstance().dbClose(rs, pstmt, con);
		}

		return sVO;
	}

	public int updateShippingInfo(ShippingVO sVO) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DbConnection.getInstance().getConn();

			String updateQuery = "UPDATE SHIPPING SET " + "RECIPIENT = ?, " + "PHONE = ?, " + "ADDRESS = ?, "
					+ "MEMO = ? " + "WHERE SHIPPING_ID = ?";

			pstmt = con.prepareStatement(updateQuery);
			pstmt.setString(1, sVO.getRecipient());
			pstmt.setString(2, sVO.getPhone());
			pstmt.setString(3, sVO.getAddress());
			pstmt.setString(4, sVO.getMemo());
			pstmt.setInt(5, sVO.getShippingId());

			result = pstmt.executeUpdate();

		} finally {
			DbConnection.getInstance().dbClose(null, pstmt, con);
		}

		return result;
	}

	public boolean setDefaultAddress(int addressId, int userId) throws SQLException {
		boolean success = false;
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DbConnection.getInstance().getConn();
			con.setAutoCommit(false);

			// 기존 기본 배송지 해제
			String updateOldDefault = "UPDATE DELIVERY SET STATUS = '일반' " + "WHERE ORDER_ID = ? AND STATUS = '기본'";
			pstmt = con.prepareStatement(updateOldDefault);
			pstmt.setInt(1, userId);
			pstmt.executeUpdate();

			// 새로운 기본 배송지 설정
			String updateNewDefault = "UPDATE DELIVERY SET STATUS = '기본' " + "WHERE SHIPPING_ID = ?";
			pstmt = con.prepareStatement(updateNewDefault);
			pstmt.setInt(1, addressId);

			int result = pstmt.executeUpdate();

			if (result > 0) {
				con.commit();
				success = true;
			} else {
				con.rollback();
			}

		} finally {
			try {
				con.setAutoCommit(true);
				DbConnection.getInstance().dbClose(null, pstmt, con);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return success;
	}

	public int deleteAddress(int addressId, int userId) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DbConnection.getInstance().getConn();

			String deleteQuery = "DELETE FROM USER_ADDRESS " + "WHERE ADDRESS_ID = ? AND USER_ID = ?";

			pstmt = con.prepareStatement(deleteQuery);
			pstmt.setInt(1, addressId);
			pstmt.setInt(2, userId);

			result = pstmt.executeUpdate();

		} finally {
			DbConnection.getInstance().dbClose(null, pstmt, con);
		}

		return result;
	}
}
