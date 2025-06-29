<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type="application/json" id="revenueDailyScript">
    [
    <c:forEach items="${revenueDaily}" var="data" varStatus="loop">
        {"period": "${data.period}", "revenue": ${data.revenue != null ? data.revenue.intValue() : 0}}
        <c:if test="${!loop.last}">,</c:if>
    </c:forEach>
    ]
</script>
<script type="application/json" id="revenueMonthlyScript">
    [
    <c:forEach items="${revenueMonthly}" var="data" varStatus="loop">
        {"period": "${data.period}", "revenue": ${data.revenue != null ? data.revenue.intValue() : 0}}
        <c:if test="${!loop.last}">,</c:if>
    </c:forEach>
    ]
</script>
<script type="application/json" id="revenueYearlyScript">
    [
    <c:forEach items="${revenueYearly}" var="data" varStatus="loop">
        {"period": "${data.period}", "revenue": ${data.revenue != null ? data.revenue.intValue() : 0}}
        <c:if test="${!loop.last}">,</c:if>
    </c:forEach>
    ]
</script>
<script type="application/json" id="orderStatusDataScript">
    {
    <c:forEach items="${orderStatusData}" var="entry" varStatus="loop">
        "${entry.key}": ${entry.value}
        <c:if test="${!loop.last}">,</c:if>
    </c:forEach>
    }
</script>
<input type="hidden" id="filterTypeValue" value="${filterType}" />

