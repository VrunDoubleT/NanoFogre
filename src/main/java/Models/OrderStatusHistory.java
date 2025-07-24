/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDateTime;

/**
 *
 * @author iphon
 */
public class OrderStatusHistory {

    private int historyId;
    private int orderId;
    private int statusId;
    private String statusName;
    private String statusNote;
    private LocalDateTime updatedAt;
    private int updatedBy;
    private String updaterName;
    private String updatedAtStr;

    public OrderStatusHistory() {
    }

    public OrderStatusHistory(int historyId, int orderId, int statusId, String statusName, String statusNote, LocalDateTime updatedAt, int updatedBy, String updaterName) {
        this.historyId = historyId;
        this.orderId = orderId;
        this.statusId = statusId;
        this.statusName = statusName;
        this.statusNote = statusNote;
        this.updatedAt = updatedAt;
        this.updatedBy = updatedBy;
        this.updaterName = updaterName;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getStatusId() {
        return statusId;
    }

    public void setStatusId(int statusId) {
        this.statusId = statusId;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    public String getStatusNote() {
        return statusNote;
    }

    public void setStatusNote(String statusNote) {
        this.statusNote = statusNote;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public int getUpdatedBy() {
        return updatedBy;
    }

    public void setUpdatedBy(int updatedBy) {
        this.updatedBy = updatedBy;
    }

    public String getUpdaterName() {
        return updaterName;
    }

    public void setUpdaterName(String updaterName) {
        this.updaterName = updaterName;
    }

    public String getUpdatedAtStr() {
        return updatedAtStr;
    }

    public void setUpdatedAtStr(String updatedAtStr) {
        this.updatedAtStr = updatedAtStr;
    }

}
