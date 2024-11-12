package manager.saleslist;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;

public class AdminSalesManagementDAO {

	private static AdminSalesManagementDAO apmDAO;

	private AdminSalesManagementDAO() {

	}// AdminProductManagementDAO

	public static AdminSalesManagementDAO getInstance() {
		if (apmDAO == null) {

			apmDAO = new AdminSalesManagementDAO();
		}

		return apmDAO;
	}// getInstance

	/**
	 * 총 게시물의 수 검색
	 * 
	 * @param sVO
	 * @return 게시물의 수
	 * @throws SQLException
	 */
	public int selectTotalCount(manager.util.SearchVO sVO) throws SQLException {
		int totalCount = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// 1. Connection 얻기
			con = dbCon.getConn();

			// 2. 쿼리문 작성
			StringBuilder selectCount = new StringBuilder();
			selectCount.append("SELECT COUNT(*) AS TOTAL_COUNT ").append("FROM ORDERS a ")
					.append("LEFT JOIN DELIVERY b ON a.ORDER_ID = b.ORDER_ID ");

			// 바인드 변수를 위한 리스트
			List<String> parameters = new ArrayList<>();

			// 3. 주문상태 검색 조건
			if (sVO.getSaleStatus() != null && !sVO.getSaleStatus().trim().isEmpty()) {
				selectCount.append("WHERE a.ORDER_STATUS = ? ");
				parameters.add(sVO.getSaleStatus());
			}

			// 5. 조회기간 검색 조건
			if (sVO.getStartDate() != null && sVO.getEndDate() != null) {
				selectCount.append(" AND ").append(" a.ORDER_DATE BETWEEN ? AND ? ");
				parameters.add(sVO.getStartDate());
				parameters.add(sVO.getEndDate());
			}

			// 5. PreparedStatement 준비
			pstmt = con.prepareStatement(selectCount.toString());

			// 6. 파라미터 바인딩
			for (int i = 0; i < parameters.size(); i++) {
				pstmt.setString(i + 1, parameters.get(i));
			}

			// 7. 쿼리 실행 후 결과 얻기
			rs = pstmt.executeQuery();

			if (rs.next()) {
				totalCount = rs.getInt("TOTAL_COUNT");
			}
		} finally {
			// 8. 연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		}

		return totalCount;
	}// selectTotalCount

	public int deleteOrders(int[] orderIds) throws SQLException {

		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder deleteOrders = new StringBuilder();
			deleteOrders.append("	delete from orders	").append("		where ORDER_ID = ?		");

			pstmt = con.prepareStatement(deleteOrders.toString());

			// orderIds 배열의 각 항목에 대해 반복하여 업데이트
			for (int orderId : orderIds) {
				// 바인드 변수에 값 설정
				pstmt.setInt(1, orderId);

				// 쿼리문 수행 후 결과 얻기
				rowCnt += pstmt.executeUpdate();
			}

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;

	}// deleteOrders

	/**
	 * 배송상태 변경
	 * 
	 * @param saleStatus
	 * @param productIds
	 * @return
	 * @throws SQLException
	 */
	public int updateDeliveryStatus(String deliveryStatus, int[] orderIds) throws SQLException {
		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();
			// 쿼리문 생성 객체 얻기
			String updateDeliveryStatus = "UPDATE DELIVERY SET STATUS = ? WHERE ORDER_ID = ?";
			pstmt = con.prepareStatement(updateDeliveryStatus);

			// orderIds 배열의 각 항목에 대해 반복하여 업데이트
			for (int orderId : orderIds) {
				// 바인드 변수에 값 설정
				pstmt.setString(1, deliveryStatus);
				pstmt.setInt(2, orderId);

				// 쿼리문 수행 후 결과 얻기
				rowCnt += pstmt.executeUpdate();
			}
		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;

	}// updateDeliveryStatus

	/**
	 * 주문상태 변경
	 * 
	 * @param saleStatus
	 * @param productIds
	 * @return
	 * @throws SQLException
	 */
	public int updateOrderStatus(String orderStatus, int[] orderIds) throws SQLException {
		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();
			// 쿼리문 생성 객체 얻기
			String updateOrderStatus = "	update ORDERS set ORDER_STATUS = ? where ORDER_ID=? 	";
			pstmt = con.prepareStatement(updateOrderStatus);

			// orderIds 배열의 각 항목에 대해 반복하여 업데이트
			for (int orderId : orderIds) {
				// 바인드 변수에 값 설정
				pstmt.setString(1, orderStatus);
				pstmt.setInt(2, orderId);

				// 쿼리문 수행 후 결과 얻기
				rowCnt += pstmt.executeUpdate();
			}
		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;

	}// updateOrderStatus

