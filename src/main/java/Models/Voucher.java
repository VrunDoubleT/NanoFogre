package Models;

import java.time.LocalDateTime;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Voucher {

    private int id;
    private String code;
    private String type;
    private double value;
    private double minValue;
    private double maxValue;
    private String description;
    private LocalDateTime validFrom;
    private LocalDateTime validTo;
    private boolean isActive;
    private boolean _destroy;
    private int totalUsageLimit;
    private int userUsageLimit;
        
    public Voucher() {
    }

    public Voucher(int id, String code, String type, double value, double minValue, double maxValue, String description, LocalDateTime validFrom, LocalDateTime validTo, boolean isActive, boolean _destroy, int totalUsageLimit, int userUsageLimit) {
        this.id = id;
        this.code = code;
        this.type = type;
        this.value = value;
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.description = description;
        this.validFrom = validFrom;
        this.validTo = validTo;
        this.isActive = isActive;
        this._destroy = _destroy;
        this.totalUsageLimit = totalUsageLimit;
        this.userUsageLimit = userUsageLimit;
    }

    public Voucher(int id, String code, String type, double value, double minValue, double maxValue, String description, LocalDateTime validFrom, LocalDateTime validTo, boolean isActive, boolean _destroy) {
        this.id = id;
        this.code = code;
        this.type = type;
        this.value = value;
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.description = description;
        this.validFrom = validFrom;
        this.validTo = validTo;
        this.isActive = isActive;
        this._destroy = _destroy;
    }
    
    

    public int getTotalUsageLimit() {
        return totalUsageLimit;
    }

    public void setTotalUsageLimit(int totalUsageLimit) {
        this.totalUsageLimit = totalUsageLimit;
    }

    public int getUserUsageLimit() {
        return userUsageLimit;
    }

    public void setUserUsageLimit(int userUsageLimit) {
        this.userUsageLimit = userUsageLimit;
    }



    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }

    public double getMinValue() {
        return minValue;
    }

    public void setMinValue(double minValue) {
        this.minValue = minValue;
    }

    public double getMaxValue() {
        return maxValue;
    }

    public void setMaxValue(double maxValue) {
        this.maxValue = maxValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(LocalDateTime validFrom) {
        this.validFrom = validFrom;
    }

    public LocalDateTime getValidTo() {
        return validTo;
    }

    public void setValidTo(LocalDateTime validTo) {
        this.validTo = validTo;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public boolean isDestroy() {
        return _destroy;
    }

    public void setDestroy(boolean _destroy) {
        this._destroy = _destroy;
    }

    public String getStatus() {
        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(validFrom)) {
            return "Upcoming";
        } else if (!now.isAfter(validTo)) {
            return "Ongoing";
        } else {
            return "Expired";
        }
    }

    @Override
    public String toString() {
        return "Voucher{" + "id=" + id + ", code=" + code + ", type=" + type + ", value=" + value + ", minValue=" + minValue + ", maxValue=" + maxValue + ", description=" + description + ", validFrom=" + validFrom + ", validTo=" + validTo + ", isActive=" + isActive + ", _destroy=" + '}';
    }
}
