package Models;

import java.math.BigDecimal;
import java.util.List;

public class Dashboard {
    private List<Revenue> revenueData;
    private List<TopProduct> topProducts;
    private BigDecimal totalRevenue;
    private int totalOrders;

    public Dashboard(List<Revenue> revenueData, List<TopProduct> topProducts, 
                         BigDecimal totalRevenue, int totalOrders) {
        this.revenueData = revenueData;
        this.topProducts = topProducts;
        this.totalRevenue = totalRevenue;
        this.totalOrders = totalOrders;
    }

    // Getters
    public List<Revenue> getRevenueData() { return revenueData; }
    public List<TopProduct> getTopProducts() { return topProducts; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public int getTotalOrders() { return totalOrders; }
}
