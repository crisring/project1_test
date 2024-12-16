package manage.inquiry;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor

public class InquiryVO {
//,제목,처리상태,등록일 작성자
	private int inquiryId;
	private String category, title, content, status, userId, adminAd, answer;
	private Timestamp createAt;

}