package manage.notice;

public class AdminMemberVO {
    private int startNum, endNum, currentPage, totalCount, totalPage;  
    private String field, keyword, url;

    // Getter 및 Setter 메서드
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

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
        this.totalPage = (int) Math.ceil((double) totalCount / 10); // 예: 한 페이지에 10개씩 보여주기
    }

    public int getTotalPage() {
        return totalPage;
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

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @Override
    public String toString() {
        return "AdminMemberVO [startNum=" + startNum + ", endNum=" + endNum + ", currentPage=" + currentPage
                + ", totalCount=" + totalCount + ", totalPage=" + totalPage + ", field=" + field + ", keyword="
                + keyword + ", url=" + url + "]";
    }
}
