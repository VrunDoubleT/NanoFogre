package Controllers;

import DAOs.DashboardDAO;
import Models.Dashboard;
import Models.Revenue;
import Models.TopProduct;
import Utils.DashboardUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filterType = request.getParameter("filterType");
        if (filterType == null || filterType.isEmpty()) {
            filterType = "daily";
        }

        // Lấy các tham số filter
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");
        String startMonthParam = request.getParameter("startMonth");
        String endMonthParam = request.getParameter("endMonth");
        String startYearParam = request.getParameter("startYear");
        String endYearParam = request.getParameter("endYear");

        LocalDate today = LocalDate.now();

        LocalDate dailyStart, dailyEnd, monthlyStart, monthlyEnd, yearlyStart, yearlyEnd;
        int startYear, endYear;
        boolean valid = true;
        String errorMsg = null;

        try {
            // DAILY
            if ("daily".equals(filterType)) {
                dailyStart = (startDateParam != null && !startDateParam.isEmpty())
                        ? LocalDate.parse(startDateParam)
                        : today.minusDays(29);
                dailyEnd = (endDateParam != null && !endDateParam.isEmpty())
                        ? LocalDate.parse(endDateParam)
                        : today;
                if (dailyStart.isAfter(dailyEnd)) {
                    valid = false;
                    errorMsg = "Start date must be before or equal to end date.";
                } else if (java.time.temporal.ChronoUnit.DAYS.between(dailyStart, dailyEnd) + 1 > 30) {
                    valid = false;
                    errorMsg = "Only allowed to select up to 30 days.";
                }
            } else {
                dailyStart = today.minusDays(29);
                dailyEnd = today;
            }

            // MONTHLY
            if ("monthly".equals(filterType)) {
                monthlyStart = (startMonthParam != null && !startMonthParam.isEmpty())
                        ? LocalDate.parse(startMonthParam + "-01")
                        : today.withDayOfMonth(1).minusMonths(11);
                LocalDate temp = (endMonthParam != null && !endMonthParam.isEmpty())
                        ? LocalDate.parse(endMonthParam + "-01")
                        : today;
                monthlyEnd = temp.withDayOfMonth(temp.lengthOfMonth());
                if (monthlyStart.isAfter(monthlyEnd)) {
                    valid = false;
                    errorMsg = "The start month must be before or equal to the end month.";
                }
            } else {
                monthlyStart = today.withDayOfMonth(1).minusMonths(11);
                LocalDate temp = today;
                monthlyEnd = temp.withDayOfMonth(temp.lengthOfMonth());
            }

            // YEARLY
            if ("yearly".equals(filterType)) {
                startYear = (startYearParam != null && !startYearParam.isEmpty())
                        ? Integer.parseInt(startYearParam)
                        : today.getYear() - 4;
                endYear = (endYearParam != null && !endYearParam.isEmpty())
                        ? Integer.parseInt(endYearParam)
                        : today.getYear();
                if (startYear > endYear) {
                    valid = false;
                    errorMsg = "Start year must be less than or equal to end year.";
                } else if (startYear < 2000 || endYear > 2100) {
                    valid = false;
                    errorMsg = "Years are only allowed between 2000 and 2100.";
                }
                yearlyStart = LocalDate.of(startYear, 1, 1);
                yearlyEnd = LocalDate.of(endYear, 12, 31);
            } else {
                startYear = today.getYear() - 4;
                endYear = today.getYear();
                yearlyStart = LocalDate.of(startYear, 1, 1);
                yearlyEnd = LocalDate.of(endYear, 12, 31);
            }

        } catch (Exception e) {
            valid = false;
            errorMsg = "Invalid filter data.";
            dailyStart = today.minusDays(29);
            dailyEnd = today;
            monthlyStart = today.withDayOfMonth(1).minusMonths(11);
            LocalDate temp = today;
            monthlyEnd = temp.withDayOfMonth(temp.lengthOfMonth());
            startYear = today.getYear() - 4;
            endYear = today.getYear();
            yearlyStart = LocalDate.of(startYear, 1, 1);
            yearlyEnd = LocalDate.of(endYear, 12, 31);
        }

        // Truy xuất dữ liệu từ DB
        List<Revenue> revenueDaily = dashboardDAO.getRevenueData("daily", dailyStart.toString(), dailyEnd.toString());
        List<Revenue> revenueMonthly = dashboardDAO.getRevenueData("monthly", monthlyStart.toString(), monthlyEnd.toString());
        List<Revenue> revenueYearly = dashboardDAO.getRevenueData("yearly", yearlyStart.toString(), yearlyEnd.toString());

        if (revenueDaily == null) revenueDaily = new ArrayList<>();
        if (revenueMonthly == null) revenueMonthly = new ArrayList<>();
        if (revenueYearly == null) revenueYearly = new ArrayList<>();

        // Xử lý dữ liệu biểu đồ
        List<Revenue> fullRevenueDaily = DashboardUtils.generateFullDateRange(dailyStart, dailyEnd);
        DashboardUtils.mergeRevenueData(fullRevenueDaily, revenueDaily);
        DashboardUtils.convertDateFormat(fullRevenueDaily);

        List<Revenue> fullRevenueMonthly = DashboardUtils.generateFullMonthRange(monthlyStart, monthlyEnd);
        DashboardUtils.mergeRevenueData(fullRevenueMonthly, revenueMonthly);
        DashboardUtils.convertMonthFormat(fullRevenueMonthly);

        List<Revenue> fullRevenueYearly = DashboardUtils.generateFullYearRange(yearlyStart, yearlyEnd);
        DashboardUtils.mergeRevenueData(fullRevenueYearly, revenueYearly);

        // Dữ liệu tổng quan
        List<TopProduct> topProducts = dashboardDAO.getTopProducts(dailyStart.toString(), dailyEnd.toString(), 10);
        BigDecimal totalRevenue = DashboardUtils.calculateTotalRevenue(fullRevenueDaily);
        int totalOrders = DashboardUtils.calculateTotalOrders(fullRevenueDaily);
        int totalCustomers = dashboardDAO.countCustomers();
        int totalStaff = dashboardDAO.countStaff();
        Map<String, Integer> orderStatusData = dashboardDAO.getOrderStatusDistribution(dailyStart, dailyEnd);

        Dashboard dashboardData = new Dashboard(fullRevenueDaily, topProducts, totalRevenue, totalOrders);

        // Gửi sang JSP
        request.setAttribute("dashboardData", dashboardData);
        request.setAttribute("revenueDaily", fullRevenueDaily);
        request.setAttribute("revenueMonthly", fullRevenueMonthly);
        request.setAttribute("revenueYearly", fullRevenueYearly);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("orderStatusData", orderStatusData);

        request.setAttribute("filterType", filterType);
        request.setAttribute("startDate", dailyStart.toString());
        request.setAttribute("endDate", dailyEnd.toString());
        request.setAttribute("startMonth", monthlyStart.toString().substring(0, 7));
        request.setAttribute("endMonth", monthlyEnd.toString().substring(0, 7));
        request.setAttribute("startYear", String.valueOf(startYear));
        request.setAttribute("endYear", String.valueOf(endYear));
        if (errorMsg != null) {
            request.setAttribute("errorMsg", errorMsg);
        }

        request.getRequestDispatcher("/WEB-INF/employees/components/adminDashboardComponent.jsp")
                .forward(request, response);
    }
}
