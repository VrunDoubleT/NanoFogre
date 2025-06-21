package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Attribute {
    private int id;
    private String value;

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return "Attribute{" + "id=" + id + ", value=" + value + '}';
    }
}
