package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class PaymentStatus {
    private int id;
    private String name;
    private String description;

    public PaymentStatus() {
    }

    public PaymentStatus(int id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "PaymentStatus{" + "id=" + id + ", name=" + name + ", description=" + description + '}';
    }
}
