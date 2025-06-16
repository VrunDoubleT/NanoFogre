package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class ProductImage {
    private int imageId;
    private String url;

    public ProductImage(int imageId, String url) {
        this.imageId = imageId;
        this.url = url;
    }

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