<div class="dashboard-content px-4 py-8 bg-gradient-to-b from-gray-100 via-white to-gray-50 min-h-screen">
    <c:if test="${not empty errorMsg}">
        <div class="mb-8 p-4 bg-red-50 border border-red-300 text-red-700 rounded-xl font-semibold shadow"> ${errorMsg} </div>
    </c:if>

    <!-- Overview Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-6 mb-8">
        <!-- Total Revenue -->
        <div class="bg-white rounded-2xl shadow-xl hover:shadow-2xl transition p-6 border border-gray-100 flex items-center gap-4">
            <div class="p-3 rounded-full bg-green-100 flex items-center justify-center">
                <!-- Lucide icon: Banknote -->
                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <rect x="2" y="6" width="20" height="12" rx="2" stroke="currentColor" stroke-width="2"/>
                    <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="2"/>
                </svg>
            </div>
            <div>
                <div class="text-sm text-gray-500">Total Revenue</div>
                <div class="text-2xl font-extrabold text-gray-900">
                    <fmt:formatNumber value="${dashboardData.totalRevenue}" type="currency" currencyCode="VND"/>
                </div>
            </div>
        </div>
        <!-- Total Orders -->
        <div class="bg-white rounded-2xl shadow-xl hover:shadow-2xl transition p-6 border border-gray-100 flex items-center gap-4">
            <div class="p-3 rounded-full bg-blue-100 flex items-center justify-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <rect x="3" y="6" width="18" height="12" rx="2" stroke="currentColor" stroke-width="2"/>
                    <path d="M6 10h12M6 14h12" stroke="currentColor" stroke-width="2" />
                </svg>
            </div>
            <div>
                <div class="text-sm text-gray-500">Total Orders</div>
                <div class="text-2xl font-extrabold text-gray-900">${dashboardData.totalOrders}</div>
            </div>
        </div>
        <!-- Total Customers -->
        <div class="bg-white rounded-2xl shadow-xl hover:shadow-2xl transition p-6 border border-gray-100 flex items-center gap-4">
            <div class="p-3 rounded-full bg-yellow-100 flex items-center justify-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-yellow-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <circle cx="12" cy="10" r="4" stroke="currentColor" stroke-width="2"/>
                    <path d="M6 18c0-2.5 2-4 6-4s6 1.5 6 4" stroke="currentColor" stroke-width="2"/>
                </svg>
            </div>
            <div>
                <div class="text-sm text-gray-500">Total Customers</div>
                <div class="text-2xl font-extrabold text-gray-900">${totalCustomers}</div>
            </div>
        </div>
        <!-- Total Staff -->
        <div class="bg-white rounded-2xl shadow-xl hover:shadow-2xl transition p-6 border border-gray-100 flex items-center gap-4">
            <div class="p-3 rounded-full bg-purple-100 flex items-center justify-center">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-purple-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <circle cx="12" cy="10" r="4" stroke="currentColor" stroke-width="2"/>
                    <path d="M6 18c0-2.5 2-4 6-4s6 1.5 6 4" stroke="currentColor" stroke-width="2"/>
                </svg>
            </div>
            <div>
                <div class="text-sm text-gray-500">Total Staff</div>
                <div class="text-2xl font-extrabold text-gray-900">${totalStaff}</div>
            </div>
        </div>
    </div>

    <!-- Chart Area -->
    <div class="grid grid-cols-1 lg:grid-cols-10 gap-8 mb-8">
        <!-- Revenue Chart -->
        <div class="bg-white rounded-2xl shadow-lg p-8 col-span-7 flex flex-col">
            <div class="flex items-center justify-between mb-4">
                <h2 class="text-xl font-bold text-gray-900 tracking-tight">Revenue Chart</h2>
                <div class="flex gap-2">
                    <button id="btn-daily" class="chart-tab-btn bg-indigo-500 text-white border-indigo-500 shadow px-5 py-2 rounded-lg font-semibold border-2">Last 30 days</button>
                    <button id="btn-monthly" class="chart-tab-btn bg-gray-100 text-gray-800 border border-gray-300 px-5 py-2 rounded-lg font-semibold">Monthly</button>
                    <button id="btn-yearly" class="chart-tab-btn bg-gray-100 text-gray-800 border border-gray-300 px-5 py-2 rounded-lg font-semibold">Yearly</button>
                </div>
            </div>
            <!-- Filter Forms -->
            <form id="filter-form-daily" class="filter-form flex gap-2 items-end mb-2 bg-gray-50 rounded-lg p-4 shadow-sm" method="get" action="dashboard">
                <input type="hidden" name="filterType" value="daily">
                    <label>
                        <span class="text-xs text-gray-600">From date</span>
                        <input type="date" name="startDate" value="${startDate}" class="border rounded-lg px-3 py-1">
                    </label>
                    <label>
                        <span class="text-xs text-gray-600">To date</span>
                        <input type="date" name="endDate" value="${endDate}" class="border rounded-lg px-3 py-1">
                    </label>
                    <button type="button" class="filter-submit-btn bg-indigo-500 text-white px-4 py-2 rounded-lg shadow hover:scale-105 transition disabled:bg-gray-200 disabled:text-gray-400 disabled:border-gray-200">
                        Filter
                    </button>
            </form>
            <form id="filter-form-monthly" class="filter-form flex gap-2 items-end mb-2 bg-gray-50 rounded-lg p-4 shadow-sm hidden" method="get" action="dashboard">
                <input type="hidden" name="filterType" value="monthly">
                    <label>
                        <span class="text-xs text-gray-600">From month</span>
                        <input type="month" name="startMonth" value="${startMonth}" class="border rounded-lg px-3 py-1">
                    </label>
                    <label>
                        <span class="text-xs text-gray-600">To month</span>
                        <input type="month" name="endMonth" value="${endMonth}" class="border rounded-lg px-3 py-1">
                    </label>
                    <button type="button" class="filter-submit-btn bg-indigo-500 text-white px-4 py-2 rounded-lg shadow hover:scale-105 transition disabled:bg-gray-200 disabled:text-gray-400 disabled:border-gray-200">
                        Filter
                    </button>
            </form>
            <form id="filter-form-yearly" class="filter-form flex gap-2 items-end mb-2 bg-gray-50 rounded-lg p-4 shadow-sm hidden" method="get" action="dashboard">
                <input type="hidden" name="filterType" value="yearly">
                    <label>
                        <span class="text-xs text-gray-600">From year</span>
                        <input type="number" name="startYear" min="2000" max="2100" value="${startYear}" class="border rounded-lg px-3 py-1 w-24">
                    </label>
                    <label>
                        <span class="text-xs text-gray-600">To year</span>
                        <input type="number" name="endYear" min="2000" max="2100" value="${endYear}" class="border rounded-lg px-3 py-1 w-24">
                    </label>
                    <button type="button" class="filter-submit-btn bg-indigo-500 text-white px-4 py-2 rounded-lg shadow hover:scale-105 transition disabled:bg-gray-200 disabled:text-gray-400 disabled:border-gray-200">
                        Filter
                    </button>
            </form>
            <div class="h-[320px] flex-grow">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>
        <!-- Pie Chart -->
        <div class="bg-white rounded-2xl shadow-lg p-8 col-span-3 flex flex-col items-center">
            <h2 class="text-xl font-bold text-gray-900 tracking-tight mb-4">Order Status Distribution</h2>
            <canvas id="statusPieChart" width="320" height="320"></canvas>
        </div>
    </div>

    <!-- Top Products -->
    <div class="bg-white rounded-2xl shadow-lg p-8 mt-4">
        <h2 class="text-lg font-bold text-gray-900 mb-6">Top 10 Best-Selling Products</h2>
        <div class="overflow-x-auto rounded-xl border border-gray-100">
            <table class="min-w-full bg-white text-sm">
                <thead class="bg-gray-50 font-bold text-gray-700">
                    <tr>
                        <th class="px-6 py-3 text-left">#</th>
                        <th class="px-6 py-3 text-left">Product</th>
                        <th class="px-6 py-3 text-left">Sold</th>
                        <th class="px-6 py-3 text-left">Revenue</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${dashboardData.topProducts}" var="product" varStatus="loop">
                        <tr class="hover:bg-gray-50 transition">
                            <td class="px-6 py-4 font-bold">${loop.index + 1}</td>
                            <td class="px-6 py-4">
                                <div class="font-semibold text-gray-800">${product.productTitle}</div>
                                <div class="text-xs text-gray-400">ID: ${product.productId}</div>
                            </td>
                            <td class="px-6 py-4">
                                <span class="bg-green-100 text-green-700 rounded px-2 py-1">${product.totalSold} sold</span>
                            </td>
                            <td class="px-6 py-4 font-semibold text-gray-900">
                                <fmt:formatNumber value="${product.totalRevenue}" type="currency" currencyCode="VND"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
