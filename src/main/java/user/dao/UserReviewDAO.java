package user.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import kr.co.sist.dao.DbConnection;
import manage.review.ReviewVO;

public class UserReviewDAO {
	private static UserReviewDAO urDAO;

	private UserReviewDAO() {

	}

	public static UserReviewDAO getInstance() {
		if (urDAO == null) {
			urDAO = new UserReviewDAO();

		} // end if

		return urDAO;
	}// getInstance

	public int insertReview(ReviewVO rVO) throws SQLException {
		int rowCnt = 0;

		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성 객체 얻기
			StringBuilder insertReview = new StringBuilder();
			insertReview.append("	insert into review(review_id, user_id, product_id, content, rating, review_img)	")
					.append("	values(review_seq.nextval, ?, ?, ?, ?, ?)	");

			pstmt = con.prepareStatement(insertReview.toString());

			// 바인드변수 값 설정
			pstmt.setString(1, rVO.getUserId());
			pstmt.setInt(2, rVO.getPrdNum());
			pstmt.setString(3, rVO.getContent());
			pstmt.setInt(4, rVO.getRating());
			pstmt.setString(5, rVO.getReviewImg());

			// 쿼리문 수행 후 결과얻기
			rowCnt = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCnt;
	}// insertReview

}
