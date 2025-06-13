package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Brand {
    private int id;
    private String name;
    private String url;
    private String category;
    public Brand() {
    }

    public Brand(int id, String name, String url) {
        this.id = id;
        this.name = name;
        this.url = url;
        this.category = category;
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

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    @Override
    public String toString() {
        return "Brand{" + "id=" + id + ", name=" + name + ", url=" + url + ", category='" + category + '\'' +'}';
    }
}
