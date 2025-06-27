package Models;

import java.math.BigDecimal;

public class Revenue {
    private String period;        
    private String originalDate;   
    private BigDecimal revenue;    
    private int orderCount;     

    public Revenue() {
        this.period = "";
        this.originalDate = "";
        this.revenue = BigDecimal.ZERO;
        this.orderCount = 0;
    }

    public Revenue(String period, BigDecimal revenue, int orderCount) {
        this.period = period;
        this.originalDate = period;
        this.revenue = revenue != null ? revenue : BigDecimal.ZERO;
        this.orderCount = orderCount;
    }

    public String getPeriod() { return period; }
    public void setPeriod(String period) { this.period = period; }

    public String getOriginalDate() { return originalDate; }
    public void setOriginalDate(String originalDate) { this.originalDate = originalDate; }

    public BigDecimal getRevenue() { return revenue; }
    public void setRevenue(BigDecimal revenue) { this.revenue = revenue != null ? revenue : BigDecimal.ZERO; }

    public int getOrderCount() { return orderCount; }
    public void setOrderCount(int orderCount) { this.orderCount = orderCount; }
}
