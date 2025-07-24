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

        HttpSession session = request.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("customer") : null;
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        int customerId = customer.getId();

        String cartIdsJson = request.getParameter("cartIds");
        String voucherCode = request.getParameter("voucher");

        if (cartIdsJson == null || cartIdsJson.trim().isEmpty() || cartIdsJson.equals("[]")) {
            request.setAttribute("errorMessage", "No items selected for purchase.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
            return;
        }

        List<Integer> cartIdList = new ArrayList<>();
        try {
            Gson gson = new Gson();
            Type listType = new TypeToken<List<Integer>>() {
            }.getType();
            cartIdList = gson.fromJson(cartIdsJson, listType);
        } catch (Exception ex) {

            request.setAttribute("errorMessage", "Invalid cart data.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
            return;
        }

        if (cartIdList == null || cartIdList.isEmpty()) {
            request.setAttribute("errorMessage", "No valid items selected for purchase.");
            request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
            return;
        }

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
            request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
            return;
        }

        Voucher voucher = null;
        VoucherDAO voucherDAO = new VoucherDAO();
        if (voucherCode != null && !voucherCode.trim().isEmpty()) {
            voucher = voucherDAO.findByCode(voucherCode.trim());
        }

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

        if ((customer.getPhone() == null || customer.getPhone().trim().isEmpty())
                && selectedAddress != null && selectedAddress.getPhone() != null) {
            customer.setPhone(selectedAddress.getPhone());
        }

        List<Integer> productCategoryIds = new ArrayList<>();
        for (Cart cart : selectedItems) {
            int catId = cart.getProduct().getCategory().getId();
            if (!productCategoryIds.contains(catId)) {
                productCategoryIds.add(catId);
            }
        }

        List<Address> availableAddresses = addressDAO.getAddressesByCustomerId(customerId);
        List<Voucher> availableVouchers = voucherDAO.getAvailableVouchersForUserByCategories(customerId, productCategoryIds);

        request.setAttribute("customer", customer);
        request.setAttribute("selectedItems", selectedItems);
        request.setAttribute("voucher", voucher);
        request.setAttribute("availableVouchers", availableVouchers);
        request.setAttribute("cartIdsJson", cartIdsJson);
        request.setAttribute("availableAddresses", availableAddresses);
        request.setAttribute("address", selectedAddress);

        request.getRequestDispatcher("/WEB-INF/customers/pages/purchase.jsp").forward(request, response);
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

            return;
        }

        String action = request.getParameter("action");
        CartDAO cartDao = new CartDAO();
        VoucherDAO voucherDao = new VoucherDAO();

        switch (action) {
            case "updateCustomerInfo":

                String newRecipient = request.getParameter("recipientName");
                String newAddressName = request.getParameter("addressName");
                String newPhone = request.getParameter("phone");
                String newDetails = request.getParameter("address");

                Address oldAddr = cartDao.getDefaultAddressByCustomerId(customer.getId());

                if (oldAddr == null) {

                    if (newRecipient == null || newRecipient.trim().isEmpty()
                            || newAddressName == null || newAddressName.trim().isEmpty()
                            || newPhone == null || newPhone.trim().isEmpty()
                            || newDetails == null || newDetails.trim().isEmpty()) {
                        json.put("success", false);
                        json.put("message", "Please fill in your address information completely for the first time.");
                        break;
                    }
                } else {

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

                boolean ok = cartDao.updateCustomerInfo(
                        customer.getId(),
                        newAddressName,
                        newRecipient,
                        newPhone,
                        newDetails
                );

                json.put("success", ok);
                json.put("message", ok
                        ? "Information updated successfully"
                        : "Failed to update information");
                break;

            case "removeVoucher": {

                session.removeAttribute("voucher");

                String cartIdsStr = request.getParameter("cartIds");

                List<Integer> cartIds = new ArrayList<>();

                if (cartIdsStr != null && !cartIdsStr.trim().isEmpty()) {

                    try {

                        Gson gsonCart = new Gson();

                        Type listType = new TypeToken<List<Integer>>() {
                        }.getType();

                        cartIds = gsonCart.fromJson(cartIdsStr, listType);

                    } catch (Exception e) {

                        cartIds = new ArrayList<>();

                    }

                }

                List<Cart> selectedItems = cartDao.getCartItemById(cartIds);

                if (selectedItems == null) {
                    selectedItems = new ArrayList<>();
                }

                double subtotal = 0;

                int totalItems = 0;

                for (Cart cart : selectedItems) {

                    subtotal += cart.getQuantity() * cart.getProduct().getPrice();

                    totalItems += cart.getQuantity();

                }

                double shipping = (subtotal < 500000 && subtotal > 0) ? 40000 : 0;

                double total = subtotal + shipping;

                json.put("success", true);

                json.put("subtotalFormatted", CurrencyFormatter.formatVietNamCurrency(subtotal));

                json.put("totalFormatted", CurrencyFormatter.formatVietNamCurrency(total));

                json.put("totalItems", totalItems);

                json.put("shipping", shipping);

                json.put("shippingFormatted", CurrencyFormatter.formatVietNamCurrency(shipping));

                json.put("discount", 0);

                json.put("discountFormatted", "0");
                out.print(gson.toJson(json));
                out.flush();
                return;

            }

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

                List<Integer> cartIdList = new ArrayList<>();
                if (cartIds != null && !cartIds.trim().isEmpty()) {
                    JSONArray jsonArray = new JSONArray(cartIds);
                    for (int i = 0; i < jsonArray.length(); i++) {
                        cartIdList.add(jsonArray.getInt(i));
                    }
                }

                CartDAO cartDaos = new CartDAO();
                List<Cart> selectedItems = cartDaos.getCartItemById(cartIdList);

                double subtotal = 0;
                for (Cart cart : selectedItems) {
                    subtotal += cart.getQuantity() * cart.getProduct().getPrice();
                }

                double discount = 0;
                if ("percentage".equalsIgnoreCase(v.getType())) {
                    discount = subtotal * (v.getValue() / 100.0);
                    if (v.getMaxValue() > 0 && discount > v.getMaxValue()) {
                        discount = v.getMaxValue();
                    }
                } else {
                    discount = v.getValue();
                }
                double shippingFee = (subtotal >= 500_000) ? 0 : 40_000;
                double total = subtotal - discount + shippingFee;
                if (total < 0) {
                    total = 0;
                }

                HttpSession sess = request.getSession();
                sess.setAttribute("appliedVoucher", v);

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

                String cartIdsParam = request.getParameter("cartIds");

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

                if (voucherParam != null && voucherParam.matches("\\d+")) {
                    voucherId = Integer.valueOf(voucherParam);
                }

                List<Cart> selectedCarts = cartDao.getCartItemById(cartIdse);
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
                    voucherDao.incrementVoucherUsage(voucherId, customer.getId());
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
                double shippingFees = subtotals >= 500_000 ? 0 : 40_000;
                double totals = Math.max(0, subtotals - discounts + shippingFees);

                Models.Order order = new Models.Order();

                order.setTotalAmount(totals);
                order.setShippingFee(shippingFees);

                Customer cust = new Customer();
                cust.setId(customer.getId());
                order.setCustomer(cust);

                if (voucherId != null) {
                    Voucher voucher = new Voucher();
                    voucher.setId(voucherId);
                    order.setVoucher(voucher);
                }

                Address addr = new Address();
                addr.setId(addressId);
                order.setAddress(addr);

                PaymentMethod pm = new PaymentMethod();
                pm.setId(1);
                order.setPaymentMethod(pm);

                PaymentStatus ps = new PaymentStatus();
                ps.setId(1);
                order.setPaymentStatus(ps);

                OrderStatus os = new OrderStatus();
                os.setId(1);
                order.setOrderStatus(os);

                OrderDAO orderDAO = new OrderDAO();
                int orderId = orderDAO.insertOrder(order);

                for (Cart c : selectedCarts) {
                    orderDAO.insertOrderDetail(orderId, c.getProduct().getProductId(), c.getQuantity(), c.getProduct().getPrice());
                    orderDAO.decreaseProductStock(c.getProduct().getProductId(), c.getQuantity());
                }

                json.put("success", true);
                json.put("message", "Order placed successfully!");

            } catch (Exception e) {
                e.printStackTrace();
                json.put("success", false);
                json.put("message", "Error processing order.");
            }
            break;

            case "addAddress":
                String addrName = request.getParameter("addressName");
                String recip = request.getParameter("recipientName");
                String phone = request.getParameter("addressPhone");
                String details = request.getParameter("addressDetails");

                Address a = new Address();
                a.setCustomerId(customer.getId());
                a.setName(addrName);
                a.setRecipientName(recip);
                a.setPhone(phone);
                a.setDetails(details);
                AddressDAO addressDAO = new AddressDAO();
                int newAddressId = 0;
                try {
                    newAddressId = addressDAO.insert(a);
                    System.out.println("debuf insert" + newAddressId);
                } catch (SQLException ex) {
                    Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                if (newAddressId > 0) {
                    json.put("success", true);
                    json.put("message", "Address added successfully");

                    Map<String, Object> addrMap = new HashMap<>();
                    addrMap.put("id", newAddressId);
                    addrMap.put("name", a.getName());
                    addrMap.put("recipient", a.getRecipientName());
                    addrMap.put("phone", a.getPhone());
                    addrMap.put("details", a.getDetails());
                    System.out.println("list create address" + addrMap);
                    json.put("address", addrMap);
                } else {
                    json.put("success", false);
                    json.put("message", "Failed to add address");
                }
                break;

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
                json.put("message", oks ? "Address updated successfully" : "Failed to update");

                if (oks) {
                    Map<String, Object> addrMap = new HashMap<>();
                    addrMap.put("id", aa.getId());
                    addrMap.put("name", aa.getName());
                    addrMap.put("recipient", aa.getRecipientName());
                    addrMap.put("phone", aa.getPhone());
                    addrMap.put("details", aa.getDetails());

                    json.put("address", addrMap);

                }
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

            case "getAddresses":
                List<Address> addresses = addressDao.getAddressesByCustomerId(customer.getId());
                Address selectedAddresss = (Address) session.getAttribute("selectedAddress");
                int selectedAddressId = (selectedAddresss != null) ? selectedAddresss.getId() : 0;
                Map<String, Object> result = new HashMap<>();
                result.put("addresses", addresses);
                result.put("selectedAddressId", selectedAddressId);
                result.put("selectedAddress", selectedAddresss);

                return;

            case "selectAddress":
                 try {
                int addressId = Integer.parseInt(request.getParameter("addressId"));
                AddressDAO addressDAOs = new AddressDAO();

                boolean success = addressDAOs.setDefaultAddress(customer.getId(), addressId);

                if (success) {

                    Address selectedAddress = addressDAOs.getById(addressId);

                    session.setAttribute("selectedAddress", selectedAddress);

                    json.put("success", true);
                    json.put("message", "Shipping address updated.");

                    if (selectedAddress != null) {
                        Map<String, Object> addrMap = new HashMap<>();
                        addrMap.put("id", selectedAddress.getId());
                        addrMap.put("name", selectedAddress.getName());
                        addrMap.put("recipient", selectedAddress.getRecipientName());
                        addrMap.put("phone", selectedAddress.getPhone());
                        addrMap.put("details", selectedAddress.getDetails());
                        json.put("address", addrMap);

                    }

                } else {
                    json.put("success", false);
                    json.put("message", "Unable to update default address.");
                }

            } catch (NumberFormatException e) {
                json.put("success", false);
                json.put("message", "Invalid Address ID.");
            } catch (Exception e) {
                json.put("success", false);
                json.put("message", "Error processing address.");
                Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, e);
            }
            break;

            default:
                json.put("success", false);
                json.put("message", "Invalid action");
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
