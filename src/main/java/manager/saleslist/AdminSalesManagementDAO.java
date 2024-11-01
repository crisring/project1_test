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
import manager.productlist.OrderVO;

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
			selectCount.append("select count(order_id) cnt from orders ");

			// dynamic query : 검색 키워드를 판단 기준으로 where절이 동적생성되어야한다.
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				selectCount.append(" where instr(").append(manager.util.BoardUtil.numToField(sVO.getField()))
						.append(",?) != 0");
			} // end if

			pstmt = con.prepareStatement(selectCount.toString());
			// 5.바인드 변수에 값 설정
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				pstmt.setString(1, sVO.getKeyword());
			} // end if

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
	}// selectTotalCount

	public List<ProductVO> selectByDate(Date createdAt) {
		List<ProductVO> list = null;

		return list;
	}// selectByDate

	public List<ProductVO> selectByOrderStatus(AdminProductVO aPVO) {
		List<ProductVO> list = null;

		return list;
	}// selectByOrderStatus

	public int deleteProduct(int productId) {

		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder deleteBoard = new StringBuilder();
			deleteBoard.append("	delete from	board	").append("	where	num=? and writer=?");

			pstmt = con.prepareStatement(deleteBoard.toString());
			// 바인드 변수에 값 설정
			pstmt.setInt(1, bVO.getNum());
			pstmt.setString(2, bVO.getWriter());

			// 쿼리문 수행 후 결과 얻기
			rowCnt = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;

	}// deleteProduct

	public List<ProductVO> getSalesList(Date startDate, Date endDate, String orderStatus) {

		List<ProductVO> list = null;

		return list;

	}// getSalesList

	public int updateDeliveryStatus(AdminProductVO apVO) {

		int totalCnt = 0;

		return totalCnt;

	}// updateDeliveryStatus

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
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder selectSalesList = new StringBuilder();
			selectSalesList.append("		select ORDER_ID, ORDER_NAME, ORDER_STATUS, STATUS, USER_ID		").append(
					"		from(select a.ORDER_ID, a.ORDER_NAME, a.ORDER_STATUS, b.STATUS, a.USER_ID, ROW_NUMBER() OVER (ORDER BY a.ORDER_ID) AS rnum			")
					.append("		from ORDERS a		")
					.append("		join DELIVERY b ON a.ORDER_ID = b.ORDER_ID		");

			// dynamic query : 검색 키워드를 판단 기준으로 where절이 동적생성되어야한다.
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				selectSalesList.append(" where instr(").append(manager.util.BoardUtil.numToField(sVO.getField()))
						.append(",?) != 0");
			} // end if

			selectSalesList.append("	)where rnum between ? and ?	");

			pstmt = con.prepareStatement(selectSalesList.toString());

			// 바인드 변수에 값 설정
			int bindInd = 0;
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				pstmt.setString(++bindInd, sVO.getKeyword());
			} // end if
			pstmt.setInt(++bindInd, sVO.getStartNum());
			pstmt.setInt(++bindInd, sVO.getEndNum());

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
	}// selectBoard

}
