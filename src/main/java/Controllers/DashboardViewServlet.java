package Controllers;

import DAOs.DashboardDAO;
import Models.Dashboard;
import Models.Revenue;
import Models.TopProduct;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardViewServlet extends HttpServlet {

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
                } else {
                    long days = java.time.temporal.ChronoUnit.DAYS.between(dailyStart, dailyEnd) + 1;
                    if (days > 30) {
                        valid = false;
                        errorMsg = "Only allowed to select up to 30 days.";
                    }
                }
            } else {
                dailyStart = today.minusDays(29);
                dailyEnd = today;
            }

            if ("monthly".equals(filterType)) {
                monthlyStart = (startMonthParam != null && !startMonthParam.isEmpty())
                        ? LocalDate.parse(startMonthParam + "-01")
                        : today.withDayOfMonth(1).minusMonths(11);
                if (endMonthParam != null && !endMonthParam.isEmpty()) {
                    LocalDate temp = LocalDate.parse(endMonthParam + "-01");
                    monthlyEnd = temp.withDayOfMonth(temp.lengthOfMonth());
                } else {
                    LocalDate temp = today;
                    monthlyEnd = temp.withDayOfMonth(temp.lengthOfMonth());
                }
                if (monthlyStart.isAfter(monthlyEnd)) {
                    valid = false;
                    errorMsg = "The start month must be before or equal to the end month.";
                }
            } else {
                monthlyStart = today.withDayOfMonth(1).minusMonths(11);
                LocalDate temp = today;
                monthlyEnd = temp.withDayOfMonth(temp.lengthOfMonth());
            }

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

        List<Revenue> revenueDaily, revenueMonthly, revenueYearly;
        if (!valid) {
            filterType = "daily";
            revenueDaily = dashboardDAO.getRevenueData("daily", dailyStart.toString(), dailyEnd.toString());
            revenueMonthly = dashboardDAO.getRevenueData("monthly", monthlyStart.toString(), monthlyEnd.toString());
            revenueYearly = dashboardDAO.getRevenueData("yearly", yearlyStart.toString(), yearlyEnd.toString());
        } else {
            revenueDaily = dashboardDAO.getRevenueData("daily", dailyStart.toString(), dailyEnd.toString());
            revenueMonthly = dashboardDAO.getRevenueData("monthly", monthlyStart.toString(), monthlyEnd.toString());
            revenueYearly = dashboardDAO.getRevenueData("yearly", yearlyStart.toString(), yearlyEnd.toString());
        }
        if (revenueDaily == null) {
            revenueDaily = new ArrayList<>();
        }
        if (revenueMonthly == null) {
            revenueMonthly = new ArrayList<>();
        }
        if (revenueYearly == null) {
            revenueYearly = new ArrayList<>();
        }

        List<Revenue> fullRevenueDaily = generateFullDateRange(dailyStart, dailyEnd);
        mergeRevenueData(fullRevenueDaily, revenueDaily);
        convertDateFormat(fullRevenueDaily);

        List<Revenue> fullRevenueMonthly = generateFullMonthRange(monthlyStart, monthlyEnd);
        mergeRevenueData(fullRevenueMonthly, revenueMonthly);
        convertMonthFormat(fullRevenueMonthly);

        List<Revenue> fullRevenueYearly = generateFullYearRange(yearlyStart, yearlyEnd);
        mergeRevenueData(fullRevenueYearly, revenueYearly);

        List<TopProduct> topProducts = dashboardDAO.getTopProducts(dailyStart.toString(), dailyEnd.toString(), 10);
        BigDecimal totalRevenue = calculateTotalRevenue(fullRevenueDaily);
        int totalOrders = calculateTotalOrders(fullRevenueDaily);

        int totalCustomers = dashboardDAO.countCustomers();
        int totalStaff = dashboardDAO.countStaff();

        Dashboard dashboardData = new Dashboard(fullRevenueDaily, topProducts, totalRevenue, totalOrders);

        request.setAttribute("dashboardData", dashboardData);
        request.setAttribute("revenueDaily", fullRevenueDaily);
        request.setAttribute("revenueMonthly", fullRevenueMonthly);
        request.setAttribute("revenueYearly", fullRevenueYearly);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalStaff", totalStaff);

        request.setAttribute("filterType", filterType);
        request.setAttribute("startDate", dailyStart.toString());
        request.setAttribute("endDate", dailyEnd.toString());
        request.setAttribute("startMonth", monthlyStart.toString().substring(0, 7));
        request.setAttribute("endMonth", monthlyEnd.toString().substring(0, 7));
        request.setAttribute("startYear", String.valueOf(yearlyStart.getYear()));
        request.setAttribute("endYear", String.valueOf(yearlyEnd.getYear()));
        if (errorMsg != null) {
            request.setAttribute("errorMsg", errorMsg);
        }
        Map<String, Integer> orderStatusData = dashboardDAO.getOrderStatusDistribution(dailyStart, dailyEnd);
        request.setAttribute("orderStatusData", orderStatusData);

        request.getRequestDispatcher("/WEB-INF/employees/components/adminDashboardComponent.jsp")
                .forward(request, response);
    }

    private List<Revenue> generateFullDateRange(LocalDate start, LocalDate end) {
        List<Revenue> fullData = new ArrayList<Revenue>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {
            String dateStr = date.format(formatter);
            fullData.add(new Revenue(dateStr, BigDecimal.ZERO, 0));
        }
        return fullData;
    }

    private void convertDateFormat(List<Revenue> data) {
        for (Revenue item : data) {
            item.setOriginalDate(item.getPeriod());
            String[] parts = item.getPeriod().split("-");
            if (parts.length == 3) {
                item.setPeriod(parts[2] + "/" + parts[1]); // dd/MM
            }
        }
    }

    private List<Revenue> generateFullMonthRange(LocalDate start, LocalDate end) {
        List<Revenue> fullData = new ArrayList<Revenue>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
        LocalDate date = start.withDayOfMonth(1);
        end = end.withDayOfMonth(1);
        while (!date.isAfter(end)) {
            String dateStr = date.format(formatter);
            fullData.add(new Revenue(dateStr, BigDecimal.ZERO, 0));
            date = date.plusMonths(1);
        }
        return fullData;
    }

    private void convertMonthFormat(List<Revenue> data) {
        for (Revenue item : data) {
            item.setOriginalDate(item.getPeriod());
            String[] parts = item.getPeriod().split("-");
            if (parts.length == 2) {
                item.setPeriod(parts[1] + "/" + parts[0]); // MM/yyyy
            }
        }
    }

    private List<Revenue> generateFullYearRange(LocalDate start, LocalDate end) {
        List<Revenue> fullData = new ArrayList<Revenue>();
        int startYear = start.getYear();
        int endYear = end.getYear();
        for (int year = startYear; year <= endYear; year++) {
            fullData.add(new Revenue(String.valueOf(year), BigDecimal.ZERO, 0));
        }
        return fullData;
    }

    private void mergeRevenueData(List<Revenue> fullData, List<Revenue> partialData) {
        for (int i = 0; i < fullData.size(); i++) {
            Revenue fullItem = fullData.get(i);
            for (int j = 0; j < partialData.size(); j++) {
                Revenue partialItem = partialData.get(j);
                if (fullItem.getPeriod().equals(partialItem.getPeriod())) {
                    fullItem.setRevenue(partialItem.getRevenue());
                    fullItem.setOrderCount(partialItem.getOrderCount());
                    break;
                }
            }
        }
    }

    private BigDecimal calculateTotalRevenue(List<Revenue> data) {
        BigDecimal total = BigDecimal.ZERO;
        for (Revenue item : data) {
            if (item.getRevenue() != null) {
                total = total.add(item.getRevenue());
            }
        }
        return total;
    }

    private int calculateTotalOrders(List<Revenue> data) {
        int total = 0;
        for (Revenue item : data) {
            total += item.getOrderCount();
        }
        return total;
    }
}