	/**
	 * 주문목록을 조회하는 method
	 * 
	 * @return list
	 * @throws SQLException
	 */
	public List<OrderVO> selectALLSalesList() throws SQLException {
		List<OrderVO> list = new ArrayList<>(); // 리스트 초기화

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();

			// 쿼리문 생성
			StringBuilder selectALLSalesList = new StringBuilder();
			selectALLSalesList.append(
					"		select a.ORDER_ID as order_ID, a.ORDER_NAME as order_name, a.ORDER_STATUS as order_status, b.STATUS as dilivery_status, a.USER_ID as user_id		")
					.append("		from ORDERS a, DELIVERY b			")
					.append("		where a.ORDER_ID = b.ORDER_ID		");

			pstmt = con.prepareStatement(selectALLSalesList.toString());
			rs = pstmt.executeQuery(); // 쿼리 실행 및 ResultSet 생성
			OrderVO oVO = null;

			// 결과 처리
			while (rs.next()) {
				oVO = new OrderVO();

				oVO.setOrderId(rs.getInt("ORDER_ID"));
				oVO.setOrderName(rs.getString("ORDER_NAME"));
				oVO.setOrderStatus(rs.getString("ORDER_STATUS"));
				oVO.setShippingStatus(rs.getString("DILIVERY_STATUS"));
				oVO.setUserId(rs.getString("USER_ID"));

				list.add(oVO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectALLSalesList

	/**
	 * 주문 리스트 검색
	 * 
	 * @param sVO
	 * @return
	 * @throws SQLException
	 */
	public List<OrderVO> selectBoard(manager.util.SearchVO sVO) throws SQLException {
		List<OrderVO> list = new ArrayList<>();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// 1. connection 얻기
			con = dbCon.getConn();

			// 2. 쿼리문 생성 객체
			StringBuilder selectSalesList = new StringBuilder();
			selectSalesList.append("SELECT ORDER_ID, ORDER_NAME, ORDER_STATUS, STATUS, USER_ID, ORDER_DATE ").append(
					"FROM (SELECT a.ORDER_ID, a.ORDER_NAME, a.ORDER_STATUS, b.STATUS, a.USER_ID, a.ORDER_DATE, ")
					.append("ROW_NUMBER() OVER (ORDER BY a.ORDER_DATE DESC) AS rnum ").append("FROM ORDERS a ")
					.append("LEFT JOIN DELIVERY b ON a.ORDER_ID = b.ORDER_ID ").append("WHERE 1=1 ");

			// 3. 바인드 변수를 위한 리스트
			List<String> parameters = new ArrayList<>();

			// 4. 주문상태 검색 조건
			if (sVO.getOrderStatus() != null && !sVO.getOrderStatus().trim().isEmpty()) {
				selectSalesList.append("AND a.ORDER_STATUS = ? ");
				parameters.add(sVO.getOrderStatus());
			}

			// 5. 조회기간 검색 조건
			if (sVO.getStartDate() != null && !sVO.getStartDate().trim().isEmpty() && sVO.getEndDate() != null
					&& !sVO.getEndDate().trim().isEmpty()) {
				selectSalesList.append("AND a.ORDER_DATE BETWEEN ? AND ? ");
				parameters.add(sVO.getStartDate());
				parameters.add(sVO.getEndDate());
			}

			// 6. 페이징 처리 (ROW_NUMBER) 조건 추가
			selectSalesList.append(") WHERE rnum BETWEEN ? AND ?");

			// 7. PreparedStatement 준비
			pstmt = con.prepareStatement(selectSalesList.toString());

			// 8. 파라미터 바인딩
			int bindIndex = 1;
			for (String param : parameters) {
				pstmt.setString(bindIndex++, param);
			}

			// 9. 페이징 처리를 위한 시작번호와 끝번호 설정
			pstmt.setInt(bindIndex++, sVO.getStartNum());
			pstmt.setInt(bindIndex, sVO.getEndNum());

			// 10. 쿼리문 수행 후 결과 얻기
			rs = pstmt.executeQuery();

			// 11. 결과 처리
			while (rs.next()) {
				OrderVO oVO = new OrderVO();
				oVO.setOrderId(rs.getInt("ORDER_ID"));
				oVO.setOrderName(rs.getString("ORDER_NAME"));
				oVO.setOrderStatus(rs.getString("ORDER_STATUS"));
				oVO.setShippingStatus(rs.getString("STATUS"));
				oVO.setUserId(rs.getString("USER_ID"));
				oVO.setOrderDate(rs.getDate("ORDER_DATE"));

				list.add(oVO);
			}

		} finally {
			// 12. 연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}

	/**
	 * 총 DB 개수의 검색
	 * 
	 * @return 총 DB 개수
	 * @throws SQLException
	 */
	public int statusTotalCount() throws SQLException {
		int totalCount = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			StringBuilder statusTotalCount = new StringBuilder();
			statusTotalCount.append("SELECT COUNT(*) AS TOTAL_COUNT ").append("FROM ORDERS a ")
					.append("LEFT JOIN DELIVERY b ON a.ORDER_ID = b.ORDER_ID");

			pstmt = con.prepareStatement(statusTotalCount.toString());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalCount = rs.getInt("TOTAL_COUNT");
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return totalCount;
	}// statusTotalCount

	/**
	 * 주문상태 개수 구하기
	 * 
	 * @param ordersStatus
	 * @return 게시물의 수
	 * @throws SQLException
	 */
	public int selectOrdersStatusCount(String ordersStatus) throws SQLException {
		int totalCount = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// 1. Connection 얻기
			con = dbCon.getConn();

			// 2. 쿼리문 생성
			StringBuilder selectOrdersStatusCount = new StringBuilder();
			selectOrdersStatusCount.append("SELECT COUNT(*) AS TOTAL_COUNT ").append("FROM ORDERS a ")
					.append("LEFT JOIN DELIVERY b ON a.ORDER_ID = b.ORDER_ID ").append("WHERE a.ORDER_STATUS = ?");

			// 3. PreparedStatement 준비
			pstmt = con.prepareStatement(selectOrdersStatusCount.toString());
			pstmt.setString(1, ordersStatus);

			// 4. 쿼리문 실행 후 결과 얻기
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalCount = rs.getInt("TOTAL_COUNT");
			}
		} finally {
			// 5. 연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		}
		return totalCount;
	}// selectOrdersStatusCount

	/**
	 * orderID를 받아와서 주문상태, 배송상태 변경
	 * 
	 * @param orderStatus
	 * @param deliveryStatus
	 * @param orderIds
	 * @return
	 * @throws SQLException
	 */
	public int updateDeliveryOrderStatus(String orderStatus, String deliveryStatus, int[] orderIds)
			throws SQLException {
		int rowCnt = 0;
		Connection con = null;
		PreparedStatement pstmtOrder = null;
		PreparedStatement pstmtDelivery = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			con.setAutoCommit(false); // 트랜잭션 시작

			// 주문상태가 있을 경우
			if (orderStatus != null && !orderStatus.isEmpty()) {
				String updateOrderSql = "UPDATE ORDERS SET ORDER_STATUS = ? WHERE ORDER_ID = ?";
				pstmtOrder = con.prepareStatement(updateOrderSql);

				for (int orderId : orderIds) {
					pstmtOrder.setString(1, orderStatus);
					pstmtOrder.setInt(2, orderId);
					rowCnt += pstmtOrder.executeUpdate();
				}
			}

			// 배송상태가 있을 경우
			if (deliveryStatus != null && !deliveryStatus.isEmpty()) {
				String updateDeliverySql = "UPDATE DELIVERY SET STATUS = ? WHERE ORDER_ID = ?";
				pstmtDelivery = con.prepareStatement(updateDeliverySql);

				for (int orderId : orderIds) {
					pstmtDelivery.setString(1, deliveryStatus);
					pstmtDelivery.setInt(2, orderId);
					rowCnt += pstmtDelivery.executeUpdate();
				}
			}

			con.commit(); // 트랜잭션 커밋
		} catch (SQLException e) {
			if (con != null)
				con.rollback();
			throw e;
		} finally {
			if (con != null)
				con.setAutoCommit(true);
			if (pstmtDelivery != null)
				pstmtDelivery.close();
			dbCon.dbClose(null, pstmtOrder, con);
		}

		return rowCnt;
	}

}
