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
    private boolean reviewed;
    private Address address;
    private String reviewContent;
    private Integer reviewStar;
    
    public OrderDetails() {
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }

    public OrderDetails(int id, int orderId, Product product, double price, int quantity, boolean reviewed, Address address) {
        this.id = id;
        this.orderId = orderId;
        this.product = product;
        this.price = price;
        this.quantity = quantity;
        this.reviewed = reviewed;
        this.address = address;
    }

    public OrderDetails(int id, int orderId, Product product, double price, int quantity) {
        this.id = id;
        this.orderId = orderId;
        this.product = product;
        this.price = price;
        this.quantity = quantity;
    }
    
    public OrderDetails(int id, int orderId, Product product, double price, int quantity, boolean reviewed) {
        this.id = id;
        this.orderId = orderId;
        this.product = product;
        this.price = price;
        this.quantity = quantity;
        this.reviewed = reviewed;
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

    public boolean isReviewed() {
        return reviewed;
    }

    public void setReviewed(boolean reviewed) {
        this.reviewed = reviewed;
    }

    public String getReviewContent() {
        return reviewContent;
    }

    public void setReviewContent(String reviewContent) {
        this.reviewContent = reviewContent;
    }

    public Integer getReviewStar() {
        return reviewStar;
    }

    public void setReviewStar(Integer reviewStar) {
        this.reviewStar = reviewStar;
    }

    @Override
    public String toString() {
        return "OrderDetails{" + "id=" + id + ", orderId=" + orderId + ", product=" + product + ", price=" + price + ", quantity=" + quantity + ", reviewed=" + reviewed + '}';
    }
}
