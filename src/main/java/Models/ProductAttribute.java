/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author iphon
 */
public class ProductAttribute {

    private Integer attributeId;
    private String attributeName;
    private String unit;
    private String minValue;
    private String maxValue;
    private String dataType;
    private Boolean isActive;
    private Boolean isRequired;
    private Category category;

    public ProductAttribute() {
    }

    public ProductAttribute(Integer attributeId, String attributeName, String unit, String minValue, String maxValue, String dataType, Boolean isActive, Boolean isRequired, Category category) {
        this.attributeId = attributeId;
        this.attributeName = attributeName;
        this.unit = unit;
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.dataType = dataType;
        this.isActive = isActive;
        this.isRequired = isRequired;
        this.category = category;
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

    public Integer getAttributeId() {
        return attributeId;
    }

    public void setAttributeId(Integer attributeId) {
        this.attributeId = attributeId;
    }

    public String getAttributeName() {
        return attributeName;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Boolean getIsRequired() {
        return isRequired;
    }

    public void setIsRequired(Boolean isRequired) {
        this.isRequired = isRequired;
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

}
