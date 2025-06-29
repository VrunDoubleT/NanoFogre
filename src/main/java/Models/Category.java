package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Category {

    private int id;
    private String name;
    private boolean isActive;
    private String avatar;

    public Category() {
    }

    public Category(int id, String name, boolean isActive, String avatar) {
        this.id = id;
        this.name = name;
        this.isActive = isActive;
        this.avatar = avatar;
    }

    public Category(int id, String name) {
        this.id = id;
        this.name = name;
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

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

}
