package boardver2.dto;

public class BoardDTO {
	
	private int num;
	private String title;
	private String name;
	private String contents;
	private String img_path;
	private String reg_date;
	private String ip;
	private int view_cnt;
	private String up_date;
	private String id;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUp_date() {
		return up_date;
	}
	public void setUp_date(String up_date) {
		this.up_date = up_date;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getTitle() {
		if(title == null) {
			title ="";
		}
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getName() {
		if(name == null) {
			name ="";
		}
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getContents() {
		if(contents == null) {
			contents ="";
		}
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getImg_path() {
		return img_path;
	}
	public void setImg_path(String img_path) {
		this.img_path = img_path;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public int getView_cnt() {
		return view_cnt;
	}
	public void setView_cnt(int view_cnt) {
		this.view_cnt = view_cnt;
	}
	
	
	@Override
	public String toString() {
		return "BoardDTO [num=" + num + ", title=" + title + ", name=" + name + ", contents=" + contents + ", img_path="
				+ img_path + ", reg_date=" + reg_date + ", ip=" + ip + ", view_cnt=" + view_cnt + "]";
	}
	
	
	
	
	

}
