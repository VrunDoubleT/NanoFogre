package Models;

import java.time.LocalDateTime;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class Reply {
    private int id;
    private int previewId;
    private Employee employee;
    private String content;
    private LocalDateTime createdAt;

    public Reply() {
    }

    public Reply(int id, int previewId, Employee employee, String content, LocalDateTime createdAt) {
        this.id = id;
        this.previewId = previewId;
        this.employee = employee;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPreviewId() {
        return previewId;
    }

    public void setPreviewId(int previewId) {
        this.previewId = previewId;
    }

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Reply{" + "id=" + id + ", previewId=" + previewId + ", employee=" + employee + ", content=" + content + ", createdAt=" + createdAt + '}';
    }
    
    
}
