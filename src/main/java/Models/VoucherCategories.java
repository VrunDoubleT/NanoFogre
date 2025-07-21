/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author iphon
 */
public class VoucherCategories {
    private int Id;
    private Category CategoryId;
    private Voucher VoucherId;

    public VoucherCategories() {
    }

    public VoucherCategories(int Id, Category CategoryId, Voucher VoucherId) {
        this.Id = Id;
        this.CategoryId = CategoryId;
        this.VoucherId = VoucherId;
    }

    public int getId() {
        return Id;
    }

    public void setId(int Id) {
        this.Id = Id;
    }

    public Category getCategoryId() {
        return CategoryId;
    }

    public void setCategoryId(Category CategoryId) {
        this.CategoryId = CategoryId;
    }

    public Voucher getVoucherId() {
        return VoucherId;
    }

    public void setVoucherId(Voucher VoucherId) {
        this.VoucherId = VoucherId;
    }
    
    
}
