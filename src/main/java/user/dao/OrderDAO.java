package user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;
import manage.saleslist.OrderVO;
import user.vo.OrderListVO;
import user.vo.OrderProductVO;

public class OrderDAO {

	/**
	 * 새로운 주문과 주문 상품을 등록합니다.
	 */
	public int insertOrder(OrderVO oVO, OrderProductVO opVO, int shippingId) throws SQLException {
		int orderId = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			con.setAutoCommit(false);

			// MAX 값을 이용한 ORDER_ID 생성
			String selectMaxOrderId = "SELECT NVL(MAX(ORDER_ID), 0) + 1 FROM ORDERS";
			pstmt = con.prepareStatement(selectMaxOrderId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				orderId = rs.getInt(1);
			}

			// 1. 주문 정보 저장
			StringBuilder insertOrderQuery = new StringBuilder();
			insertOrderQuery.append(" INSERT INTO ORDERS ").append(" (ORDER_ID, USER_ID, ORDER_NAME, ORDER_DATE, ")
					.append(" ORDER_STATUS, TOTAL_AMOUNT, ORDER_FLAG) ").append(" VALUES (?, ?, ?, ?, ?, ?, ?) ");

			pstmt = con.prepareStatement(insertOrderQuery.toString());

			int idx = 1;
			pstmt.setInt(idx++, orderId);
			pstmt.setString(idx++, oVO.getUserId());
			pstmt.setString(idx++, oVO.getOrderName());
			pstmt.setDate(idx++, oVO.getOrderDate());
			pstmt.setString(idx++, oVO.getOrderStatus());
			pstmt.setInt(idx++, oVO.getTotalAmount());
			pstmt.setString(idx++, oVO.getOrderFlag());

			int result = pstmt.executeUpdate();

			if (result > 0) {
				// 2. 주문 상품 정보 저장
				StringBuilder insertProductQuery = new StringBuilder();
				insertProductQuery.append(" INSERT INTO ORDERED_PRODUCT ")
						.append(" (ORDER_ITEM_ID, ORDER_ID, PRODUCT_ID, ").append(" PRICE, QUANTITY) ")
						.append(" SELECT NVL(MAX(ORDER_ITEM_ID), 0) + 1, ?, ?, ?, ? ").append(" FROM ORDERED_PRODUCT ");

				pstmt = con.prepareStatement(insertProductQuery.toString());

				idx = 1;
				pstmt.setInt(idx++, orderId);
				pstmt.setInt(idx++, opVO.getProductId());
				pstmt.setInt(idx++, opVO.getPrice());
				pstmt.setInt(idx++, opVO.getQuantity());

				result = pstmt.executeUpdate();

				// 3. 배송지 정보 업데이트
				if (result > 0 && shippingId > 0) {
					String updateDeliveryQuery = "UPDATE DELIVERY SET ORDER_ID = ? WHERE SHIPPING_ID = ?";
					pstmt = con.prepareStatement(updateDeliveryQuery);
					pstmt.setInt(1, orderId);
					pstmt.setInt(2, shippingId);

					result = pstmt.executeUpdate();

					if (result > 0) {
						con.commit();
						return orderId;
					}
				}
			}
			con.rollback();

		} catch (SQLException e) {
			if (con != null) {
				con.rollback();
			}
			throw e;
		} finally {
			if (con != null) {
				con.setAutoCommit(true);
			}
			dbCon.dbClose(rs, pstmt, con);
		}

