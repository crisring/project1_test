package user.dao;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kr.co.sist.dao.DbConnection;
import manage.notice.NoticeVO;
import user.vo.SearchVO;

public class UserNoticeDAO {
	private static UserNoticeDAO unDAO;

	private UserNoticeDAO() {

	}

	public static UserNoticeDAO getInstance() {
		if (unDAO == null) {
			unDAO = new UserNoticeDAO();

		} // end if
		return unDAO;
	}// getInstance

	public int selectTotalCount(SearchVO sVO) throws SQLException {
		int totalCount = 0;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();
		// 1.JNDI 사용객체 생성
		// 2.DBCP에서 DataSource 얻기

		try {
			// 3.Connection 얻기
			con = dbCon.getConn();
			// 4.쿼리문 생성 객체 얻기
			StringBuilder selectCount = new StringBuilder();
			selectCount.append("	select count(notice_id) cnt from notice ");

			// dynamic query : 검색 키워드를 판단 기준으로 where절 동적생성 되어야 한다.
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				selectCount.append("	where instr(title,?) != 0");
			} // end if

			pstmt = con.prepareStatement(selectCount.toString());
			// 5.바인드변수 값 설정
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				pstmt.setString(1, sVO.getKeyword());
			} // end if

			// 6.쿼리문 수행 후 결과얻기
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalCount = rs.getInt("cnt");
			} // end if
		} finally {
			// 7.연결끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return totalCount;
	}// selectTotalCount

	public List<NoticeVO> selectAllNotice(SearchVO sVO) throws SQLException {
		List<NoticeVO> list = new ArrayList<NoticeVO>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성 객체 얻기
			StringBuilder selectBoard = new StringBuilder();
			selectBoard.append("	select notice_id, category, title, created_at, hits	")
					.append("	from (select n.notice_id, nc.category, n.title, n.created_at, n.hits,	")
					.append("	row_number() over( order by created_at desc ) rnum 	").append("	from notice n 	")
					.append("	join notice_category nc on n.category_id = nc.category_id	");

			// dynamic query : 검색 키워드를 판단 기준으로 where절 동적생성 되어야 한다.
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				selectBoard.append("	where instr(title, ? ) != 0");
			} // end if

			selectBoard.append("	)where rnum between ? and ?	");

			pstmt = con.prepareStatement(selectBoard.toString());
			// 바인드변수 값 설정
			int bindIndex = 0;
			if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
				pstmt.setString(++bindIndex, sVO.getKeyword());
			}
			pstmt.setInt(++bindIndex, sVO.getStartNum());
			pstmt.setInt(++bindIndex, sVO.getEndNum());

			// 쿼리문 수행 후 결과얻기
			rs = pstmt.executeQuery();

			NoticeVO nVO = null;
			while (rs.next()) {
				nVO = new NoticeVO();
				nVO.setCategory(rs.getString("category"));
				nVO.setTitle(rs.getString("title"));
				nVO.setCreated_at(rs.getTimestamp("created_at"));
				nVO.setHits(rs.getInt("hits"));
				nVO.setNotice_id(rs.getInt("notice_id"));

				list.add(nVO);
			} // end while

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return list;
	}// selectAllNotice

	public NoticeVO selectOneNotice(int notice_id) throws SQLException {
		NoticeVO nVO = null;

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성 객체 얻기
			StringBuilder selectOneNotice = new StringBuilder();
			selectOneNotice.append("	select notice_id ,category, title, created_at, hits, content	")
					.append("	from (select n.notice_id, nc.category, n.title, n.created_at, n.hits,	")
					.append("	n.content, row_number() over( order by created_at desc ) rnum	")
					.append("	from notice n	")
					.append("	join notice_category nc on n.category_id = nc.category_id	")
					.append("	)where notice_id=?	");

			pstmt = con.prepareStatement(selectOneNotice.toString());
			// 바인드변수 값 설정
			pstmt.setInt(1, notice_id);

			// 쿼리문 수행 후 결과얻기
			rs = pstmt.executeQuery();

			if (rs.next()) {
				nVO = new NoticeVO();
				nVO.setNotice_id(notice_id);
				nVO.setTitle(rs.getString("title"));
				nVO.setCategory(rs.getString("category"));
				nVO.setCreated_at(rs.getTimestamp("created_at"));
				nVO.setHits(rs.getInt("hits"));

				// CLOB데이터를 읽어들이기 위해서 별도의 stream을 연결
				BufferedReader br = new BufferedReader(rs.getClob("content").getCharacterStream());

				StringBuilder content = new StringBuilder();
				String temp;// 한줄 읽어들인 데이터를 저장할 변수

				try {
					while ((temp = br.readLine()) != null) {
						content.append(temp).append("\n");
					} // end while
						// 모든 줄을 읽어들여 저장한 변수를 BoardVO객체에 할당한다
					nVO.setContent(content.toString());
				} catch (IOException ie) {
					ie.printStackTrace();
				} // end catch
			} // end if

		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return nVO;
	}// selectOneNotice

	/**
	 * 조회수 설정
	 * 
	 * @param nVO
	 * @throws SQLException
	 */
	public void updateHits(NoticeVO nVO) throws SQLException {
		Connection con = null;
		PreparedStatement pstmt = null;

		DbConnection dbCon = DbConnection.getInstance();

		try {
			// connection얻기
			con = dbCon.getConn();
			// 쿼리문 생성 객체 얻기
			StringBuilder updateHits = new StringBuilder();
			updateHits.append("	update notice set hits=hits+1 where notice_id=?	");

			pstmt = con.prepareStatement(updateHits.toString());

			pstmt.setInt(1, nVO.getNotice_id());

			// 쿼리문 수행 후 결과얻기
			pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally
	}// updateHits

	/**
	 * 페이지 네이션
	 * 
	 * @param sVO
	 * @return
	 */
	public String pagination(SearchVO sVO) {
		StringBuilder pagination = new StringBuilder();

		if (sVO.getTotalCount() != 0) {
			int pageNumber = 9;
			int startPage = ((sVO.getCurrentPage() - 1) / pageNumber) * pageNumber + 1;
			int endPage = startPage + pageNumber - 1;
			if (sVO.getTotalPage() <= endPage) {
				endPage = sVO.getTotalPage();
			}

			int movePage;

			// 5. 이전 버튼 추가
			if (startPage > 1) {
				movePage = startPage - 1;
				pagination.append("<li><a href=\"").append(sVO.getUrl()).append("?currentPage=").append(movePage);
				if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
					pagination.append("&keyword=").append(sVO.getKeyword());
				}
				pagination.append("\">&lt;</a></li>");
			}

			// 6. 페이지 번호 생성
			movePage = startPage;
			while (movePage <= endPage) {
				if (movePage == sVO.getCurrentPage()) {
					pagination.append("<li class='active'>").append(movePage).append("</li>");
				} else {
					pagination.append("<li><a href='").append(sVO.getUrl()).append("?currentPage=").append(movePage);
					if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
						pagination.append("&keyword=").append(sVO.getKeyword());
					}
					pagination.append("'>").append(movePage).append("</a></li>");
				}
				movePage++;
			}

			// 7. 다음 버튼 추가
			if (endPage < sVO.getTotalPage()) {
				movePage = endPage + 1;
				pagination.append("<li><a href='").append(sVO.getUrl()).append("?currentPage=").append(movePage);
				if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
					pagination.append("&keyword=").append(sVO.getKeyword());
				}
				pagination.append("'>&gt;</a></li>");
			}
		}

		return pagination.toString();
	}

}
