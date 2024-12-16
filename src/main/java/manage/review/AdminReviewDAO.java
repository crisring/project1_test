package manage.review;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;

public class AdminReviewDAO {
	private static AdminReviewDAO adDAO;

	private AdminReviewDAO() {

	}// constructor

	public static AdminReviewDAO getInstance() {
		if (adDAO == null) {
			adDAO = new AdminReviewDAO();
		}
		return adDAO;
	}// getInstance

	public int selectTotalCount(ReviewSearchVO sVO) throws SQLException {
		int totalCount = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			StringBuilder selectCount = new StringBuilder();
			selectCount.append("SELECT COUNT(r.review_id) AS cnt ").append("FROM review r ")
					.append("JOIN products p ON r.product_id = p.product_id ");

			boolean hasWhere = false;
			int paramIndex = 1; // 바인드 변수 인덱스 관리

			// 날짜 필터가 있을 때
			if (sVO.getStartDate() != null && sVO.getEndDate() != null && !sVO.getStartDate().isEmpty()
					&& !sVO.getEndDate().isEmpty()) {
				selectCount.append(" WHERE r.created_at BETWEEN ? AND ? ");
				hasWhere = true;
			}

			// 유형 필터가 있을 때 ('all'이 아닐 경우에만 조건 추가)
			if (sVO.getFilter() != null && !"".equals(sVO.getFilter()) && !"all".equalsIgnoreCase(sVO.getFilter())) {
				if (!hasWhere) {
					selectCount.append(" WHERE ");
					hasWhere = true;
				} else {
					selectCount.append(" AND ");
				}
				selectCount.append("p.name = ? "); // 예: 특정 상품명으로 필터링
			}

			// 검색 키워드가 있을 때
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				if (!hasWhere) {
					selectCount.append(" WHERE ");
					hasWhere = true;
				} else {
					selectCount.append(" AND ");
				}
				String searchCondition = "";
				switch (sVO.getField()) {
				case "1": // 상품명
					searchCondition = "p.name LIKE ?";
					break;
				case "2": // 작성자
					searchCondition = "r.user_id LIKE ?";
					break;
				case "3": // 내용
					searchCondition = "r.content LIKE ?";
					break;
				default: // 전체 검색
					searchCondition = "(p.name LIKE ? OR r.user_id LIKE ? OR r.content LIKE ?)";
					break;
				}
				selectCount.append(searchCondition);
			}

			pstmt = con.prepareStatement(selectCount.toString());

			// 바인드 변수에 값 설정
			if (sVO.getStartDate() != null && sVO.getEndDate() != null && !sVO.getStartDate().isEmpty()
					&& !sVO.getEndDate().isEmpty()) {
				// 시작 날짜는 하루의 시작 시간으로 설정
				pstmt.setTimestamp(paramIndex++, java.sql.Timestamp.valueOf(sVO.getStartDate() + " 00:00:00"));
				// 종료 날짜는 하루의 끝 시간으로 설정
				pstmt.setTimestamp(paramIndex++, java.sql.Timestamp.valueOf(sVO.getEndDate() + " 23:59:59"));
			}

