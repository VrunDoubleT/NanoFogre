package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Category {

    private int id;
    private String name;
    private boolean isDeleted; // 0 = không xóa, 1 = đã xóa
  
    public Category() {
    }

    public Category(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public Category(int id, String name, boolean isDeleted) {
        this.id = id;
        this.name = name;
        this.isDeleted = isDeleted;
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

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }



    @Override
    public String toString() {
        return "Category{" + "id=" + id + ", name=" + name + ", isDeleted=" + isDeleted + '}';
    }
}
