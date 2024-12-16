package manage.user;

public class AdminMemberVO {
private int startNum,endNum,currntPage;  
private String field, keyword;

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

public int getCurrntPage() {
	return currntPage;
}

public void setCurrntPage(int currntPage) {
	this.currntPage = currntPage;
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

@Override
public String toString() {
	return "AdminMemberVO [startNum=" + startNum + ", endNum=" + endNum + ", currntPage=" + currntPage + ", field="
			+ field + ", keyword=" + keyword + "]";
}









}