			if (sVO.getFilter() != null && !"".equals(sVO.getFilter()) && !"all".equalsIgnoreCase(sVO.getFilter())) {
				pstmt.setString(paramIndex++, sVO.getFilter());
			}

			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				switch (sVO.getField()) {
				case "1": // 상품명
				case "2": // 작성자
				case "3": // 내용
					pstmt.setString(paramIndex++, "%" + sVO.getKeyword() + "%");
					break;
				default: // 전체 검색
					pstmt.setString(paramIndex++, "%" + sVO.getKeyword() + "%");
					pstmt.setString(paramIndex++, "%" + sVO.getKeyword() + "%");
					pstmt.setString(paramIndex++, "%" + sVO.getKeyword() + "%");
					break;
				}
			} // end if

			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalCount = rs.getInt("cnt");
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return totalCount;
	}

	public List<ReviewVO> selectAllReview(ReviewSearchVO sVO) throws SQLException {
		List<ReviewVO> reviewList = new ArrayList<>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			// 페이징 처리를 포함한 SQL 쿼리
			StringBuilder selectQuery = new StringBuilder();
			selectQuery.append("SELECT * FROM ( ").append("    SELECT ROWNUM AS RNUM, A.* FROM ( ")
					.append("        SELECT r.review_id, r.user_id, r.product_id, p.name AS product_name, ")
					.append("        r.content, r.created_at, r.rating ").append("        FROM review r ")
					.append("        JOIN products p ON r.product_id = p.product_id ");

			// 검색 조건 추가
			List<String> conditions = new ArrayList<>();
			List<Object> parameters = new ArrayList<>();

			// 날짜 필터
			if (sVO.getStartDate() != null && sVO.getEndDate() != null && !sVO.getStartDate().isEmpty()
					&& !sVO.getEndDate().isEmpty()) {
				conditions.add("r.created_at BETWEEN ? AND ?");
				// 시작 날짜는 하루의 시작 시간으로 설정
				parameters.add(java.sql.Timestamp.valueOf(sVO.getStartDate() + " 00:00:00"));
				// 종료 날짜는 하루의 끝 시간으로 설정
				parameters.add(java.sql.Timestamp.valueOf(sVO.getEndDate() + " 23:59:59"));
			}

			// 검색 조건
			if (sVO.getKeyword() != null && !sVO.getKeyword().isEmpty()) {
				switch (sVO.getField()) {
				case "1": // 상품명
					conditions.add("p.name LIKE ?");
					parameters.add("%" + sVO.getKeyword() + "%");
					break;
				case "2": // 작성자
					conditions.add("r.user_id LIKE ?");
					parameters.add("%" + sVO.getKeyword() + "%");
					break;
				case "3": // 내용
					conditions.add("r.content LIKE ?");
					parameters.add("%" + sVO.getKeyword() + "%");
					break;
				default: // 전체 검색
					conditions.add("(p.name LIKE ? OR r.user_id LIKE ? OR r.content LIKE ?)");
					parameters.add("%" + sVO.getKeyword() + "%");
					parameters.add("%" + sVO.getKeyword() + "%");
					parameters.add("%" + sVO.getKeyword() + "%");
					break;
				}
			}

			// WHERE 절 추가
			if (!conditions.isEmpty()) {
				selectQuery.append(" WHERE ").append(String.join(" AND ", conditions));
			}

			// 정렬 및 페이징 처리 완성
			selectQuery.append("        ORDER BY r.review_id DESC").append("    ) A WHERE ROWNUM <= ?")
					.append(") WHERE RNUM >= ?");

			pstmt = con.prepareStatement(selectQuery.toString());

			// 파라미터 바인딩
			int paramIndex = 1;
			for (Object param : parameters) {
				if (param instanceof java.sql.Timestamp) {
					pstmt.setTimestamp(paramIndex++, (java.sql.Timestamp) param);
				} else {
					pstmt.setString(paramIndex++, (String) param);
				}
			}

			// 페이징 처리를 위한 파라미터 바인딩
			pstmt.setInt(paramIndex++, sVO.getEndNum());
			pstmt.setInt(paramIndex, sVO.getStartNum());

			rs = pstmt.executeQuery();

			while (rs.next()) {
				ReviewVO rVO = new ReviewVO();
				rVO.setReviewId(rs.getInt("review_id"));
				rVO.setUserId(rs.getString("user_id"));
				rVO.setProductId(rs.getInt("product_id"));
				rVO.setProductName(rs.getString("product_name"));
				rVO.setCreateAt(rs.getTimestamp("created_at"));
				rVO.setRating(rs.getInt("rating"));

				try (BufferedReader br = new BufferedReader(rs.getClob("content").getCharacterStream())) {
					StringBuilder content = new StringBuilder();
					String temp;
					while ((temp = br.readLine()) != null) {
						content.append(temp).append("\n");
					}
					rVO.setContent(content.toString());
				} catch (IOException ie) {
					throw new SQLException("CLOB 데이터를 읽는 중 오류가 발생했습니다.", ie);
				}

				reviewList.add(rVO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}

		return reviewList;
	}

	public ReviewVO selectOneReview(int reviewId) throws SQLException {
		ReviewVO rVO = null;
		StringBuilder selectReview = new StringBuilder();
		selectReview.append("SELECT r.review_id, r.user_id, r.product_id, p.name, ")
				.append("r.content, r.created_at, r.rating, r.review_img ").append("FROM review r ")
				.append("JOIN products p ON r.product_id = p.product_id ").append("WHERE r.review_id = ?");

		try (Connection con = DbConnection.getInstance().getConn();
				PreparedStatement pstmt = con.prepareStatement(selectReview.toString())) {

			pstmt.setInt(1, reviewId);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					rVO = new ReviewVO();
					rVO.setReviewId(rs.getInt("review_id"));
					rVO.setUserId(rs.getString("user_id"));
					rVO.setProductId(rs.getInt("product_id"));
					rVO.setProductName(rs.getString("name")); // name으로 매핑
					rVO.setCreateAt(rs.getTimestamp("created_at"));
					rVO.setRating(rs.getInt("rating"));
					rVO.setReviewImg(rs.getString("review_img"));
					System.out.println(rVO.getCreateAt());

					// CLOB 데이터 읽기
					try {
						BufferedReader br = new BufferedReader(rs.getClob("content").getCharacterStream());
						StringBuilder content = new StringBuilder();
						String temp;
						while ((temp = br.readLine()) != null) {
							content.append(temp).append("\n");
						}
						rVO.setContent(content.toString());
					} catch (IOException ie) {
						throw new SQLException("CLOB 데이터를 읽는 중 오류가 발생했습니다.", ie);
					}
				}
			}
		}
		return rVO;
	}

	public int deleteReview(ReviewVO rVO) throws SQLException {
		int deleteCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			String deleteQuery = "DELETE FROM review WHERE review_id = ?";
			pstmt = con.prepareStatement(deleteQuery);
			pstmt.setInt(1, rVO.getReviewId());

			deleteCnt = pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
		return deleteCnt;
	}
}
