package manage.review;

public class ReviewSearchVO {
	private String filter = "all"; // 기본값은 'all'
	private String field="0"; // 검색 필드 (예: subject, content, writer)
	private String keyword; // 검색 키워드
	private String startDate; // 시작 날짜
	private String endDate; // 종료 날짜
	private int currentPage =1 ; // 현재 페이지 번호
	private int startNum; // 페이지 시작 번호
	private int endNum; // 페이지 끝 번호
	private int totalPage; // 총 페이지 수
	private int totalCount; // 총 게시물 수
	private String url; // 페이지네이션 링크의 기본 URL

	public String getFilter() {
		return filter;
	}

	public void setFilter(String filter) {
		this.filter = filter;
	}

	public String getField() {
		return field;
	}

	public void setField(String field) {
		this.field = field;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getStartNum() {
		return startNum;
	}

	public void setStartNum(int startNum) {
		this.startNum = startNum;
	}

	public int getEndNum() {
		return endNum;
	}

	public void setEndNum(int endNum) {
		this.endNum = endNum;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public ReviewSearchVO(String filter, String field, String keyword, String startDate, String endDate, int currentPage,
			int startNum, int endNum, int totalPage, int totalCount, String url) {
		super();
		this.filter = filter;
		this.field = field;
		this.keyword = keyword;
		this.startDate = startDate;
		this.endDate = endDate;
		this.currentPage = currentPage;
		this.startNum = startNum;
		this.endNum = endNum;
		this.totalPage = totalPage;
		this.totalCount = totalCount;
		this.url = url;
	}

	public ReviewSearchVO() {
		super();
	}

	@Override
	public String toString() {
		return "SearchVO [filter=" + filter + ", field=" + field + ", keyword=" + keyword + ", startDate=" + startDate
				+ ", endDate=" + endDate + ", currentPage=" + currentPage + ", startNum=" + startNum + ", endNum="
				+ endNum + ", totalPage=" + totalPage + ", totalCount=" + totalCount + ", url=" + url + "]";
	}

}