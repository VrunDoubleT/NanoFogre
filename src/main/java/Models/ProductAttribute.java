package Models;

/**
 *
 * @author iphon
 */
public class ProductAttribute {
    private Integer id;
    private String name;
    private String unit;
    private String minValue;
    private String maxValue;
    private String dataType;
    private String value;
    private Boolean isRequired;
    private Boolean isActive;
    private Category category;

    public ProductAttribute() {
    }

    public ProductAttribute(Integer id, String name, String unit, String minValue, String maxValue, String dataType, String value, Boolean isRequired, Boolean isActive, Category category) {
        this.id = id;
        this.name = name;
        this.unit = unit;
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.dataType = dataType;
        this.value = value;
        this.isRequired = isRequired;
        this.isActive = isActive;
        this.category = category;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getMinValue() {
        return minValue;
    }

    public void setMinValue(String minValue) {
        this.minValue = minValue;
    }

    public String getMaxValue() {
        return maxValue;
    }

    public void setMaxValue(String maxValue) {
        this.maxValue = maxValue;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public Boolean getIsRequired() {
        return isRequired;
    }

    public void setIsRequired(Boolean isRequired) {
        this.isRequired = isRequired;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    /**
     * Get CategoryId quickly for DAO operations
     */
    public Integer getCategoryId() {
        return category != null ? category.getId() : null;
    }

    /**
     * Set Category by id (for quick mapping in DAO)
     */
    public void setCategoryId(Integer categoryId) {
        if (this.category == null) {
            this.category = new Category();
        }
        this.category.setId(categoryId);
    }

    @Override
    public String toString() {
        return "ProductAttribute{" + "id=" + id + ", name=" + name + ", unit=" + unit + ", minValue=" + minValue + ", maxValue=" + maxValue + ", dataType=" + dataType + ", value=" + value + ", isRequired=" + isRequired + ", isActive=" + isActive + ", category=" + category + '}';
    }
    
    
}
