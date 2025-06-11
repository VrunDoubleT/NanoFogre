package Models;

import Utils.CurrencyFormatter;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class ProductStat {

    private int totalProducts;
    private int inventory;
    private double inventoryValue;
    private int outOfStockProducts;

    public ProductStat() {
    }

    public ProductStat(int totalProducts, int inventory, double inventoryValue, int outOfStockProducts) {
        this.totalProducts = totalProducts;
        this.inventory = inventory;
        this.inventoryValue = inventoryValue;
        this.outOfStockProducts = outOfStockProducts;
    }

    

    public int getTotalProducts() {
        return totalProducts;
    }

    public void setTotalProducts(int totalProducts) {
        this.totalProducts = totalProducts;
    }

    public int getInventory() {
        return inventory;
    }

    public void setInventory(int inventory) {
        this.inventory = inventory;
    }

    public double getInventoryValue() {
        return inventoryValue;
    }

    public void setInventoryValue(double inventoryValue) {
        this.inventoryValue = inventoryValue;
    }

    public int getOutOfStockProducts() {
        return outOfStockProducts;
    }
    
    public String getInventoryValueFormat(){
        return CurrencyFormatter.formatCurrencyShort(inventoryValue);
    }

    public void setOutOfStockProducts(int outOfStockProducts) {
        this.outOfStockProducts = outOfStockProducts;
    }

    @Override
    public String toString() {
        return "ProductStat{" + "totalProducts=" + totalProducts + ", inventory=" + inventory + ", inventoryValue=" + inventoryValue + ", outOfStockProducts=" + outOfStockProducts + '}';
    }
}
