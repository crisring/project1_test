package manage.productlist;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;

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
	public int selectTotalCount(manage.util.AdminSearchVO sVO) throws SQLException {
		int totalCount = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			StringBuilder selectCount = new StringBuilder();
			selectCount.append(" select count(PRODUCT_ID) cnt from PRODUCTS WHERE 1=1 ");

			// 바인드 변수를 위한 리스트
			List<String> parameters = new ArrayList<>();

			// 상품명 검색
			if (sVO.getProductName() != null && !sVO.getProductName().trim().isEmpty()) {
				selectCount.append(" AND NAME LIKE ? ");
				parameters.add("%" + sVO.getProductName() + "%");
			}

			// 브랜드명 검색
			if (sVO.getBrand() != null && !sVO.getBrand().trim().isEmpty()) {
				selectCount.append(" AND BRAND LIKE ? ");
				parameters.add("%" + sVO.getBrand() + "%");
			}

			// 판매상태 검색
			if (sVO.getSaleStatus() != null && !sVO.getSaleStatus().trim().isEmpty()) {
				selectCount.append(" AND SALES_STATUS = ? ");
				parameters.add(sVO.getSaleStatus());
			}

			// 조회기간 검색
			if (sVO.getStartDate() != null && sVO.getEndDate() != null) {
				selectCount.append(" AND ").append(sVO.getDateType()).append(" BETWEEN ? AND ?");
				parameters.add(sVO.getStartDate());
				parameters.add(sVO.getEndDate());
			}

			pstmt = con.prepareStatement(selectCount.toString());

			// 바인드 변수 설정
			int bindIndex = 1;
			for (String param : parameters) {
				pstmt.setString(bindIndex++, param);
			}

			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalCount = rs.getInt("cnt");
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return totalCount;
	}// selectTotalCount

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
			StringBuilder selectCount = new StringBuilder();
			selectCount.append(" select count(PRODUCT_ID) cnt from PRODUCTS WHERE 1=1 ");

			pstmt = con.prepareStatement(selectCount.toString());

			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalCount = rs.getInt("cnt");
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return totalCount;
	}// statusTotalCount

	/**
	 * 판매상태 개수 구하기
	 * 
	 * @param sVO
	 * @return 게시물의 수
	 * @throws SQLException
	 */
	public int selectSalesStatusCount(String salesStatus) throws SQLException {
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
	}// selectSalesStatusCount

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
					"	select PRODUCT_ID, NAME, MODEL_NAME, BRAND, SALES_STATUS, STOCK_QUANTITY, PRICE, DISCOUNT_PRICE, CREATED_AT, FINISH_AT, main_img, DESCRIPTION,DISCOUNT_FLAG 	 	")
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
				pVO.setDescription(rs.getString("DESCRIPTION"));
				pVO.setMainImg((rs.getString("main_img")));
				pVO.setDiscountFlag(rs.getString("DISCOUNT_FLAG"));
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return pVO;
	}// selectByProductId

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
					"		select PRODUCT_ID, NAME, MODEL_NAME, BRAND, SALES_STATUS, STOCK_QUANTITY, PRICE, DISCOUNT_PRICE, CREATED_AT, FINISH_AT			")
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

	/**
	 * 상품 선택 삭제
	 * 
	 * @param productId
	 * @return
	 * @throws SQLException
	 */
	public int deleteProduct(int[] productIds) throws SQLException {

		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder deleteProduct = new StringBuilder();
			deleteProduct.append("	delete from PRODUCTS	").append("		where PRODUCT_ID =?		");

			pstmt = con.prepareStatement(deleteProduct.toString());

			// productIds 배열의 각 항목에 대해 반복하여 업데이트
			for (int productId : productIds) {
				// 바인드 변수에 값 설정
				pstmt.setInt(1, productId);

				// 쿼리문 수행 후 결과 얻기
				rowCnt += pstmt.executeUpdate();
			}

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;

	}// deleteProduct

	/**
	 * 리스트 검색
	 * 
	 * @param sVO
	 * @return
	 * @throws SQLException
	 */
	public List<ProductVO> selectBoard(manage.util.AdminSearchVO sVO) throws SQLException {
		List<ProductVO> list = new ArrayList<>();

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			StringBuilder selectBoard = new StringBuilder();
			selectBoard.append(
					" SELECT PRODUCT_ID, NAME, MODEL_NAME, BRAND, SALES_STATUS, STOCK_QUANTITY, PRICE, DISCOUNT_PRICE, CREATED_AT, FINISH_AT ")
					.append(" FROM (SELECT PRODUCT_ID, NAME, MODEL_NAME, BRAND, SALES_STATUS, STOCK_QUANTITY, PRICE, DISCOUNT_PRICE, CREATED_AT, FINISH_AT, ")
					.append(" ROW_NUMBER() OVER(");

			// 쿼리의 ORDER BY 부분을 조건 뒤로 이동
			if ("NAME".equals(sVO.getSortBy())) {
				selectBoard.append("ORDER BY NAME ");
			} else if ("PRICE".equals(sVO.getSortBy())) {
				selectBoard.append("ORDER BY PRICE ");
			} else if ("PRICE DESC".equals(sVO.getSortBy())) {
				selectBoard.append("ORDER BY PRICE DESC ");
			} else {
				selectBoard.append("ORDER BY PRODUCT_ID ");
			}

			selectBoard.append(") AS rnum FROM products WHERE 1=1 ");

			// 동적 쿼리 조건 추가
			List<String> parameters = new ArrayList<>();

			// 상품명 검색
			if (sVO.getProductName() != null && !sVO.getProductName().trim().isEmpty()) {
				selectBoard.append(" AND NAME LIKE ? ");
				parameters.add("%" + sVO.getProductName() + "%");
			}

			// 브랜드명 검색
			if (sVO.getBrand() != null && !sVO.getBrand().trim().isEmpty()) {
				selectBoard.append(" AND BRAND LIKE ? ");
				parameters.add("%" + sVO.getBrand() + "%");
			}

			// 판매상태 검색
			if (sVO.getSaleStatus() != null && !sVO.getSaleStatus().trim().isEmpty()) {
				selectBoard.append(" AND SALES_STATUS = ? ");
				parameters.add(sVO.getSaleStatus());
			}

			// 조회기간 검색
			if (sVO.getStartDate() != null && sVO.getEndDate() != null) {
				selectBoard.append(" AND ").append(sVO.getDateType()).append(" BETWEEN ? AND ? ");
				parameters.add(sVO.getStartDate());
				parameters.add(sVO.getEndDate());
			}

			// 페이징 처리를 위한 rownum 설정
			selectBoard.append(") WHERE rnum BETWEEN ? AND ?");

			pstmt = con.prepareStatement(selectBoard.toString());

			// 바인드 변수 설정
			int bindIndex = 1;
			for (String param : parameters) {
				pstmt.setString(bindIndex++, param);
			}

			// 페이징 처리를 위한 시작번호와 끝번호 설정
			pstmt.setInt(bindIndex++, sVO.getStartNum());
			pstmt.setInt(bindIndex, sVO.getEndNum());

			// 쿼리 실행 및 결과 처리
			rs = pstmt.executeQuery();

			while (rs.next()) {
				ProductVO pVO = new ProductVO();
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
	}

	/**
	 * 상세설명 수정
	 * 
	 * @param description
	 * @param productId
	 * @return
	 * @throws SQLException
	 */
	public int updateDescription(String description, int productId) throws SQLException {
		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();
			// 쿼리문 생성 객체 얻기
			String updateDescription = "	UPDATE PRODUCTS SET DESCRIPTION=? WHERE PRODUCT_ID = ?	";
			pstmt = con.prepareStatement(updateDescription);

			// 바인드 변수에 값 설정
			pstmt.setString(1, description);
			pstmt.setInt(2, productId);

			// 쿼리문 수행 후 결과 얻기
			rowCnt = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;
	}// updateDescription

	public int updateSaleStatus(String saleStatus, int[] productIds) throws SQLException {
		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();
			// 쿼리문 생성 객체 얻기
			String updateSaleStatusQuery = "UPDATE PRODUCTS SET SALES_STATUS = ? WHERE PRODUCT_ID = ?";
			pstmt = con.prepareStatement(updateSaleStatusQuery);

			// productIds 배열의 각 항목에 대해 반복하여 업데이트
			for (int productId : productIds) {
				// 바인드 변수에 값 설정
				pstmt.setString(1, saleStatus);
				pstmt.setInt(2, productId);

				// 쿼리문 수행 후 결과 얻기
				rowCnt += pstmt.executeUpdate();
			}
		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;
	}// updateSaleStatus

	/**
	 * 상품 목록 추가
	 * 
	 * @param product
	 */
	public void insertProduct(String name, int price, int discountPrice, String discountFlag, String description,
			String mainImg, String brand, String modelName, int stockQuantity) throws SQLException {

		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder insertBoard = new StringBuilder();
			insertBoard.append(
					"INSERT INTO PRODUCTS(NAME, PRICE, DISCOUNT_PRICE, DISCOUNT_FLAG, DESCRIPTION, MAIN_IMG, BRAND, MODEL_NAME, STOCK_QUANTITY) ")
					.append("VALUES(?, ?, ?, ?, ?, ?, ?, ?,?)");

			pstmt = con.prepareStatement(insertBoard.toString());
			// 바인드 변수에 값 설정
			pstmt.setString(1, name);
			pstmt.setInt(2, price);
			pstmt.setInt(3, discountPrice);
			pstmt.setString(4, discountFlag);
			pstmt.setString(5, description);
			pstmt.setString(6, mainImg);
			pstmt.setString(7, brand);
			pstmt.setString(8, modelName);
			pstmt.setInt(9, stockQuantity);

			// 쿼리문 수행 후 결과 얻기
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

	} // insertProduct

	/**
	 * insert시 데이터 중복 검사
	 * 
	 * @param productName
	 * @param brand
	 * @param model
	 * @return
	 */
	public boolean checkProductExists(String productName, String brand, String modelName) {
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		String query = "SELECT COUNT(*) FROM products WHERE (name = ? AND brand = ? AND model_name = ?) "
				+ "OR (brand = ? AND model_name = ?)";

		try {
			con = dbCon.getConn();
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, productName);
			pstmt.setString(2, brand);
			pstmt.setString(3, modelName);
			pstmt.setString(4, brand);
			pstmt.setString(5, modelName);

			ResultSet rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) > 0; // 중복 존재
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			// 리소스 정리
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			if (con != null)
				try {
					con.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		return false;
	}// checkProductExists

	/**
	 * 표준 신발 사이즈 조회
	 * 
	 * @return list
	 * @throws SQLException
	 */
	public List<ProductVO> selectStandardSize() throws SQLException {
		List<ProductVO> list = new ArrayList<>(); // 리스트 초기화

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();

			// 쿼리문 생성
			String selectStandardSize = "select SIZES from STANDARD_SIZE";

			pstmt = con.prepareStatement(selectStandardSize);
			rs = pstmt.executeQuery(); // 쿼리 실행 및 ResultSet 생성
			ProductVO pVO = null;

			// 결과 처리
			List<Integer> sizesList = new ArrayList<>();
			while (rs.next()) {
				sizesList.add(rs.getInt("SIZES"));
			}

			if (!sizesList.isEmpty()) {
				pVO = new ProductVO();
				pVO.setStandardSize(sizesList.stream().mapToInt(i -> i).toArray()); // 배열로 설정
				list.add(pVO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}// selectStandardSize

	/**
	 * 상품에 선택한 사이즈 추가
	 * 
	 * @param product
	 */
	public void insertSize(int productId, int[] chooseSize) throws SQLException {

		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			String insertSize = "INSERT INTO SIZES(PRODUCT_ID, CHOOSE_SIZE_ID) VALUES(?, ?)";

			pstmt = con.prepareStatement(insertSize);

			// productId는 한 번만 설정하고, chooseSize 배열을 반복하여 여러 사이즈를 삽입
			pstmt.setInt(1, productId);

			for (int Size : chooseSize) {
				pstmt.setInt(2, Size);
				pstmt.executeUpdate();
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

	} // insertSize

	/**
	 * 상품 번호 찾기 method
	 * 
	 * @return productId
	 * @throws SQLException
	 */
	public int selectProductId(String productName, String brand, String modelName) throws SQLException {

		int productId = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();

			// 쿼리문 생성 (name, brand, model_name을 조건으로 검색)
			String selectProductId = "SELECT PRODUCT_ID FROM products WHERE name = ? AND brand = ? AND model_name = ?";

			pstmt = con.prepareStatement(selectProductId);

			// 바인드 변수에 값 설정
			pstmt.setString(1, productName);
			pstmt.setString(2, brand);
			pstmt.setString(3, modelName);

			rs = pstmt.executeQuery();

			// 결과 처리
			if (rs.next()) {
				productId = rs.getInt("PRODUCT_ID");
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return productId;
	} // selectProductId

	/**
	 * 상품에 선택한 서브 이미지 추가
	 * 
	 * @param product
	 */
	public void insertSubImg(int productId, String[] subImgName) throws SQLException {

		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			String insertSubImg = "	insert into SUB_IMG(PRODUCT_ID, SUB_IMG_NAME) values(?,?)	";

			pstmt = con.prepareStatement(insertSubImg);

			// productId는 한 번만 설정
			pstmt.setInt(1, productId);

			for (String subImgArr : subImgName) {
				pstmt.setString(2, subImgArr);
				pstmt.executeUpdate();
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

	} // insertSubImg

	/**
	 * 서브 이미지 다시 추가를 위한 데이터 삭제
	 * 
	 * @return 삭제된 행 수
	 * @throws SQLException
	 */
	public int deleteSubimg(int productId) throws SQLException {

		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();

			String updateSubimg = "DELETE FROM SUB_IMG WHERE PRODUCT_ID=?";

			pstmt = con.prepareStatement(updateSubimg);
			pstmt.setInt(1, productId);

			// 쿼리 실행
			rowCnt = pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}

		return rowCnt;
	} // deleteSubimg

	/**
	 * 상품 목록 업데이트
	 * 
	 * @param product
	 */
	public void updateProduct(String name, int price, int discountPrice, String discountFlag, String description,
			String mainImg, String brand, String modelName, int stockQuantity, int productId) throws SQLException {

		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();
			// 쿼리문 생성객체 얻기
			StringBuilder updateQuery = new StringBuilder();
			updateQuery.append(
					"UPDATE PRODUCTS SET NAME = ?, PRICE = ?, DISCOUNT_PRICE = ?, DISCOUNT_FLAG = ?, DESCRIPTION = ?, MAIN_IMG = ?, BRAND = ?, MODEL_NAME = ?, STOCK_QUANTITY = ? ")
					.append("WHERE PRODUCT_ID = ?");

			pstmt = con.prepareStatement(updateQuery.toString());
			// 바인드 변수에 값 설정
			pstmt.setString(1, name);
			pstmt.setInt(2, price);
			pstmt.setInt(3, discountPrice);
			pstmt.setString(4, discountFlag);
			pstmt.setString(5, description);
			pstmt.setString(6, mainImg);
			pstmt.setString(7, brand);
			pstmt.setString(8, modelName);
			pstmt.setInt(9, stockQuantity);
			pstmt.setInt(10, productId);

			// 쿼리문 수행 후 결과 얻기
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally
	} // updateProduct

	/**
	 * // 상품에 선택된 사이즈들을 DB에서 가져온다.
	 * 
	 * @param productId
	 * @return
	 */
	public List<Integer> selectSelectedSizes(int productId) throws SQLException {

		List<Integer> selectedSizes = new ArrayList<>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			String query = "SELECT CHOOSE_SIZE_ID FROM SIZES WHERE PRODUCT_ID = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, productId);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				selectedSizes.add(rs.getInt("CHOOSE_SIZE_ID"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return selectedSizes;
	}// selectSelectedSizes

	/**
	 * 상품 사이즈 삭제 후 다시 추가
	 * 
	 * @param productId
	 * @return
	 * @throws SQLException
	 */
	public int deleteSizes(int productId) throws SQLException {

		int rowCnt = 0;
		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection 얻기
			con = dbCon.getConn();
			// 쿼리문 생성
			String deleteSizes = "DELETE FROM SIZES WHERE PRODUCT_ID = ?";

			pstmt = con.prepareStatement(deleteSizes);
			// 바인드 변수에 값 설정
			pstmt.setInt(1, productId);

			// 쿼리문 수행 후 결과 얻기
			rowCnt = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}

		return rowCnt;
	}// deleteSizes
}// class
