/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author iphon
 */
public class VoucherUserUsage {
    private int Id;
    private Voucher CoucherId;
    private Customer CustomerId;
    private int usageCount;

    public VoucherUserUsage() {
    }

    public VoucherUserUsage(int Id, Voucher CoucherId, Customer CustomerId, int usageCount) {
        this.Id = Id;
        this.CoucherId = CoucherId;
        this.CustomerId = CustomerId;
        this.usageCount = usageCount;
    }

    public int getId() {
        return Id;
    }

    public void setId(int Id) {
        this.Id = Id;
    }

    public Voucher getCoucherId() {
        return CoucherId;
    }

    public void setCoucherId(Voucher CoucherId) {
        this.CoucherId = CoucherId;
    }

    public Customer getCustomerId() {
        return CustomerId;
    }

    public void setCustomerId(Customer CustomerId) {
        this.CustomerId = CustomerId;
    }

    public int getUsageCount() {
        return usageCount;
    }

    public void setUsageCount(int usageCount) {
        this.usageCount = usageCount;
    }
    
    
}
