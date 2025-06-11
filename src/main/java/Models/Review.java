package Models;

import java.time.LocalDateTime;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Review {
    private int id;
    private int productId;
    private Customer customer;
    private int star;
    private String content;
    private LocalDateTime createdAt;
    private List<Reply> replies;

    public Review() {
    }

    public Review(int id, int productId, Customer customer, int star, String content, LocalDateTime createdAt, List<Reply> replies) {
        this.id = id;
        this.productId = productId;
        this.customer = customer;
        this.star = star;
        this.content = content;
        this.createdAt = createdAt;
        this.replies = replies;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public int getStar() {
        return star;
    }

    public void setStar(int star) {
        this.star = star;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public List<Reply> getReplies() {
        return replies;
    }

    public void setReplies(List<Reply> replies) {
        this.replies = replies;
    }

    @Override
    public String toString() {
        return "Review{" + "id=" + id + ", productId=" + productId + ", customer=" + customer + ", star=" + star + ", content=" + content + ", createdAt=" + createdAt + ", replies=" + replies + '}';
    }
}
