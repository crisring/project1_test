package manager.productlist;

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

public class AdminProductManagementDAO {

	private static AdminProductManagementDAO apmDAO;

	private AdminProductManagementDAO() {

	}// AdminProductManagementDAO

	public static AdminProductManagementDAO getInstance() {
		if (apmDAO == null) {

			apmDAO = new AdminProductManagementDAO();
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
			selectCount.append("	select count(PRODUCT_ID) cnt from PRODUCTS 	");

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

	/**
	 * 상품 번호로 조회하는 method
	 * 
	 * @param productId 상품번호
	 * @return pVO
	 * @throws SQLException
	 */
	public ProductVO selectByProductId(int productId) throws SQLException {
		ProductVO pVO = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder selectByProductId = new StringBuilder();

			selectByProductId.append(
					"	select PRODUCT_ID, NAME, MODEL_NAME, BRAND, SALES_STATUS, STOCK_QUANTITY, PRICE, DISCOUNT_PRICE, CREATED_AT, CREATED_AT+30 as FINISH_AT	 	")
					.append("	from PRODUCTS	").append("		where PRODUCT_ID =?		");
			pstmt = con.prepareStatement(selectByProductId.toString());

			pstmt.setInt(1, productId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				pVO = new ProductVO();

				pVO.setProductId(rs.getInt("PRODUCT_ID"));
				pVO.setProductName(rs.getString("NAME"));
				pVO.setModelName(rs.getString("MODEL_NAME"));
				pVO.setBrand(rs.getString("BRAND"));
				pVO.setSaleStatus(rs.getString("SALES_STATUS"));
				pVO.setStockQuantity(rs.getInt("STOCK_QUANTITY"));
				pVO.setPrice(rs.getInt("PRICE"));
				pVO.setDiscount_price(rs.getInt("DISCOUNT_PRICE"));
				pVO.setCreateAt(rs.getDate("CREATED_AT"));
				pVO.setFinishAt(rs.getDate("FINISH_AT"));

			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return pVO;
	}// selectByProductId

	public ProductVO selectByBrand(String brand) throws SQLException {
		ProductVO pVO = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder selectByProductId = new StringBuilder();

			selectByProductId.append(
					"	select PRODUCT_ID, NAME, MODEL_NAME, BRAND, SALES_STATUS, STOCK_QUANTITY, PRICE, DISCOUNT_PRICE, CREATED_AT, CREATED_AT+30 as FINISH_AT	 	")
					.append("	from PRODUCTS	").append("		where BRAND =?		");
			pstmt = con.prepareStatement(selectByProductId.toString());

			pstmt.setString(1, brand);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				pVO = new ProductVO();

				pVO.setProductId(rs.getInt("PRODUCT_ID"));
				pVO.setProductName(rs.getString("NAME"));
				pVO.setModelName(rs.getString("MODEL_NAME"));
				pVO.setBrand(rs.getString("BRAND"));
				pVO.setSaleStatus(rs.getString("SALES_STATUS"));
				pVO.setStockQuantity(rs.getInt("STOCK_QUANTITY"));
				pVO.setPrice(rs.getInt("PRICE"));
				pVO.setDiscount_price(rs.getInt("DISCOUNT_PRICE"));
				pVO.setCreateAt(rs.getDate("CREATED_AT"));
				pVO.setFinishAt(rs.getDate("FINISH_AT"));

			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return pVO;
	}// selectByBrand

	public List<ProductVO> selectByDate(Date createdAt) {
		List<ProductVO> list = null;

		return list;
	}// selectByDate

	public List<ProductVO> selectByOrderStatus(AdminProductVO aPVO) {
		List<ProductVO> list = null;

		return list;
	}// selectByOrderStatus

	/**
	 * 상품을 모두 조회하는 method
	 * 
	 * @return list
	 * @throws SQLException
	 */
	public List<ProductVO> selectAllProduct() throws SQLException {
		List<ProductVO> list = new ArrayList<>(); // 리스트 초기화

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();

			// 쿼리문 생성
			StringBuilder selectAllProduct = new StringBuilder();
			selectAllProduct.append(
					"		select PRODUCT_ID, NAME, MODEL_NAME, BRAND, SALES_STATUS, STOCK_QUANTITY, PRICE, DISCOUNT_PRICE, CREATED_AT, CREATED_AT+30 as FINISH_AT			")
					.append("		FROM products		");

			pstmt = con.prepareStatement(selectAllProduct.toString());
			rs = pstmt.executeQuery(); // 쿼리 실행 및 ResultSet 생성
			ProductVO pVO = null;

			// 결과 처리
			while (rs.next()) {
				pVO = new ProductVO();

				pVO.setProductId(rs.getInt("PRODUCT_ID"));
				pVO.setProductName(rs.getString("NAME"));
				pVO.setModelName(rs.getString("MODEL_NAME"));
				pVO.setBrand(rs.getString("BRAND"));
				pVO.setSaleStatus(rs.getString("SALES_STATUS"));
				pVO.setStockQuantity(rs.getInt("STOCK_QUANTITY"));
				pVO.setPrice(rs.getInt("PRICE"));
				pVO.setDiscount_price(rs.getInt("DISCOUNT_PRICE"));
				pVO.setCreateAt(rs.getDate("CREATED_AT"));
				pVO.setFinishAt(rs.getDate("FINISH_AT"));

				list.add(pVO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectAllProduct

	public void insertProduct(ProductVO product) {

		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder insertBoard = new StringBuilder();
			insertBoard.append("insert into board(num,subject,content,writer,ip) ")
					.append("values( seq_board.nextval,?,?,?,?)");

			pstmt = con.prepareStatement(insertBoard.toString());
			// 바인드 변수에 값 설정
			pstmt.setString();

			// 쿼리문 수행 후 결과 얻기
			pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

	}// insertProduct

	public int updateProduct(ProductVO product) throws SQLException {
		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder updateBoard = new StringBuilder();
			updateBoard.append("	update	board	").append("	set		content=?	")
					.append("	where	num=? and writer=?");

			pstmt = con.prepareStatement(updateBoard.toString());
			// 바인드 변수에 값 설정

			// 쿼리문 수행 후 결과 얻기
			rowCnt = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;

	}// updateProduct

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

	public List<ProductVO> selectBoard(manager.util.SearchVO sVO) throws SQLException {
		List<ProductVO> list = new ArrayList<ProductVO>();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder selectBoard = new StringBuilder();
			selectBoard.append(
					"	select PRODUCT_ID, NAME, MODEL_NAME, BRAND, SALES_STATUS, STOCK_QUANTITY, PRICE, DISCOUNT_PRICE, CREATED_AT, CREATED_AT+30 as FINISH_AT	")
					.append("	from(select PRODUCT_ID, NAME, MODEL_NAME, BRAND, SALES_STATUS, STOCK_QUANTITY, PRICE, DISCOUNT_PRICE, CREATED_AT, CREATED_AT+30 as FINISH_AT\r\n"
							+ ", row_number() over( order by PRODUCT_ID) rnum	")
					.append("	FROM products	");

			// dynamic query : 검색 키워드를 판단 기준으로 where절이 동적생성되어야한다.
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				selectBoard.append(" where instr(").append(manager.util.BoardUtil.numToField(sVO.getField()))
						.append(",?) != 0");
			} // end if

			selectBoard.append("	)where rnum between ? and ?	");

			pstmt = con.prepareStatement(selectBoard.toString());
			// 바인드 변수에 값 설정
			int bindInd = 0;
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				pstmt.setString(++bindInd, sVO.getKeyword());
			} // end if
			pstmt.setInt(++bindInd, sVO.getStartNum());
			pstmt.setInt(++bindInd, sVO.getEndNum());

			// 쿼리문 수행 후 결과 얻기
			rs = pstmt.executeQuery();

			ProductVO pVO = null;
			while (rs.next()) {

				pVO = new ProductVO();

				pVO.setProductId(rs.getInt("PRODUCT_ID"));
				pVO.setProductName(rs.getString("NAME"));
				pVO.setModelName(rs.getString("MODEL_NAME"));
				pVO.setBrand(rs.getString("BRAND"));
				pVO.setSaleStatus(rs.getString("SALES_STATUS"));
				pVO.setStockQuantity(rs.getInt("STOCK_QUANTITY"));
				pVO.setPrice(rs.getInt("PRICE"));
				pVO.setDiscount_price(rs.getInt("DISCOUNT_PRICE"));
				pVO.setCreateAt(rs.getDate("CREATED_AT"));
				pVO.setFinishAt(rs.getDate("FINISH_AT"));

				list.add(pVO);

			} // end while

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return list;
	}// selectBoard

}
