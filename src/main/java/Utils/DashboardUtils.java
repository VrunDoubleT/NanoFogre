/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import Models.Revenue;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Modern 15
 */
public class DashboardUtils {

    public static List<Revenue> generateFullDateRange(LocalDate start, LocalDate end) {
        List<Revenue> fullData = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {
            fullData.add(new Revenue(date.format(formatter), BigDecimal.ZERO, 0));
        }
        return fullData;
    }

    public static List<Revenue> generateFullMonthRange(LocalDate start, LocalDate end) {
        List<Revenue> fullData = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM");
        LocalDate date = start.withDayOfMonth(1);
        end = end.withDayOfMonth(1);
        while (!date.isAfter(end)) {
            fullData.add(new Revenue(date.format(formatter), BigDecimal.ZERO, 0));
            date = date.plusMonths(1);
        }
        return fullData;
    }

    public static List<Revenue> generateFullYearRange(LocalDate start, LocalDate end) {
        List<Revenue> fullData = new ArrayList<>();
        for (int year = start.getYear(); year <= end.getYear(); year++) {
            fullData.add(new Revenue(String.valueOf(year), BigDecimal.ZERO, 0));
        }
        return fullData;
    }

    public static void mergeRevenueData(List<Revenue> fullData, List<Revenue> partialData) {
        for (Revenue fullItem : fullData) {
            for (Revenue partialItem : partialData) {
                if (fullItem.getPeriod().equals(partialItem.getPeriod())) {
                    fullItem.setRevenue(partialItem.getRevenue());
                    fullItem.setOrderCount(partialItem.getOrderCount());
                    break;
                }
            }
        }
    }

    public static void convertDateFormat(List<Revenue> data) {
        for (Revenue item : data) {
            item.setOriginalDate(item.getPeriod());
            String[] parts = item.getPeriod().split("-");
            if (parts.length == 3) {
                item.setPeriod(parts[2] + "/" + parts[1]); // dd/MM
            }
        }
    }

    public static void convertMonthFormat(List<Revenue> data) {
        for (Revenue item : data) {
            item.setOriginalDate(item.getPeriod());
            String[] parts = item.getPeriod().split("-");
            if (parts.length == 2) {
                item.setPeriod(parts[1] + "/" + parts[0]); // MM/yyyy
            }
        }
    }

    public static BigDecimal calculateTotalRevenue(List<Revenue> data) {
        BigDecimal total = BigDecimal.ZERO;
        for (Revenue item : data) {
            if (item.getRevenue() != null) {
                total = total.add(item.getRevenue());
            }
        }
        return total;
    }

    public static int calculateTotalOrders(List<Revenue> data) {
        int total = 0;
        for (Revenue item : data) {
            total += item.getOrderCount();
        }
        return total;
    }
}
