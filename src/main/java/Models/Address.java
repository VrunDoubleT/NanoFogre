package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Address {

    private int id;
    private String name;          
    private String recipientName;
    private String details;        
    private String phone;          
    private boolean isDefault;     
    private int customerId;
    private String fullAddress;

    public Address() {
    }

    public Address(int id, String name, String recipientName, String details, String phone, boolean isDefault, int customerId) {
        this.id = id;
        this.name = name;
        this.recipientName = recipientName;
        this.details = details;
        this.phone = phone;
        this.isDefault = isDefault;
        this.customerId = customerId;
    }

    public String getFullAddress() {
        return fullAddress;
    }

    public void setFullAddress(String fullAddress) {
        this.fullAddress = fullAddress;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public boolean isIsDefault() {
        return isDefault;
    }

    public void setIsDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    @Override
    public String toString() {
        return "Address{" + "id=" + id + ", name=" + name + ", recipientName=" + recipientName + ", details=" + details + ", phone=" + phone + ", isDefault=" + isDefault + ", customerId=" + customerId + '}';
    }
}
