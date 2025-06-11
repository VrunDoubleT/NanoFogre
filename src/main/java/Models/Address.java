package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Address {
    private int id;
    private String province;
    private String district;
    private String commune;
    private String extraInfo;
    private String phone;
    private int customerId;

    public Address() {
    }

    public Address(int id, String province, String district, String commune, String extraInfo, String phone, int customerId) {
        this.id = id;
        this.province = province;
        this.district = district;
        this.commune = commune;
        this.extraInfo = extraInfo;
        this.phone = phone;
        this.customerId = customerId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCommune() {
        return commune;
    }

    public void setCommune(String commune) {
        this.commune = commune;
    }

    public String getExtraInfo() {
        return extraInfo;
    }

    public void setExtraInfo(String extraInfo) {
        this.extraInfo = extraInfo;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    @Override
    public String toString() {
        return "Address{" + "id=" + id + ", province=" + province + ", district=" + district + ", commune=" + commune + ", extraInfo=" + extraInfo + ", phone=" + phone + ", customerId=" + customerId + '}';
    }
    
    
}
