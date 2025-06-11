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
    private String scale;
    private String material;
    private double price;
    private int quantity;
    private String paint;
    private String features;
    private String manufacturer;
    private double length;
    private double width;
    private double height;
    private double weight;
    private boolean destroy;
    private Category category;
    private Brand brand;
    private List<String> urls;

    public Product() {
        this.urls = new ArrayList<>();
    }

    public Product(int productId, String title, String slug, String description, String scale, String material, double price, int quantity, String paint, String features, String manufacturer, double length, double width, double height, double weight, boolean _destroy, Category category, Brand brand, List<String> urls) {
        this.productId = productId;
        this.title = title;
        this.slug = slug;
        this.description = description;
        this.scale = scale;
        this.material = material;
        this.price = price;
        this.quantity = quantity;
        this.paint = paint;
        this.features = features;
        this.manufacturer = manufacturer;
        this.length = length;
        this.width = width;
        this.height = height;
        this.weight = weight;
        this.destroy = _destroy;
        this.category = category;
        this.brand = brand;
        this.urls = urls;
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

    public String getScale() {
        return scale;
    }

    public void setScale(String scale) {
        this.scale = scale;
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

    public String getPaint() {
        return paint;
    }

    public void setPaint(String paint) {
        this.paint = paint;
    }

    public String getFeatures() {
        return features;
    }

    public void setFeatures(String features) {
        this.features = features;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public double getLength() {
        return length;
    }

    public void setLength(double length) {
        this.length = length;
    }

    public double getWidth() {
        return width;
    }

    public void setWidth(double width) {
        this.width = width;
    }

    public double getHeight() {
        return height;
    }

    public void setHeight(double height) {
        this.height = height;
    }

    public double getWeight() {
        return weight;
    }

    public void setWeight(double weight) {
        this.weight = weight;
    }

    public boolean isDestroy() {
        return this.destroy;
    }

    public void setDestroy(boolean _destroy) {
        this.destroy = _destroy;
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

    

    @Override
    public String toString() {
        return "Product{" + "productId=" + productId + ", title=" + title + ", slug=" + slug + ", description=" + description + ", scale=" + scale + ", material=" + material + ", price=" + price + ", quantity=" + quantity + ", paint=" + paint + ", features=" + features + ", manufacturer=" + manufacturer + ", length=" + length + ", width=" + width + ", height=" + height + ", weight=" + weight + ", destroy=" + destroy + ", category=" + category + ", brand=" + brand + ", urls=" + urls + '}';
    }
}
