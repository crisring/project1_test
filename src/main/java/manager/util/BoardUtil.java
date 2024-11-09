package manager.util;

public class BoardUtil {

	/**
	 * 페이지네이션을 사용하면 매개변수로 입력되는 객체의 현재 페이지번호, 전체 페이지수, 검색 수 <br>
	 * 검색을 수행하면 field, url이 반드시 입력되어야합니다.
	 * 
	 * @param sVO
	 * @return
	 */

	public String pagination(SearchVO sVO) {
		StringBuilder pagination = new StringBuilder();

		// 검색 수가 0이 아닐 때만 페이지네이션을 보여줌
		if (sVO.getTotalCount() != 0) {
			int pageNumber = 3;
			int startPage = ((sVO.getCurrentPage() - 1) / pageNumber) * pageNumber + 1;
			int endPage = startPage + pageNumber - 1;
			if (sVO.getTotalPage() <= endPage) {
				endPage = sVO.getTotalPage();
			}

			// 이전 페이지 링크
			StringBuilder prevMark = new StringBuilder();
			if (sVO.getCurrentPage() > pageNumber) {
				int movePage = startPage - 1;
				prevMark.append("[ <a href=\"").append(sVO.getUrl()).append("?currentPage=").append(movePage);
				appendParameters(prevMark, sVO);
				prevMark.append("\">&lt;&lt;</a> ]");
			} else {
				prevMark.append("[ &lt;&lt; ]");
			}
			pagination.append(prevMark).append(" ... ");

			// 페이지 번호 링크
			for (int i = startPage; i <= endPage; i++) {
				if (i == sVO.getCurrentPage()) {
					pagination.append("[ ").append(i).append(" ]");
				} else {
					pagination.append("[ <a href=\"").append(sVO.getUrl()).append("?currentPage=").append(i);
					appendParameters(pagination, sVO);
					pagination.append("\">").append(i).append("</a> ]");
				}
			}

			pagination.append(" ... ");

			// 다음 페이지 링크
			StringBuilder nextMark = new StringBuilder();
			if (sVO.getTotalPage() > endPage) {
				int movePage = endPage + 1;
				nextMark.append("[ <a href=\"").append(sVO.getUrl()).append("?currentPage=").append(movePage);
				appendParameters(nextMark, sVO);
				nextMark.append("\"> &gt;&gt;</a> ]");
			} else {
				nextMark.append("[ &gt;&gt; ]");
			}

			pagination.append(nextMark);
		}

		return pagination.toString();
	}

	// 공통 검색 조건 추가 함수
	private void appendParameters(StringBuilder sb, SearchVO sVO) {
		if (sVO.getProductName() != null && !sVO.getProductName().isEmpty()) {
			sb.append("&productName=").append(sVO.getProductName());
		}
		if (sVO.getBrand() != null && !sVO.getBrand().isEmpty()) {
			sb.append("&brand=").append(sVO.getBrand());
		}
		if (sVO.getSaleStatus() != null && !sVO.getSaleStatus().isEmpty()) {
			sb.append("&saleStatus=").append(sVO.getSaleStatus());
		}
		if (sVO.getStartDate() != null && !sVO.getStartDate().isEmpty()) {
			sb.append("&startDate=").append(sVO.getStartDate());
		}
		if (sVO.getEndDate() != null && !sVO.getEndDate().isEmpty()) {
			sb.append("&endDate=").append(sVO.getEndDate());
		}
		if (sVO.getSortBy() != null && !sVO.getSortBy().isEmpty()) {
			sb.append("&sortBy=").append(sVO.getSortBy());
		}
	}

}// class
