package user.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

public class SearchVO {
	private int startNum, endNum, currentPage, totalPage, totalCount;
	private String keyword, url;

}
