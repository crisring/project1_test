package manager.saleslist;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import kr.co.sist.dao.DbConnection;
import kr.co.sist.user.board.BoardVO;
import kr.co.sist.user.board.SearchVO;
import kr.co.sist.util.BoardUtil;
import manager.productlist.AdminProductVO;
import manager.productlist.OrderVO;
import manager.productlist.ProductVO;

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
		// 1.JNDI 사용객체 생성
		// 2.DBCP에서 DataSource 얻기

		try {
			// 3.Connection얻기
			con = dbCon.getConn();
			// 4.쿼리문생성객체 얻기
			StringBuilder selectCount = new StringBuilder();
			selectCount.append("		SELECT COUNT(*) AS TOTAL_COUNT	 	")
					.append("		FROM ORDERS a, DELIVERY b			")
					.append("		WHERE a.ORDER_ID = b.ORDER_ID		");

			// 6.쿼리문 수행후 결과 얻기
			pstmt = con.prepareStatement(selectCount.toString());
			rs = pstmt.executeQuery();

			if (rs.next()) {
				totalCount = rs.getInt("TOTAL_COUNT");
			} // end if
		} finally {
			// 7.연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end finally
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

	public List<OrderVO> selectBoard(manager.util.SearchVO sVO) throws SQLException {
		List<OrderVO> list = new ArrayList<OrderVO>();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();

			// 쿼리문 생성 객체
			StringBuilder selectSalesList = new StringBuilder();
			selectSalesList.append("SELECT ORDER_ID, ORDER_NAME, ORDER_STATUS, STATUS, USER_ID ")
					.append("FROM (SELECT a.ORDER_ID, a.ORDER_NAME, a.ORDER_STATUS, b.STATUS, a.USER_ID, ")
					.append("ROW_NUMBER() OVER (ORDER BY a.ORDER_ID) AS rnum ").append("FROM ORDERS a ")
					.append("JOIN DELIVERY b ON a.ORDER_ID = b.ORDER_ID ");

			// 동적 쿼리 조건 추가
			List<String> parameters = new ArrayList<>();

			// 주문 상태 검색
			if (sVO.getOrderStatus() != null && !sVO.getOrderStatus().trim().isEmpty()) {
				selectSalesList.append(" AND a.ORDER_STATUS = ? ");
				parameters.add(sVO.getOrderStatus());
			}

			// 조회 기간 검색 (startDate와 endDate가 있을 때)
			if (sVO.getStartDate() != null && sVO.getEndDate() != null) {
				selectSalesList.append(" AND a.ORDER_DATE BETWEEN ? AND ? ");
				parameters.add(sVO.getStartDate());
				parameters.add(sVO.getEndDate());
			}

			selectSalesList.append(") WHERE rnum BETWEEN ? AND ?");

			pstmt = con.prepareStatement(selectSalesList.toString());

			// 바인드 변수 설정
			int bindIndex = 1;
			for (String param : parameters) {
				pstmt.setString(bindIndex++, param);
			}

			// 페이징 처리를 위한 시작번호와 끝번호 설정
			pstmt.setInt(bindIndex++, sVO.getStartNum());
			pstmt.setInt(bindIndex, sVO.getEndNum());

			// 쿼리문 수행 후 결과 얻기
			rs = pstmt.executeQuery();

			OrderVO oVO = null;
			while (rs.next()) {
				oVO = new OrderVO();

				oVO.setOrderId(rs.getInt("ORDER_ID"));
				oVO.setOrderName(rs.getString("ORDER_NAME"));
				oVO.setOrderStatus(rs.getString("ORDER_STATUS"));
				oVO.setShippingStatus(rs.getString("STATUS"));
				oVO.setUserId(rs.getString("USER_ID"));

				list.add(oVO);
			} // end while

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return list;
	} // selectBoard 수정 끝

	/**
	 * 총 DB 개수의 검색
	 * 
	 * @param sVO
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
			statusTotalCount.append("		SELECT COUNT(*) AS TOTAL_COUNT	 	")
					.append("		FROM ORDERS a, DELIVERY b			")
					.append("		WHERE a.ORDER_ID = b.ORDER_ID		");

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
	 * @param sVO
	 * @return 게시물의 수
	 * @throws SQLException
	 */
	public int selectOrdersStatusCount(String salesStatus) throws SQLException {
		int totalCount = 0;

		// 1.JNDI 사용객체 생성
		// 2.DBCP에서 DataSource 얻기
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// 3.Connection얻기
			con = dbCon.getConn();
			// 4.쿼리문생성객체 얻기
			StringBuilder selectCount = new StringBuilder();
			selectCount.append("	select count(PRODUCT_ID) cnt from PRODUCTS where SALES_STATUS=? 	");

			pstmt = con.prepareStatement(selectCount.toString());
			pstmt.setString(1, salesStatus);

			// 6.쿼리문 수행후 결과 얻기
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalCount = rs.getInt("cnt");
			} // end if
		} finally {
			// 7.연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end finally
		return totalCount;
	}// selectOrdersStatusCount
}
