package user.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class InquirySearchVO {
	private int startNum, endNum, currentPage = 1, totalPage, totalCount;
	private String category, keyword, url, userId, filter = "전체", field = "0", startDate, endDate;

}
