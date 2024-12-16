package user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;
import manage.productlist.ProductVO;
import manage.review.ReviewVO;
import user.vo.SizeVO;

public class UserProductDAO {

	// 상품 전체 목록 조회 (검색조건, 정렬조건 포함)
	public List<ProductVO> selectAll(ProductVO pVO, String sortMethod) throws SQLException {
		List<ProductVO> list = new ArrayList<>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectQuery = new StringBuilder();
			selectQuery.append(" SELECT P.PRODUCT_ID, P.NAME, P.PRICE, P.BRAND, ")
					.append(" P.DESCRIPTION, P.STOCK_QUANTITY, P.MAIN_IMG, P.CREATED_AT, ")
					.append(" P.MODEL_NAME, P.SALES_STATUS ").append(" FROM PRODUCTS P ").append(" WHERE 1=1 ");

			List<Object> parameters = new ArrayList<>();

			// 검색 조건 추가
			if (pVO != null) {
				if (pVO.getBrand() != null && !pVO.getBrand().isEmpty()) {
					selectQuery.append(" AND P.BRAND = ? ");
					parameters.add(pVO.getBrand());
				}
				if (pVO.getProductName() != null && !pVO.getProductName().isEmpty()) {
					selectQuery.append(" AND P.NAME LIKE ? ");
					parameters.add("%" + pVO.getProductName() + "%");
				}
				if (pVO.getPrice() > 0) {
					selectQuery.append(" AND P.PRICE <= ? ");
					parameters.add(pVO.getPrice());
				}
				if (pVO.getModelName() != null && !pVO.getModelName().isEmpty()) {
					selectQuery.append(" AND P.MODEL_NAME LIKE ? ");
					parameters.add("%" + pVO.getModelName() + "%");
				}
				if (pVO.getSaleStatus() != null && !pVO.getSaleStatus().isEmpty()) {
					selectQuery.append(" AND P.SALES_STATUS = ? ");
					parameters.add(pVO.getSaleStatus());
				}
			}

			// 정렬 조건
			switch (sortMethod != null ? sortMethod : "latest") {
			case "popular":
				selectQuery.append(" ORDER BY P.STOCK_QUANTITY DESC");
				break;
			case "lowPrice":
				selectQuery.append(" ORDER BY P.PRICE ASC");
				break;
			case "highPrice":
				selectQuery.append(" ORDER BY P.PRICE DESC");
				break;
			default:
				selectQuery.append(" ORDER BY P.CREATED_AT DESC");
			}

			pstmt = con.prepareStatement(selectQuery.toString());

			// 파라미터 설정
			for (int i = 0; i < parameters.size(); i++) {
				pstmt.setObject(i + 1, parameters.get(i));
			}

			rs = pstmt.executeQuery();

			while (rs.next()) {
				ProductVO tempVO = new ProductVO();
				tempVO.setProductId(rs.getInt("PRODUCT_ID"));
				tempVO.setProductName(rs.getString("NAME"));
				tempVO.setPrice(rs.getInt("PRICE"));
				tempVO.setBrand(rs.getString("BRAND"));
				tempVO.setDescription(rs.getString("DESCRIPTION"));
				tempVO.setStockQuantity(rs.getInt("STOCK_QUANTITY"));
				tempVO.setMainImg(rs.getString("MAIN_IMG"));
				tempVO.setCreateAt(rs.getDate("CREATED_AT"));
				tempVO.setModelName(rs.getString("MODEL_NAME"));
				tempVO.setSaleStatus(rs.getString("SALES_STATUS"));

				list.add(tempVO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}

	// 상품 사이즈 목록 조회
	public List<SizeVO> selectProductSizes(int productId) throws SQLException {
		List<SizeVO> sizeList = new ArrayList<>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			String selectQuery = "SELECT CHOOSE_SIZE_ID, PRODUCT_ID FROM SIZES WHERE PRODUCT_ID = ? ORDER BY CHOOSE_SIZE_ID";

			pstmt = con.prepareStatement(selectQuery);
			pstmt.setInt(1, productId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				SizeVO sizeVO = new SizeVO();
				sizeVO.setChooseSizeId(rs.getInt("CHOOSE_SIZE_ID"));
				sizeVO.setProductId(rs.getInt("PRODUCT_ID"));
				sizeList.add(sizeVO);
			}

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return sizeList;
	}

	public ProductVO selectByProductId(int productId) throws SQLException {
		ProductVO pVO = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectQuery = new StringBuilder();
			selectQuery.append(" SELECT p.PRODUCT_ID, p.NAME, p.PRICE, p.BRAND, ")
					.append(" p.DESCRIPTION, p.STOCK_QUANTITY, p.MAIN_IMG, ")
					.append(" p.CREATED_AT, p.MODEL_NAME, p.DISCOUNT_PRICE, p.DISCOUNT_FLAG, ")
					.append(" s.SUB_IMG_ID, s.SUB_IMG_NAME ") // 서브 이미지 컬럼 추가
					.append(" FROM PRODUCTS p ").append(" LEFT JOIN SUB_IMG s ON p.PRODUCT_ID = s.PRODUCT_ID ") // LEFT
																												// JOIN으로
																												// 서브
																												// 이미지
																												// 테이블
																												// 조인
					.append(" WHERE p.PRODUCT_ID = ? ");

			pstmt = con.prepareStatement(selectQuery.toString());
			pstmt.setInt(1, productId);

			rs = pstmt.executeQuery();

			List<String> subImgList = new ArrayList<>(); // 서브 이미지들을 저장할 리스트
			while (rs.next()) {
				if (pVO == null) { // 첫 번째 행에서만 상품 정보 설정
					pVO = new ProductVO();
					pVO.setProductId(rs.getInt("PRODUCT_ID"));
					pVO.setProductName(rs.getString("NAME"));
					pVO.setPrice(rs.getInt("PRICE"));
					pVO.setBrand(rs.getString("BRAND"));
					pVO.setDescription(rs.getString("DESCRIPTION"));
					pVO.setStockQuantity(rs.getInt("STOCK_QUANTITY"));
					pVO.setMainImg(rs.getString("MAIN_IMG"));
					pVO.setCreateAt(rs.getDate("CREATED_AT"));
					pVO.setModelName(rs.getString("MODEL_NAME"));
					pVO.setDiscount_price(rs.getInt("DISCOUNT_PRICE"));
					pVO.setDiscountFlag(rs.getString("DISCOUNT_FLAG"));
				}
				// 서브 이미지가 있으면 리스트에 추가
				String subImgName = rs.getString("SUB_IMG_NAME");
				if (subImgName != null) {
					subImgList.add(subImgName);
				}
			}
			if (pVO != null) {
				pVO.setSubImgList(subImgList);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return pVO;
	}

	// 상품의 리뷰 목록 조회
	public List<ReviewVO> selectAllProductReview(int productId) throws SQLException { // 반환 타입 변경
		List<ReviewVO> list = new ArrayList<>(); // ReviewVO 리스트로 변경
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			StringBuilder selectQuery = new StringBuilder();
			selectQuery.append(" SELECT r.REVIEW_ID, r.USER_ID, r.PRODUCT_ID, ")
					.append(" r.CONTENT, r.RATING, r.CREATED_AT, ")
					.append(" p.NAME as PRODUCT_NAME, p.MAIN_IMG, r.review_img ").append(" FROM REVIEW r ")
					.append(" JOIN PRODUCTS p ON r.PRODUCT_ID = p.PRODUCT_ID ").append(" WHERE r.PRODUCT_ID = ? ")
					.append(" ORDER BY r.CREATED_AT DESC ");

			pstmt = con.prepareStatement(selectQuery.toString());
			pstmt.setInt(1, productId);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				ReviewVO reviewVO = new ReviewVO(); // ReviewVO 객체 생성
				reviewVO.setReviewId(rs.getInt("REVIEW_ID"));
				reviewVO.setUserId(rs.getString("USER_ID"));
				reviewVO.setProductId(rs.getInt("PRODUCT_ID"));
				reviewVO.setContent(rs.getString("CONTENT"));
				reviewVO.setRating(rs.getInt("RATING"));
				reviewVO.setCreateAt(rs.getDate("CREATED_AT"));
				reviewVO.setReviewImg(rs.getString("REVIEW_img"));

				list.add(reviewVO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return list;
	}

}