package manage.review;

public class ReviewUtil {

    /**
     * 페이지네이션을 사용하면 매개변수로 입력객체되는 객체의 
     *   currentPage번호, totalPage 수, totalCount 수
     *  검색을 수행하면 filter 값, url이 반드시 입력되어야 합니다.
     * @param sVO
     * @return
     */
	private static String[] columnName={"0","product_name", "user_id","content"};

	public static String numToField( String fieldNum) {
		return columnName[Integer.parseInt(fieldNum)];
	}//numToField
	
	
	
	
	public String pagination(ReviewSearchVO sVO) {
	    StringBuilder pagination = new StringBuilder();

	    if (sVO.getTotalCount() != 0) {
	        // 1. 한 화면에 보여줄 페이지 인덱스 수
	        int pageNumber = 3;
	        // 2. 화면에 보여줄 시작페이지 번호
	        int startPage = ((sVO.getCurrentPage() - 1) / pageNumber) * pageNumber + 1;
	        // 3. 화면에 보여줄 마지막페이지 번호
	        int endPage = startPage + pageNumber - 1;
	        // 4. 총 페이지 수가 마지막 페이지 수보다 작으면 총 페이지 수로 설정
	        if (sVO.getTotalPage() <= endPage) {
	            endPage = sVO.getTotalPage();
	        }

	        // 이전 페이지 링크 생성
	        int movePage = 0;
	        StringBuilder prevMark = new StringBuilder();
	        prevMark.append("[ &lt;&lt; ]");

	        if (sVO.getCurrentPage() > pageNumber) {
	            prevMark.delete(0, prevMark.length());
	            movePage = startPage - 1;
	            prevMark.append("[ <a href=\"")
	                    .append(sVO.getUrl())
	                    .append("?currentPage=")
	                    .append(movePage);

	            // 검색 키워드가 존재할 때
	            if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
	                prevMark.append("&field=").append(sVO.getField())
	                        .append("&keyword=").append(sVO.getKeyword());
	            }
	            // 날짜 필터가 존재할 때
	            if (sVO.getStartDate() != null && !"".equals(sVO.getStartDate())) {
	                prevMark.append("&startDate=").append(sVO.getStartDate());
	            }
	            if (sVO.getEndDate() != null && !"".equals(sVO.getEndDate())) {
	                prevMark.append("&endDate=").append(sVO.getEndDate());
	            }
	            // all이 아닐때만.
	            if ( !"all".equals(sVO.getFilter())) {
	                prevMark.append("&filter=").append(sVO.getFilter());
	            }

	            prevMark.append("\">&lt;&lt;</a> ]");
	        }
	        prevMark.append(" ... ");
	        pagination.append(prevMark);

	        // 페이지 링크 생성
	        movePage = startPage;
	        StringBuilder pageLink = new StringBuilder();

	        while (movePage <= endPage) {
	            if (movePage == sVO.getCurrentPage()) {
	                pageLink.append("[ ").append(movePage).append(" ]");
	            } else {
	                pageLink.append("[ <a href='")
	                        .append(sVO.getUrl())
	                        .append("?currentPage=")
	                        .append(movePage);

	                // 검색 키워드가 존재할 때
	                if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
	                    pageLink.append("&field=").append(sVO.getField())
	                            .append("&keyword=").append(sVO.getKeyword());
	                }
	                // 날짜 필터가 존재할 때
	                if (sVO.getStartDate() != null && !"".equals(sVO.getStartDate())) {
	                    pageLink.append("&startDate=").append(sVO.getStartDate());
	                }
	                if (sVO.getEndDate() != null && !"".equals(sVO.getEndDate())) {
	                    pageLink.append("&endDate=").append(sVO.getEndDate());
	                }
	                // 유형 필터가 존재할 때
	                if (!"all".equals(sVO.getFilter())) {
	                    pageLink.append("&filter=").append(sVO.getFilter());
	                }

	                pageLink.append("'>").append(movePage).append("</a> ]");
	            }
	            movePage++;
	        }

	        pagination.append(pageLink);
	        pagination.append(" ... ");

	        // 다음 페이지 링크 생성
	        StringBuilder nextMark = new StringBuilder();
	        nextMark.append("[ &gt;&gt; ]");

	        if (sVO.getTotalPage() > endPage) {
	            nextMark.delete(0, nextMark.length());
	            movePage = endPage + 1;

	            nextMark.append("[ <a href='")
	                    .append(sVO.getUrl())
	                    .append("?currentPage=")
	                    .append(movePage);

	            // 검색 키워드가 존재할 때
	            if (sVO.getKeyword() != null && !"".equals(sVO.getKeyword())) {
	                nextMark.append("&field=").append(sVO.getField())
	                        .append("&keyword=").append(sVO.getKeyword());
	            }
	            // 날짜 필터가 존재할 때
	            if (sVO.getStartDate() != null && !"".equals(sVO.getStartDate())) {
	                nextMark.append("&startDate=").append(sVO.getStartDate());
	            }
	            if (sVO.getEndDate() != null && !"".equals(sVO.getEndDate())) {
	                nextMark.append("&endDate=").append(sVO.getEndDate());
	            }
	            // 유형 필터가 존재할 때
	            if (!"all".equals(sVO.getFilter())) {
	                nextMark.append("&filter=").append(sVO.getFilter());
	            }

	            nextMark.append("'> &gt;&gt;</a> ]");
	        }

	        pagination.append(nextMark);
	    }

	    return pagination.toString();
	}

}
