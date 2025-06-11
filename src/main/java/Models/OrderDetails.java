package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class OrderDetails {
    private int id;
    private int orderId;
    private Product product;
    private double price;
    private int quantity;

    public OrderDetails() {
    }

    public OrderDetails(int id, int orderId, Product product, double price, int quantity) {
        this.id = id;
        this.orderId = orderId;
        this.product = product;
        this.price = price;
        this.quantity = quantity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "OrderDetails{" + "id=" + id + ", orderId=" + orderId + ", product=" + product + ", price=" + price + ", quantity=" + quantity + '}';
    }
}
