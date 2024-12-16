package manage.dashboard;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;

public class AdminDashBoardDAO {
	private static AdminDashBoardDAO adbDAO;

	private AdminDashBoardDAO() {

	}// constructor

	public static AdminDashBoardDAO getInstance() {
		if (adbDAO == null) {
			adbDAO = new AdminDashBoardDAO();
		} // end if
		return adbDAO;

	}// getInstance

	/**
	 * 신규주문수를 받아서 대시보드에 출력하는 일 orders 테이블에서 order_status를 가져온다 이때 '결제완료' 인 상태를 가져오면
	 * 된다
	 * 
	 * @return
	 */
	public int selectCountNewOrders() throws SQLException {
		int newOrderCnt = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		try {
			con = dbCon.getConn();

			StringBuilder selectNewOrder = new StringBuilder();
			selectNewOrder.append("  	select count(order_status) ").append(" 	from ORDERS  ")
					.append("WHERE order_status = '결제완료'  ");

			pstmt = con.prepareStatement(selectNewOrder.toString());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				newOrderCnt = rs.getInt(1);
			} // end if

		} finally {
			dbCon.dbClose(rs, pstmt, con);

		}
		System.out.println("신규주문" + newOrderCnt);
		return newOrderCnt;
	}// selectCountNewOrders

	/**
	 * 
	 * 배송상황에 대해 체크하여 대시보드에 출력하는 일
	 * 
	 * @return shippingCnt
	 */
	public List<DeliveryStatusVO> selectDeliveryStatus() throws SQLException {
		List<DeliveryStatusVO> list = new ArrayList<>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			StringBuilder selectStatus = new StringBuilder();
			selectStatus.append("SELECT status, COUNT(*) AS count ").append("FROM DELIVERY ").append("GROUP BY status ")
					.append("ORDER BY CASE ").append("WHEN status = '배송준비' THEN 1 ")// 이 순서를 보장하기 위해 when then , order
																					// by 사용.
					.append("WHEN status = '배송중' THEN 2 ").append("WHEN status = '배송완료' THEN 3 ").append("ELSE 4 END");
			pstmt = con.prepareStatement(selectStatus.toString());
			rs = pstmt.executeQuery();

			while (rs.next()) {
				String status = rs.getString("status");
				int count = rs.getInt("count");
				list.add(new DeliveryStatusVO(status, count));
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		System.out.println(list);

		return list;

	}// selectCountOrdersByShippingStatus

	/**
	 * 구매확정 건수를 받아 대시보드에 출력하는 일
	 * 
	 * @return confirmedCnt
	 */
	public int selectCountConfirmed() throws SQLException {
		int confirmedCnt = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();
		ResultSet rs = null;
		try {
			con = dbCon.getConn();

			StringBuilder selectConfirm = new StringBuilder();
			selectConfirm.append("  	select count(order_status) ").append(" 	from ORDERS  			   ")
					.append("	WHERE order_status = '구매확정'  ");

			pstmt = con.prepareStatement(selectConfirm.toString());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				confirmedCnt = rs.getInt(1);
			} // end if

		} finally {
			dbCon.dbClose(rs, pstmt, con);

		}
		System.out.println("구매확정" + confirmedCnt);
		return confirmedCnt;

	}// selectCountConfirmed

	/**
	 * 일일 매출을 담아서 대시보드 그래프에 출력하는 일
	 * 
	 * @return list
	 */
	public List<SaleDataVO> selectSumDailySales() throws SQLException {
		List<SaleDataVO> list = new ArrayList<SaleDataVO>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			StringBuilder selectDailySales = new StringBuilder();
			selectDailySales.append("       SELECT TRUNC(ORDER_DATE) AS order_date,  ")
					.append("	   SUM(TOTAL_AMOUNT) AS total_amount 	").append("	   FROM orders    ")
					.append(" 	   WHERE ORDER_DATE >= TRUNC(SYSDATE) - 6 ")
					.append("       AND ORDER_DATE < TRUNC(SYSDATE) + 1").append("       GROUP BY TRUNC(ORDER_DATE)	")
					.append("	   ORDER BY order_date ASC");

			pstmt = con.prepareStatement(selectDailySales.toString());
			rs = pstmt.executeQuery();

			while (rs.next()) {
				Date sqlDate = rs.getDate("order_date"); // SQL Date 가져오기
				SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");
				String date = sdf.format(sqlDate); // 날짜 포맷 변환
				int amount = rs.getInt("total_amount");
				list.add(new SaleDataVO(date, amount));
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		System.out.println("일일 매출 데이터: " + list);
		return list;
	}// selectSumDailySales

	/**
	 * 미답변 문의 숫자를 반환하는 일.
	 * 
	 * @return
	 */
	public int selectinquiryCnt() throws SQLException {
		int inquiryCnt = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectCnt = new StringBuilder();
			selectCnt.append("	select count(*) ").append("	from INQUIRY ").append("	where status = '미답변' ")
					.append("	or status IS NULL ").append("	or status = ''   ");

			pstmt = con.prepareStatement(selectCnt.toString());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				inquiryCnt = rs.getInt(1);
			} // end if

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // finally

		System.out.println("미답변 문의" + inquiryCnt);
		return inquiryCnt;
	}// inquiryCnt

	/**
	 * 총 회원수를 반환하는 일
	 * 
	 * @return
	 * @throws SQLException
	 */
	public int selectTotalMemberCnt() throws SQLException {
		int memberCnt = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectCnt = new StringBuilder();
			selectCnt.append(" 	select count(user_id)	").append(" 	from MEMBER	");
			pstmt = con.prepareStatement(selectCnt.toString());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				memberCnt = rs.getInt(1);
			} // end if

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // finally

		System.out.println("총 회원수 " + memberCnt);
		return memberCnt;
	}// inquiryCnt

	public int selectNewMemberCnt() throws SQLException {
		int memberCnt = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectCnt = new StringBuilder();
			selectCnt.append(" 	select count(user_id)	").append(" 	from MEMBER	")
					.append("    where trunc(join_date)=trunc(sysdate)   ");
			pstmt = con.prepareStatement(selectCnt.toString());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				memberCnt = rs.getInt(1);
			} // end if

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // finally

		System.out.println("신규 회원수 " + memberCnt);
		return memberCnt;
	}// inquiryCnt

	/**
	 * 주문취소 건수를 가져오는 일
	 * 
	 * @return 주문취소건수
	 * @throws SQLException
	 */
	public int selectOrderCancel() throws SQLException {
		int cancelCnt = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectCnt = new StringBuilder();
			selectCnt.append(" 	select count(order_id)	").append(" 	from ORDER_CANCEL	");
			pstmt = con.prepareStatement(selectCnt.toString());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				cancelCnt = rs.getInt(1);
			} // end if

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // finally

		System.out.println("주문취소 수 " + cancelCnt);
		return cancelCnt;
	}// inquiryCnt

}// class
