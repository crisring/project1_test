package manage.notice;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import kr.co.sist.dao.DbConnection;

public class MangeNoticeDAO {
	private boolean isValidField(String field) {
		List<String> validFields = Arrays.asList("title", "content", "category_id", "admin_Id");
		return validFields.contains(field);
	}

	private static MangeNoticeDAO mgDAO;

	private MangeNoticeDAO() {
	}

	public static MangeNoticeDAO getInstance() {
		if (mgDAO == null) {
			mgDAO = new MangeNoticeDAO();
		}
		return mgDAO;
	}

	public int insertNotice(NoticeVO nVO) throws SQLException {
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			// SEQUENCE 사용하여 자동으로 NOTICE_ID 값을 생성
			String insertNotice = "INSERT INTO notice ( notice_id, admin_id, category_id, title, content,created_at) "
					+ "VALUES (notice_id_seq.NEXTVAL, ?, ?, ?, ?, ?)";

			pstmt = con.prepareStatement(insertNotice);

			// NOTICE_ID는 SEQUENCE에서 자동으로 생성되므로 setInt(1, nVO.getNotice_id())는 필요 없습니다.
			pstmt.setString(1, nVO.getAdmin_Id());
			pstmt.setInt(2, nVO.getCategory_id());
			pstmt.setString(3, nVO.getTitle());
			pstmt.setString(4, nVO.getContent());

			if (nVO.getCreated_at() != null) {
				pstmt.setTimestamp(5, nVO.getCreated_at());
			} else {
				pstmt.setTimestamp(5, new Timestamp(System.currentTimeMillis())); // 현재 시간 설정
			}

			return pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
	}

	public NoticeVO selectOneNotice(int noticeId) throws SQLException {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();
		NoticeVO nVO = new NoticeVO();

		try {
			con = dbCon.getConn();
			String query = "SELECT notice_id, category_id, title, content, created_at FROM notice WHERE notice_id = ?";
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, noticeId);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				nVO.setNotice_id(rs.getInt("notice_id"));
				nVO.setCategory_id(rs.getInt("category_id"));
				nVO.setTitle(rs.getString("title"));
				nVO.setContent(rs.getString("content"));
				nVO.setCreated_at(rs.getTimestamp("created_at"));
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return nVO;
	}

	public List<NoticeVO> selectAllNotice(int startRow, int pageSize) throws SQLException {
		List<NoticeVO> list = new ArrayList<>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();

			// 페이지네이션 적용한 SQL 쿼리 (한 페이지에 7개씩)
			StringBuilder selectAllNotice = new StringBuilder();
			selectAllNotice.append("SELECT * FROM ( ")
					.append("  SELECT notice_id, category_id, title, admin_id, created_at, ROWNUM AS rnum ")
					.append("  FROM notice ").append("  ORDER BY notice_id ASC ")
					.append(") WHERE rnum BETWEEN ? AND ?");

			pstmt = con.prepareStatement(selectAllNotice.toString());
			pstmt.setInt(1, startRow + 1); // startRow는 0-based index, 그래서 1을 더합니다.
			pstmt.setInt(2, startRow + pageSize); // 한 페이지에 보여줄 개수 (7개)

			rs = pstmt.executeQuery();

			while (rs.next()) {
				NoticeVO nVO = new NoticeVO();
				nVO.setNotice_id(rs.getInt("notice_id"));
				nVO.setCategory_id(rs.getInt("category_id"));
				nVO.setTitle(rs.getString("title"));
				nVO.setAdmin_Id(rs.getString("admin_id"));
				nVO.setCreated_at(rs.getTimestamp("created_at"));
				list.add(nVO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return list;
	}

	public int updateOneNotice(NoticeVO nVO) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			String updateNotice = "UPDATE notice SET category_id = ?, title = ?, content = ? WHERE notice_id = ?";
			pstmt = con.prepareStatement(updateNotice);
			pstmt.setInt(1, nVO.getCategory_id());
			pstmt.setString(2, nVO.getTitle());
			pstmt.setString(3, nVO.getContent());
			pstmt.setInt(4, nVO.getNotice_id());
			result = pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
		return result;
	}

	public int deleteNotice(int noticeId) throws SQLException {
		int result = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			String deleteNotice = "DELETE FROM notice WHERE notice_Id = ?";
			pstmt = con.prepareStatement(deleteNotice);
			pstmt.setInt(1, noticeId);
			result = pstmt.executeUpdate();
		} finally {
			dbCon.dbClose(null, pstmt, con);
		}
		return result;
	}

	public int selectTotalCount(SearchVO sVO) throws SQLException {
		int totalCount = 0;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			StringBuilder selectCount = new StringBuilder();
			selectCount.append("SELECT count(notice_id) cnt ").append("FROM notice");

			if (sVO.getKeyword() != null && !sVO.getKeyword().isEmpty()) {
				String field = BoardUtil.numToField(sVO.getField());
				if (isValidField(field)) {
					selectCount.append(" WHERE ").append(field).append(" LIKE ?");
				} else {
					throw new SQLException("Invalid field: " + field);
				}
			}

			pstmt = con.prepareStatement(selectCount.toString());
			if (sVO.getKeyword() != null && !sVO.getKeyword().isEmpty()) {
				pstmt.setString(1, "%" + sVO.getKeyword() + "%");
			}

			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalCount = rs.getInt("cnt");
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return totalCount;
	}

	public List<NoticeVO> selectNotice(SearchVO sVO) throws SQLException {
		List<NoticeVO> list = new ArrayList<>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		DbConnection dbCon = DbConnection.getInstance();

		try {
			con = dbCon.getConn();
			StringBuilder selectNotice = new StringBuilder();
			selectNotice.append("SELECT notice_id, category_id, title, admin_id, created_at ").append("FROM ( ")
					.append("    SELECT notice_id, category_id, title, admin_id, created_at, ")
					.append("           ROW_NUMBER() OVER (ORDER BY created_at DESC) AS rnum ")
					.append("    FROM notice ");

			if (sVO.getKeyword() != null && !sVO.getKeyword().isEmpty()) {
				String field = BoardUtil.numToField(sVO.getField());
				if (isValidField(field)) {
					selectNotice.append(" WHERE ").append(field).append(" LIKE ?");
				} else {
					throw new SQLException("Invalid field: " + field);
				}
			}

			selectNotice.append(") WHERE rnum BETWEEN ? AND ?");
			pstmt = con.prepareStatement(selectNotice.toString());

			int bindInd = 0;
			if (sVO.getKeyword() != null && !sVO.getKeyword().isEmpty()) {
				pstmt.setString(++bindInd, "%" + sVO.getKeyword() + "%");
			}
			pstmt.setInt(++bindInd, sVO.getStartNum());
			pstmt.setInt(++bindInd, sVO.getEndNum());

			rs = pstmt.executeQuery();
			while (rs.next()) {
				NoticeVO nVO = new NoticeVO();
				nVO.setNotice_id(rs.getInt("notice_id"));
				nVO.setCategory_id(rs.getInt("category_id"));
				nVO.setTitle(rs.getString("title"));
				nVO.setAdmin_Id(rs.getString("admin_id"));
				nVO.setCreated_at(rs.getTimestamp("created_at"));
				list.add(nVO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return list;
	}

}
