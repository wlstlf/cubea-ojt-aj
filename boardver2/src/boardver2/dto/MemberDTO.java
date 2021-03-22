package boardver2.dto;

public class MemberDTO {
	
	private String id;
	private String pwd;
	private String name;
	private String email;
	private String tel1;
	private String tel2;
	private String tel3;
	private String reg_date;
	private String gubun;
	
	
	public String getId() {
		return id;
	}
	public String getTel1() {
		return tel1;
	}
	public void setTel1(String tel1) {
		this.tel1 = tel1;
	}
	public String getTel2() {
		return tel2;
	}
	public void setTel2(String tel2) {
		this.tel2 = tel2;
	}
	public String getTel3() {
		return tel3;
	}
	public void setTel3(String tel3) {
		this.tel3 = tel3;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	
	
	@Override
	public String toString() {
		return "MemberDTO [id=" + id + ", pwd=" + pwd + ", name=" + name + ", email=" + email + ", tel1=" + tel1
				+ ", tel2=" + tel2 + ", tel3=" + tel3 + ", reg_date=" + reg_date + ", gubun=" + gubun + ", getId()="
				+ getId() + ", getTel1()=" + getTel1() + ", getTel2()=" + getTel2() + ", getTel3()=" + getTel3()
				+ ", getPwd()=" + getPwd() + ", getName()=" + getName() + ", getEmail()=" + getEmail()
				+ ", getReg_date()=" + getReg_date() + ", getGubun()=" + getGubun() + ", getClass()=" + getClass()
				+ ", hashCode()=" + hashCode() + ", toString()=" + super.toString() + "]";
	}
	
	

}
