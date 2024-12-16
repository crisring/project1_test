package user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;
import user.vo.ShippingVO;

/**
 * @author : S.H.CHA
 */
public class ShippingDAO {

	// 모든 배송지 조회
	public List<ShippingVO> selectAllShipping(String userId) throws SQLException {
		List<ShippingVO> list = new ArrayList<>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectQuery = new StringBuilder();
			selectQuery.append(" SELECT SHIPPING_ID, RECIPIENT, ").append(" PHONE, ADDRESS, ADDRESS2, MEMO, STATUS ")
					.append(" FROM DELIVERY ").append(" WHERE USER_ID = ? ") // 사용자의 배송지 조회
					.append(" AND ORDER_ID IS NULL ") // 주문에 사용되지 않은 배송지만
					.append(" ORDER BY INPUT_DATE DESC ");

			pstmt = con.prepareStatement(selectQuery.toString());
			pstmt.setString(1, userId);

			rs = pstmt.executeQuery();
			ShippingVO sVO = null;
			while (rs.next()) {
				sVO = new ShippingVO();
				sVO.setShippingId(rs.getInt("SHIPPING_ID"));
				sVO.setRecipient(rs.getString("RECIPIENT"));
				sVO.setPhone(rs.getString("PHONE"));
				sVO.setAddress(rs.getString("ADDRESS"));
				sVO.setAddress2(rs.getString("ADDRESS2"));
				sVO.setMemo(rs.getString("MEMO"));
				sVO.setStatus(rs.getString("STATUS"));
				list.add(sVO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return list;
	}

	// 특정 배송지 조회
	public ShippingVO selectOneShipping(int shippingId) throws SQLException {
		ShippingVO sVO = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			String selectQuery = " SELECT SHIPPING_ID, ORDER_ID, RECIPIENT, PHONE, ADDRESS, ADDRESS2, MEMO, STATUS "
					+ " FROM DELIVERY WHERE SHIPPING_ID = ?";

			pstmt = con.prepareStatement(selectQuery);
			pstmt.setInt(1, shippingId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				sVO = new ShippingVO();
				sVO.setShippingId(rs.getInt("SHIPPING_ID"));
				sVO.setOrderId(rs.getInt("ORDER_ID"));
				sVO.setRecipient(rs.getString("RECIPIENT"));
				sVO.setPhone(rs.getString("PHONE"));
				sVO.setAddress(rs.getString("ADDRESS"));
				sVO.setAddress2(rs.getString("ADDRESS2"));
				sVO.setMemo(rs.getString("MEMO"));
				sVO.setStatus(rs.getString("STATUS"));
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return sVO;
	}

	public int insertNewShipping(ShippingVO sVO, String userId) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			con.setAutoCommit(false); // 트랜잭션 시작

			// 기본 배송지로 설정하는 경우, 기존 기본 배송지 해제
			if ("Y".equals(sVO.getIsDefault())) {
				StringBuilder updateQuery = new StringBuilder();
				updateQuery.append(" UPDATE DELIVERY ").append(" SET IS_DEFAULT = 'N' ").append(" WHERE USER_ID = ? ")
						.append(" AND IS_DEFAULT = 'Y' ");

				pstmt = con.prepareStatement(updateQuery.toString());
				pstmt.setString(1, userId);
				pstmt.executeUpdate();
			}

			// 새 배송지 등록
			StringBuilder insertQuery = new StringBuilder();
			insertQuery.append(" INSERT INTO DELIVERY ")
					.append(" (SHIPPING_ID, USER_ID, RECIPIENT, PHONE, ADDRESS, ADDRESS2, MEMO, STATUS, IS_DEFAULT) ")
					.append(" VALUES (DELIVERY_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, '배송준비', ?) ");

			pstmt = con.prepareStatement(insertQuery.toString());
			pstmt.setString(1, userId);
			pstmt.setString(2, sVO.getRecipient());
			pstmt.setString(3, sVO.getPhone());
			pstmt.setString(4, sVO.getAddress());
			pstmt.setString(5, sVO.getAddress2());
			pstmt.setString(6, sVO.getMemo());
			pstmt.setString(7, sVO.getIsDefault());

			result = pstmt.executeUpdate();

			con.commit(); // 트랜잭션 커밋
		} catch (SQLException e) {
			if (con != null)
				con.rollback(); // 오류 시 롤백
			throw e;
		} finally {
			if (con != null)
				con.setAutoCommit(true); // autoCommit 복원
			dbCon.dbClose(null, pstmt, con);
		}
		return result;
	}

	// 배송지 정보 수정
	public int updateShipping(ShippingVO sVO) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder updateQuery = new StringBuilder();
			updateQuery.append(" UPDATE DELIVERY ").append(" SET RECIPIENT = ?, PHONE = ?, ")
					.append(" ADDRESS = ?, ADDRESS2 = ?, MEMO = ? ").append(" WHERE SHIPPING_ID = ? ");

			pstmt = con.prepareStatement(updateQuery.toString());
			pstmt.setString(1, sVO.getRecipient());
			pstmt.setString(2, sVO.getPhone());
			pstmt.setString(3, sVO.getAddress());
			pstmt.setString(4, sVO.getAddress2());
			pstmt.setString(5, sVO.getMemo());
			pstmt.setInt(6, sVO.getShippingId());

			result = pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
		return result;
	}

	// 배송지 삭제
	public int deleteShipping(int shippingId) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			String deleteQuery = "DELETE FROM DELIVERY WHERE SHIPPING_ID = ?";

			pstmt = con.prepareStatement(deleteQuery);
			pstmt.setInt(1, shippingId);

			result = pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}

		return result;
	}

	// 사용자의 기본 배송지 조회
	public ShippingVO selectDefaultShipping(String userId) throws SQLException {
		ShippingVO sVO = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectQuery = new StringBuilder();
			selectQuery.append(" SELECT SHIPPING_ID, RECIPIENT, ").append(" PHONE, ADDRESS, ADDRESS2, MEMO, STATUS ")
					.append(" FROM DELIVERY ").append(" WHERE USER_ID = ? ").append(" AND IS_DEFAULT = 'Y' "); // 기본
																												// 배송지만
																												// 조회

			pstmt = con.prepareStatement(selectQuery.toString());
			pstmt.setString(1, userId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				sVO = new ShippingVO();
				sVO.setShippingId(rs.getInt("SHIPPING_ID"));
				sVO.setRecipient(rs.getString("RECIPIENT"));
				sVO.setPhone(rs.getString("PHONE"));
				sVO.setAddress(rs.getString("ADDRESS"));
				sVO.setAddress2(rs.getString("ADDRESS2"));
				sVO.setMemo(rs.getString("MEMO"));
				sVO.setStatus(rs.getString("STATUS"));
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return sVO;
	}

}
