/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.AddressDAO;
import DAOs.CartDAO;
import DAOs.OrderDAO;
import DAOs.VoucherDAO;
import Models.Address;
import Models.Cart;
import Models.Customer;
import Models.OrderStatus;
import Models.PaymentMethod;
import Models.PaymentStatus;
import Models.Voucher;
import Utils.CurrencyFormatter;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.cloudinary.json.JSONArray;
import org.cloudinary.json.JSONObject;

/**
 *
 * @author iphon
 */
@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("customer") : null;
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        int customerId = customer.getId();

        // 2. Lấy cartIdsJson từ request, phải là JSON array dạng: [12, 18, 22]
        String cartIdsJson = request.getParameter("cartIds");
        String voucherCode = request.getParameter("voucher");

        // Nếu cartIdsJson rỗng → báo lỗi
        if (cartIdsJson == null || cartIdsJson.trim().isEmpty() || cartIdsJson.equals("[]")) {
            request.setAttribute("errorMessage", "No items selected for purchase.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/Purchase.jsp").forward(request, response);
            return;
        }

        // 3. Parse cartIdsJson thành List<Integer>
        List<Integer> cartIdList = new ArrayList<>();
        try {
            Gson gson = new Gson();
            Type listType = new TypeToken<List<Integer>>() {
            }.getType();
            cartIdList = gson.fromJson(cartIdsJson, listType);
        } catch (Exception ex) {
            // Nếu parse lỗi, báo lỗi luôn
            request.setAttribute("errorMessage", "Invalid cart data.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/Purchase.jsp").forward(request, response);
            return;
        }

        if (cartIdList == null || cartIdList.isEmpty()) {
            request.setAttribute("errorMessage", "No valid items selected for purchase.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/Purchase.jsp").forward(request, response);
            return;
        }

        // 4. Lấy các cart item
        CartDAO cartDAO = new CartDAO();
        List<Cart> selectedItems = new ArrayList<>();
        for (Integer cartIdInt : cartIdList) {
            Cart cartItem = cartDAO.getCartItemById(cartIdInt);
            if (cartItem != null && cartItem.getCustomerId() == customerId) {
                selectedItems.add(cartItem);
            }
        }

        if (selectedItems.isEmpty()) {
            request.setAttribute("errorMessage", "No valid items found in your cart.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/Purchase.jsp").forward(request, response);
            return;
        }

        // 5. Lấy voucher nếu có
        Voucher voucher = null;
        VoucherDAO voucherDAO = new VoucherDAO();
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            voucher = voucherDAO.findByCode(voucherCode.trim());
        }

        // 6. Xử lý selectedAddress (ưu tiên session, nếu không có lấy default)
        AddressDAO addressDAO = new AddressDAO();
        Address selectedAddress = (Address) session.getAttribute("selectedAddress");
        if (selectedAddress != null) {
            try {
                Address refreshed = addressDAO.getById(selectedAddress.getId());
                if (refreshed == null || refreshed.getCustomerId() != customerId) {
                    selectedAddress = null;
                    session.removeAttribute("selectedAddress");
                } else {
                    selectedAddress = refreshed;
                }
            } catch (Exception e) {
                selectedAddress = null;
            }
        }
        if (selectedAddress == null) {
            selectedAddress = cartDAO.getDefaultAddressByCustomerId(customerId);
            if (selectedAddress != null) {
                session.setAttribute("selectedAddress", selectedAddress);
            }
        }
        Address defaultAddress = addressDAO.getDefaultAddress(customerId);
        request.setAttribute("address", defaultAddress);
        // 7. Cập nhật số điện thoại khách hàng nếu thiếu
        if ((customer.getPhone() == null || customer.getPhone().trim().isEmpty())
                && selectedAddress != null && selectedAddress.getPhone() != null) {
            customer.setPhone(selectedAddress.getPhone());
        }

        // 8. Lấy danh sách địa chỉ và voucher còn hiệu lực
        List<Address> availableAddresses = addressDAO.getAddressesByCustomerId(customerId);
        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForUser(customerId);

        // 9. Set attributes cho JSP
        request.setAttribute("customer", customer);
        request.setAttribute("selectedItems", selectedItems);
        request.setAttribute("voucher", voucher);
        request.setAttribute("availableVouchers", availableVouchers);
        request.setAttribute("cartIdsJson", cartIdsJson); // vẫn giữ nguyên chuỗi json mảng
        request.setAttribute("availableAddresses", availableAddresses);
        request.setAttribute("address", selectedAddress);

        // 10. Chuyển đến trang Purchase.jsp
        request.getRequestDispatcher("/WEB-INF/customers/pages/Purchase.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> json = new HashMap<>();
        AddressDAO addressDao = new AddressDAO();
        HttpSession session = request.getSession(false);
        Customer customer = session != null ? (Customer) session.getAttribute("customer") : null;
        if (customer == null) {
            json.put("success", false);
            json.put("message", "You must log in first.");
            out.print(gson.toJson(json));
            return;
        }

        String action = request.getParameter("action");
        CartDAO cartDao = new CartDAO();
        VoucherDAO voucherDao = new VoucherDAO();

        switch (action) {
            case "updateCustomerInfo":
                // 1) Lấy giá trị mới từ form
                String newRecipient = request.getParameter("recipientName");
                String newAddressName = request.getParameter("addressName");
                String newPhone = request.getParameter("phone");
                String newDetails = request.getParameter("address");

                // === BƯỚC DEBUG QUAN TRỌNG NHẤT ===
                // Di chuyển các lệnh in lên đây để xem server thực sự nhận được gì TRƯỚC KHI xử lý
                System.out.println("--- RAW DATA RECEIVED FROM CLIENT ---");
                System.out.println("Recipient from request: '" + newRecipient + "'");
                System.out.println("AddressName from request: '" + newAddressName + "'");
                System.out.println("Phone from request: '" + newPhone + "'");
                System.out.println("Address/Details from request: '" + newDetails + "'");
                System.out.println("------------------------------------");

                // 2) Lấy địa chỉ default hiện tại (nếu có)
                Address oldAddr = cartDao.getDefaultAddressByCustomerId(customer.getId());

                if (oldAddr == null) {
                    // Lần đầu: bắt buộc nhập đủ
                    if (newRecipient == null || newRecipient.trim().isEmpty()
                            || newAddressName == null || newAddressName.trim().isEmpty()
                            || newPhone == null || newPhone.trim().isEmpty()
                            || newDetails == null || newDetails.trim().isEmpty()) {
                        json.put("success", false);
                        json.put("message", "Please fill in your address information completely for the first time.");
                        break; // Dừng lại ở đây
                    }
                } else {
                    // Những lần sau: nếu người dùng để trống thì giữ lại giá trị cũ
                    if (newRecipient == null || newRecipient.trim().isEmpty()) {
                        newRecipient = oldAddr.getRecipientName();
                    }
                    if (newAddressName == null || newAddressName.trim().isEmpty()) {
                        newAddressName = oldAddr.getName();
                    }
                    if (newPhone == null || newPhone.trim().isEmpty()) {
                        newPhone = oldAddr.getPhone();
                    }
                    if (newDetails == null || newDetails.trim().isEmpty()) {
                        newDetails = oldAddr.getDetails();
                    }
                }

                // 3) Gọi wrapper trong DAO (wrapper này sẽ tự check hasDefaultAddress để insert hoặc update)
                boolean ok = cartDao.updateCustomerInfo(
                        customer.getId(),
                        newAddressName, // addressName
                        newRecipient, // recipientName
                        newPhone, // phone
                        newDetails // details
                );

                json.put("success", ok);
                json.put("message", ok
                        ? "Information updated successfully"
                        : "Failed to update information");
                break;

            case "removeVoucher":
                // đơn giản chỉ cần reload, không làm gì
                json.put("success", true);
                break;

            case "applyVoucher":
                String voucherCode = request.getParameter("voucherCode");
                String cartIds = request.getParameter("cartIds");

                if (voucherCode == null || voucherCode.trim().isEmpty()) {
                    json.put("success", false);
                    json.put("message", "Voucher code cannot be empty");
                    break;
                }

                VoucherDAO vDao = new VoucherDAO();
                Voucher v = vDao.findByCode(voucherCode.trim());

                if (v == null) {
                    json.put("success", false);
                    json.put("message", "Voucher does not exist or has expired");
                    break;
                }

                // Parse cartIds JSON string into List<Integer>
                List<Integer> cartIdList = new ArrayList<>();
                if (cartIds != null && !cartIds.trim().isEmpty()) {
                    JSONArray jsonArray = new JSONArray(cartIds);
                    for (int i = 0; i < jsonArray.length(); i++) {
                        cartIdList.add(jsonArray.getInt(i));
                    }
                }

                // Retrieve Cart items
                CartDAO cartDaos = new CartDAO();
                List<Cart> selectedItems = cartDaos.getCartItemById(cartIdList);

                // Calculate subtotal
                double subtotal = 0;
                for (Cart cart : selectedItems) {
                    subtotal += cart.getQuantity() * cart.getProduct().getPrice();
                }

                // Calculate discount based on voucher
                double discount = 0;
                if ("percentage".equalsIgnoreCase(v.getType())) {
                    discount = subtotal * (v.getValue() / 100.0);
                    if (v.getMaxValue() > 0 && discount > v.getMaxValue()) {
                        discount = v.getMaxValue();
                    }
                } else {
                    discount = v.getValue();
                }

                double total = subtotal - discount;
                if (total < 0) {
                    total = 0;
                }

                // Store voucher in session
                HttpSession sess = request.getSession();
                sess.setAttribute("appliedVoucher", v);

                // Return JSON to frontend
                json.put("success", true);
                json.put("message", "Voucher applied successfully");
                json.put("subtotal", subtotal);
                json.put("discount", discount);
                json.put("total", total);
                json.put("subtotalFormatted", CurrencyFormatter.formatVietNamCurrency(subtotal));
                json.put("discountFormatted", CurrencyFormatter.formatVietNamCurrency(discount));
                json.put("totalFormatted", CurrencyFormatter.formatVietNamCurrency(total));
                json.put("voucherId", v.getId());
                break;

            case "processPurchase": 
                try {
                // 1. Lấy thông tin cần thiết
                String cartIdsParam = request.getParameter("cartIds");
                System.out.println("cartIdsParam = " + cartIdsParam);
                if (cartIdsParam == null || cartIdsParam.isEmpty()) {
                    json.put("success", false);
                    json.put("message", "No cart items found.");
                    break;
                }

                JSONArray jsonArray = new JSONArray(cartIdsParam);
                List<Integer> cartIdse = new ArrayList<>();
                for (int i = 0; i < jsonArray.length(); i++) {
                    cartIdse.add(jsonArray.getInt(i));
                }

                int addressId = Integer.parseInt(request.getParameter("addressId"));

                String voucherParam = request.getParameter("voucherId");
                Integer voucherId = null;
                // Chỉ parse khi voucherParam hoàn toàn là chữ số
                if (voucherParam != null && voucherParam.matches("\\d+")) {
                    voucherId = Integer.valueOf(voucherParam);
                }

                // 2. Lấy lại danh sách cart và voucher
                List<Cart> selectedCarts = cartDao.getCartItemById(cartIdse); // ✅ đúng
                if (selectedCarts == null || selectedCarts.isEmpty()) {
                    json.put("success", false);
                    json.put("message", "Cart items not found.");
                    break;
                }

                double subtotals = 0;
                for (Cart c : selectedCarts) {
                    subtotals += c.getQuantity() * c.getProduct().getPrice();
                }

                VoucherDAO voucherDaos = new VoucherDAO();

                double discounts = 0;
                if (voucherId != null) {
                    Voucher vs = voucherDaos.getVoucherById(voucherId);
                    if (vs != null) {
                        if ("percentage".equalsIgnoreCase(vs.getType())) {
                            discounts = subtotals * (vs.getValue() / 100.0);
                            if (vs.getMaxValue() > 0 && discounts > vs.getMaxValue()) {
                                discounts = vs.getMaxValue();
                            }
                        } else {
                            discounts = vs.getValue();
                        }
                    }
                }
                double totals = Math.max(0, subtotals - discounts);
                Models.Order order = new Models.Order();

                // Gán Customer
                Customer cust = new Customer();
                cust.setId(customer.getId());
                order.setCustomer(cust);

                // Gán Voucher nếu có
                if (voucherId != null) {
                    Voucher voucher = new Voucher();
                    voucher.setId(voucherId);
                    order.setVoucher(voucher);
                    System.out.println("voucher Purchase:" + voucher);
                }

                // Gán Address
                Address addr = new Address();
                addr.setId(addressId);
                order.setAddress(addr);

                // Gán các object khác (PaymentMethod, PaymentStatus, OrderStatus)
                PaymentMethod pm = new PaymentMethod();
                pm.setId(1); // COD
                order.setPaymentMethod(pm);

                PaymentStatus ps = new PaymentStatus();
                ps.setId(1); // Unpaid
                order.setPaymentStatus(ps);

                OrderStatus os = new OrderStatus();
                os.setId(1); // Pending
                order.setOrderStatus(os);

                // Gán giá trị số
                order.setTotalAmount(totals);
                order.setShippingFee(0);
                System.out.println("About to insert order: total=" + order.getTotalAmount()
                        + ", voucherId=" + (order.getVoucher() != null ? order.getVoucher().getId() : "null"));

                OrderDAO orderDAO = new OrderDAO();
                int orderId = orderDAO.insertOrder(order); // bạn cần đảm bảo hàm này trả về id

                // 4. Insert OrderDetails + Cập nhật tồn kho
                for (Cart c : selectedCarts) {
                    orderDAO.insertOrderDetail(orderId, c.getProduct().getProductId(), c.getQuantity(), c.getProduct().getPrice());
                    orderDAO.decreaseProductStock(c.getProduct().getProductId(), c.getQuantity());
                }

                // 5. Xóa cart đã mua
                //   cartDao.removeCartItems(cartIdse);
                json.put("success", true);
                json.put("message", "Order placed successfully!");

            } catch (Exception e) {
                e.printStackTrace();
                json.put("success", false);
                json.put("message", "Error processing order.");
            }
            break;

            ////////////////////////////

            case "addAddress":
    String addrName = request.getParameter("addressName");
    String recip = request.getParameter("recipientName");
    String phone = request.getParameter("addressPhone");
    String details = request.getParameter("addressDetails");
    if (addrName == null || addrName.isEmpty()
            || recip == null || recip.isEmpty()
            || phone == null || phone.isEmpty()
            || details == null || details.isEmpty()) {
        json.put("success", false);
        json.put("message", "Please fill in all information.");
        break;
    }

    Address a = new Address();
    a.setCustomerId(customer.getId());
    a.setName(addrName);
    a.setRecipientName(recip);
    a.setPhone(phone);
    a.setDetails(details);
    int newAddressId = -1;
    try {
        newAddressId = addressDao.insert(a);
    } catch (SQLException e) {
        e.printStackTrace();
    }

    if (newAddressId > 0) {
        json.put("success", true);
        json.put("message", "Address added successfully");
        json.put("newAddressId", newAddressId);
    } else {
        json.put("success", false);
        json.put("message", "Failed to add");
    }
    break;

//            case "addAddress":
//                // 1) Read and validate
//                String addrName = request.getParameter("addressName");
//                String recip = request.getParameter("recipientName");
//                String phone = request.getParameter("addressPhone");
//                String details = request.getParameter("addressDetails");
//                if (addrName == null || addrName.isEmpty()
//                        || recip == null || recip.isEmpty()
//                        || phone == null || phone.isEmpty()
//                        || details == null || details.isEmpty()) {
//                    json.put("success", false);
//                    json.put("message", "Vui lòng điền đầy đủ thông tin.");
//                    break;
//                }
//
//                // 2) Insert
//                Address a = new Address();
//                a.setCustomerId(customer.getId());
//                a.setName(addrName);
//                a.setRecipientName(recip);
//                a.setPhone(phone);
//                a.setDetails(details);
//                boolean added = false;
//                try {
//                    added = addressDao.insert(a);
//                } catch (SQLException e) {
//                    e.printStackTrace();
//                }
//
//                json.put("success", added);
//                json.put("message", added ? "Address added" : "Failed to add");
//                
//                break;

            case "editAddress":
                int id = Integer.parseInt(request.getParameter("addressId"));
                Address aa = new Address();
                aa.setId(id);
                aa.setCustomerId(customer.getId());
                aa.setName(request.getParameter("addressName"));
                aa.setRecipientName(request.getParameter("recipientName"));
                aa.setPhone(request.getParameter("addressPhone"));
                aa.setDetails(request.getParameter("addressDetails"));
                boolean oks = false;
                try {
                    oks = addressDao.update(aa);
                } catch (SQLException ex) {
                    Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                json.put("success", oks);
                json.put("message", oks ? "Address updated" : "Failed to update");
             
                break;

            case "deleteAddress":
                int addressIds = Integer.parseInt(request.getParameter("addressId"));
                boolean deleted = false;
                String message = "";

  
                try {
                    deleted = addressDao.delete(addressIds);
                    if (deleted) {
                        message = "Address has been deleted.";
                    } else {
                        message = "Address does not exist or has already been deleted.";
                    }
                } catch (SQLException ex) {
                    String errMsg = ex.getMessage();
                    if (errMsg != null && errMsg.contains("REFERENCE constraint")) {
                        message = "Cannot delete: this address is referenced by existing orders.";
                    } else {
                        message = "Error occurred while deleting the address. Please try again.";
                    }
                    Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, "deleteAddress error", ex);
                }

                json.put("success", deleted);
                json.put("message", message);
                break;

            // CheckoutServlet.java
            case "selectAddress":
                 try {
                int addressId = Integer.parseInt(request.getParameter("addressId"));
                AddressDAO addressDAO = new AddressDAO();
                // Cập nhật địa chỉ mặc định trong DB
                boolean success = addressDAO.setDefaultAddress(customer.getId(), addressId);

                if (success) {
                    // Lấy thông tin đầy đủ của địa chỉ vừa được chọn
                    Address selectedAddress = addressDAO.getById(addressId);

                    // Cập nhật session
                    session.setAttribute("selectedAddress", selectedAddress);

                    // Chuẩn bị dữ liệu để trả về client
                    json.put("success", true);
                    json.put("message", "Đã cập nhật địa chỉ giao hàng.");

                    // *** PHẦN THÊM VÀO ***
                    if (selectedAddress != null) {
                        JSONObject addressJson = new JSONObject();
                        addressJson.put("id", selectedAddress.getId());
                        addressJson.put("name", selectedAddress.getName());
                        addressJson.put("recipient", selectedAddress.getRecipientName());
                        addressJson.put("phone", selectedAddress.getPhone());
                        addressJson.put("details", selectedAddress.getDetails());
                        json.put("address", addressJson);
                    }
                    // *********************

                } else {
                    json.put("success", false);
                    json.put("message", "Không thể cập nhật địa chỉ mặc định.");
                }

            } catch (NumberFormatException e) {
                json.put("success", false);
                json.put("message", "Address ID không hợp lệ.");
            } catch (Exception e) { // Bắt Exception chung cho an toàn
                json.put("success", false);
                json.put("message", "Lỗi khi xử lý địa chỉ.");
                Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, e);
            }
            break;

            default:
                json.put("success", false);
                json.put("message", "Action không hợp lệ");
        }

        out.print(gson.toJson(json));
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
