package Models;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Product {
    private int productId;
    private String title;
    private String slug;
    private String description;
    private String material;
    private double price;
    private int quantity;
    private boolean isActive;
    private boolean destroy;
    private Category category;
    private Brand brand;
    private List<String> urls;
    private List<ProductAttribute> attributes;

    public Product() {
    }

    public Product(int productId, String title, String slug, String description, String material, double price, int quantity, boolean isActive, boolean destroy, Category category, Brand brand, List<String> urls, List<ProductAttribute> attributes) {
        this.productId = productId;
        this.title = title;
        this.slug = slug;
        this.description = description;
        this.material = material;
        this.price = price;
        this.quantity = quantity;
        this.isActive = isActive;
        this.destroy = destroy;
        this.category = category;
        this.brand = brand;
        this.urls = urls;
        this.attributes = attributes;
    }

    

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getMaterial() {
        return material;
    }

    public void setMaterial(String material) {
        this.material = material;
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

    public boolean isActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public boolean isDestroy() {
        return destroy;
    }

    public void setDestroy(boolean destroy) {
        this.destroy = destroy;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Brand getBrand() {
        return brand;
    }

    public void setBrand(Brand brand) {
        this.brand = brand;
    }

    public List<String> getUrls() {
        return urls;
    }

    public void setUrls(List<String> urls) {
        this.urls = urls;
    }

    public List<ProductAttribute> getAttributes() {
        return attributes;
    }

    public void setAttributes(List<ProductAttribute> attributes) {
        this.attributes = attributes;
    }

    @Override
    public String toString() {
        return "Product{" + "productId=" + productId + ", title=" + title + ", slug=" + slug + ", description=" + description + ", material=" + material + ", price=" + price + ", quantity=" + quantity + ", isActive=" + isActive + ", destroy=" + destroy + ", category=" + category + ", brand=" + brand + ", urls=" + urls + ", attributes=" + attributes + '}';
    }
}
