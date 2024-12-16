package manage.notice;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString

public class NoticeVO {
	private int notice_id, category_id, hits;
	private String title, content, admin_Id, status, category;
	private Timestamp created_at;

}// class
