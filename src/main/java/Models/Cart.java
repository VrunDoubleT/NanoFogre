package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Cart{
    private int cartId;
    private int customerId;
    private int quantity;
    private Product product;

    public Cart() {
    }

    public Cart(int cartId, int customerId, int quantity, Product product) {
        this.cartId = cartId;
        this.customerId = customerId;
        this.quantity = quantity;
        this.product = product;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    @Override
    public String toString() {
        return "Cart{" + "cartId=" + cartId + ", customerId=" + customerId + ", quantity=" + quantity + ", product=" + product + '}';
    }
    
    
}