		return 0; // 실패 시 0 반환
	}

	/**
	 * 주문 상태를 업데이트합니다.
	 */
	public int updateOrderStatus(String orderId, String orderStatus) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			String updateQuery = " UPDATE ORDERS SET ORDER_STATUS = ? WHERE ORDER_ID = ? ";

			pstmt = con.prepareStatement(updateQuery);
			pstmt.setString(1, orderStatus);
			pstmt.setString(2, orderId);

			result = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}

		return result;
	}

	/**
	 * 특정 주문을 조회합니다.
	 */
	public OrderVO selectOrder(String orderId) throws SQLException {
		OrderVO oVO = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectQuery = new StringBuilder();
			selectQuery.append(" SELECT ORDER_ID, USER_ID, ORDER_NAME, ")
					.append(" ORDER_DATE, ORDER_STATUS, TOTAL_AMOUNT, ORDER_FLAG ").append(" FROM ORDERS ")
					.append(" WHERE ORDER_ID = ? ");

			pstmt = con.prepareStatement(selectQuery.toString());
			pstmt.setString(1, orderId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				oVO = new OrderVO();
				oVO.setOrderId(rs.getInt("ORDER_ID"));
				oVO.setUserId(rs.getString("USER_ID"));
				oVO.setOrderName(rs.getString("ORDER_NAME"));
				oVO.setOrderDate(rs.getDate("ORDER_DATE"));
				oVO.setOrderStatus(rs.getString("ORDER_STATUS"));
				oVO.setTotalAmount(rs.getInt("TOTAL_AMOUNT"));
				oVO.setOrderFlag(rs.getString("ORDER_FLAG"));
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return oVO;
	}

	/**
	 * 사용자의 주문 목록을 조회합니다.
	 */
	public List<OrderVO> selectOrdersByUserId(String userId) throws SQLException {
		List<OrderVO> list = new ArrayList<>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectQuery = new StringBuilder();
			selectQuery.append(" SELECT ORDER_ID, USER_ID, ORDER_NAME, ")
					.append(" ORDER_DATE, ORDER_STATUS, TOTAL_AMOUNT, ORDER_FLAG ").append(" FROM ORDERS ")
					.append(" WHERE USER_ID = ? ").append(" ORDER BY ORDER_DATE DESC ");

			pstmt = con.prepareStatement(selectQuery.toString());
			pstmt.setString(1, userId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				OrderVO oVO = new OrderVO();
				oVO.setOrderId(rs.getInt("ORDER_ID"));
				oVO.setUserId(rs.getString("USER_ID"));
				oVO.setOrderName(rs.getString("ORDER_NAME"));
				oVO.setOrderDate(rs.getDate("ORDER_DATE"));
				oVO.setOrderStatus(rs.getString("ORDER_STATUS"));
				oVO.setTotalAmount(rs.getInt("TOTAL_AMOUNT"));
				oVO.setOrderFlag(rs.getString("ORDER_FLAG"));
				list.add(oVO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}

	/**
	 * 주문 완료 후 배송지 정보에 ORDER_ID를 업데이트합니다.
	 */
	public int updateShippingOrderId(int orderId, int shippingId) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			con.setAutoCommit(false);

			String updateQuery = "UPDATE DELIVERY SET ORDER_ID = ? WHERE SHIPPING_ID = ?";

			pstmt = con.prepareStatement(updateQuery);
			pstmt.setInt(1, orderId);
			pstmt.setInt(2, shippingId);

			result = pstmt.executeUpdate();

			if (result > 0) {
				con.commit();
			} else {
				con.rollback();
			}

		} catch (SQLException e) {
			if (con != null)
				con.rollback();
			throw e;
		} finally {
			if (con != null)
				con.setAutoCommit(true);
			dbCon.dbClose(null, pstmt, con);
		}

		return result;
	}

	/**
	 * userId에 해당하는 주문목록을 조회하는 method
	 * 
	 * @param userId
	 * @return
	 * @throws SQLException
	 */
	public List<OrderListVO> SelectOrderList(String userId) throws SQLException {
		List<OrderListVO> list = new ArrayList<OrderListVO>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder select = new StringBuilder();
			select.append("  select  DISTINCT o.order_id, d.status as shippingstatus, p.name as productname, ")
					.append("          p.main_img as imgname, o.order_status  ").append("  from    orders o  ")
					.append("  join    delivery d on o.order_id = d.order_id  ") // 수정된 JOIN 조건
					.append("  join    ordered_product op on o.order_id = op.order_id  ")
					.append("  join    products p on op.product_id = p.product_id  ")
					.append("  where   o.user_id = ?  ");

			pstmt = con.prepareStatement(select.toString());
			pstmt.setString(1, userId);

			rs = pstmt.executeQuery();

			OrderListVO olVO = null;
			while (rs.next()) {
				olVO = new OrderListVO();
				olVO.setOrderId(rs.getInt("order_id"));
				olVO.setShippingStatus(rs.getString("shippingstatus"));
				olVO.setProductName(rs.getString("productname"));
				olVO.setImgName(rs.getString("imgname"));
				olVO.setOrderStatus(rs.getString("order_status"));
				list.add(olVO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}

	/**
	 * 리뷰작성 process페이지에서 사용하기 위한 product_id를 구하는 메소드
	 * 
	 * @param orderId
	 * @return
	 * @throws SQLException
	 */
	public int selectProductId(String orderId) throws SQLException {
		int productId = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectProductId = new StringBuilder();
			selectProductId.append(" select op.product_id ").append(" from orders o ")
					.append(" join ordered_product op on o.order_id = op.order_id ").append(" where o.order_id = ? ");

			pstmt = con.prepareStatement(selectProductId.toString());
			pstmt.setString(1, orderId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				productId = rs.getInt("product_id");
			} // end if

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally
		return productId;
	}// selectProductId

	public int insertCancelReason(String orderId, String reason) throws SQLException {
		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder insertCancel = new StringBuilder();
			insertCancel.append("	insert 	into order_cancel(order_id, reason) ").append("	values	(?, ?) ");

			pstmt = con.prepareStatement(insertCancel.toString());

			pstmt.setString(1, orderId);
			pstmt.setString(2, reason);

			rowCnt = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;
	}// insertCancelReason

}