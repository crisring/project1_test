package user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import kr.co.sist.dao.DbConnection;
import user.vo.PaymentVO;

/**
 * @author : S.H.CHA
 */
public class PaymentDAO {

	public PaymentVO selectPaymentByOrderId(int orderId) throws SQLException {
		PaymentVO pVO = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = DbConnection.getInstance().getConn();

			String selectQuery = "SELECT PAYMENT_ID, ADDRESS_ID, ORDER_ID, AMOUNT, " + "METHOD, PAYMENT_DATE, USE_CASH "
					+ "FROM PAYMENT WHERE ORDER_ID = ?";

			pstmt = con.prepareStatement(selectQuery);
			pstmt.setInt(1, orderId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				pVO = new PaymentVO();
				pVO.setPaymentId(rs.getInt("PAYMENT_ID"));
				pVO.setAddressId(rs.getInt("ADDRESS_ID"));
				pVO.setOrderId(rs.getInt("ORDER_ID"));
				pVO.setAmount(rs.getInt("AMOUNT"));
				pVO.setMethod(rs.getString("METHOD"));
				pVO.setPaymentDate(rs.getDate("PAYMENT_DATE"));
				pVO.setUserCash(rs.getInt("USE_CASH"));
			}

		} finally {
			DbConnection.getInstance().dbClose(rs, pstmt, con);
		}

		return pVO;
	}

	public int insertPayment(PaymentVO pVO) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DbConnection.getInstance().getConn();

			String insertQuery = "INSERT INTO PAYMENT (PAYMENT_ID, ORDER_ID, " + "AMOUNT, METHOD, PAYMENT_DATE) VALUES "
					+ "(PAYMENT_SEQ.NEXTVAL, ?, ?, ?, ?)";

			pstmt = con.prepareStatement(insertQuery);
			pstmt.setInt(1, pVO.getOrderId());
			pstmt.setInt(2, pVO.getAmount());
			pstmt.setString(3, pVO.getMethod());
			pstmt.setDate(4, pVO.getPaymentDate());

			result = pstmt.executeUpdate();

		} finally {
			DbConnection.getInstance().dbClose(null, pstmt, con);
		}

		return result;
	}

	public int updatePaymentStatus(int paymentId, String status) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = DbConnection.getInstance().getConn();

			String updateQuery = "UPDATE PAYMENT" + " SET STATUS = ? WHERE PAYMENT_ID = ?";

			pstmt = con.prepareStatement(updateQuery);
			pstmt.setString(1, status);
			pstmt.setInt(2, paymentId);

			result = pstmt.executeUpdate();

		} finally {
			DbConnection.getInstance().dbClose(null, pstmt, con);
		}

		return result;
	}
}
