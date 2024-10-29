package manager.productlist;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import kr.co.sist.dao.DbConnection;

public class AdminProductManagementDAO {

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
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return pVO;
	}// selectByProductId

	public List<ProductVO> selectByBrand(String brand) {
		List<ProductVO> list = null;

		return list;
	}// selectByBrand

	public List<ProductVO> selectByDate(Date createdAt) {
		List<ProductVO> list = null;

		return list;
	}// selectByDate

	public List<ProductVO> selectByOrderStatus(AdminProductVO aPVO) {
		List<ProductVO> list = null;

		return list;
	}// selectByOrderStatus

	public List<AdminProductVO> selectAllProduct(AdminProductVO aPVO) throws SQLException {
		List<AdminProductVO> list = new ArrayList<>(); // 리스트 초기화

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();

			// 쿼리문 생성
			StringBuilder selectAllProduct = new StringBuilder();
			selectAllProduct.append("SELECT PRODUCT_ID, NAME, MODEL_NAME, BRAND, STOCK_QUANTITY, PRICE, CREATED_AT ")
					.append("FROM products");

			pstmt = con.prepareStatement(selectAllProduct.toString());
			rs = pstmt.executeQuery(); // 쿼리 실행 및 ResultSet 생성

			// 결과 처리
			while (rs.next()) {
				aPVO = new AdminProductVO();

				list.add(aPVO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}

	public int insertProduct(ProductVO product) {

	}// insertProduct

	public int updateProduct(ProductVO product) {

	}// updateProduct

	public int deleteProduct(int productId) {

	}// deleteProduct

	public List<ProductVO> getSalesList(Date startDate, Date endDate, String orderStatus) {

	}// getSalesList

	public int updateDeliveryStatus(AdminProductVO apVO) {

	}// updateDeliveryStatus

}
