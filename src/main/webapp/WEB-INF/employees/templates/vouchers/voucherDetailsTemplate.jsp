<%-- 
    Document   : voucherDetailsTemplate
    Created on : Jun 24, 2025, 5:01:27 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@page import="Models.Category"%>
<%@page import="java.util.List"%>
<%@page import="Models.Voucher"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    Voucher voucher = (Voucher) request.getAttribute("voucher");
    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    String validFromFormatted = voucher.getValidFrom().format(formatter);
    String validToFormatted = voucher.getValidTo().format(formatter);
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>


<div class="w-[600px] mx-auto h-auto flex flex-col bg-white shadow-2xl overflow-hidden rounded-xl">
    <!-- Header -->
    <div class="bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-600 px-6 py-5 flex items-center gap-3">
        <i data-lucide="file-text" class="w-6 h-6 text-white"></i>
        <h1 class="text-xl font-bold text-white">Voucher Details</h1>
    </div>

    <div class="overflow-y-auto px-10 py-10 space-y-6" style="max-height: calc(90vh - 70px)">
        <!-- Voucher Code + Value -->
        <div class="relative mx-auto max-w-[280px] min-h-[80px] bg-indigo-100 border border-dashed border-indigo-600 rounded-xl flex items-center justify-center shadow-md">
            <p class="text-2xl font-mono font-bold tracking-[0.3em] text-indigo-700 uppercase">
                <%= voucher.getCode()%>
            </p>

            <!-- Value -->
            <div class="absolute bottom-0 right-4 translate-y-1/2 bg-yellow-500 text-white font-bold px-3 py-1 rounded-full shadow text-xs">
                - <%= voucher.getType().equals("PERCENTAGE")
                        ? ((int) voucher.getValue()) + "%"
                        : String.format("%,.0f VND", voucher.getValue())%>
            </div>
        </div>

        <!-- Description -->
        <div class="relative bg-yellow-50 border-l-4 border-yellow-400 p-4 rounded-md shadow-sm border-b border-gray-200">
            <p class="text-sm italic text-yellow-800 break-words">
                "<%= voucher.getDescription()%>"
            </p>
        </div>

        <div class="bg-gray-100 border border-gray-200 rounded-xl p-6 space-y-4 shadow-sm">
            <!-- Minimum & Maximum -->
            <div class="space-y-4">
                <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm flex items-center gap-3">
                    <div class="w-10 h-10 bg-blue-100 flex items-center justify-center rounded-lg">
                        <i data-lucide="wallet" class="w-5 h-5 text-blue-600"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Minimum Order</p>
                        <p class="text-base font-semibold text-gray-800">
                            <%= String.format("%,.0f VND", voucher.getMinValue())%>
                        </p>
                    </div>
                </div>

                <% if (voucher.getType().equals("PERCENTAGE")) {%>
                <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm flex items-center gap-3">
                    <div class="w-10 h-10 bg-blue-100 flex items-center justify-center rounded-lg">
                        <i data-lucide="badge-percent" class="w-5 h-5 text-blue-600"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Maximum Discount</p>
                        <p class="text-base font-semibold text-gray-800">
                            <%= String.format("%,.0f VND", voucher.getMaxValue())%>
                        </p>
                    </div>
                </div>
                <% }%>
            </div>

            <!-- Applicable Category -->
            <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm flex items-start gap-3">
                <div class="w-10 h-10 bg-blue-100 flex items-center justify-center rounded-lg">
                    <i data-lucide="tag" class="w-5 h-5 text-blue-600"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-500">Applicable Category</p>
                    <% for (Category cat : categories) {%>
                    <p class="text-base font-semibold text-gray-800 mt-1"><%= cat.getName()%></p>
                    <% }%>
                </div>
            </div>

            <!-- Total Usage Limit -->
            <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm flex items-start gap-3">
                <div class="w-10 h-10 bg-blue-100 flex items-center justify-center rounded-lg">
                    <i data-lucide="users" class="w-5 h-5 text-blue-600"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-500">Total Usage Limit</p>
                    <p class="text-base font-semibold text-gray-800 mt-1">
                        <%= voucher.getTotalUsageLimit() == null ? "Unlimited" : voucher.getTotalUsageLimit()%> use
                    </p>
                </div>
            </div>

            <!-- User Usage Limit -->
            <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm flex items-start gap-3 mt-4">
                <div class="w-10 h-10 bg-blue-100 flex items-center justify-center rounded-lg">
                    <i data-lucide="user-check" class="w-5 h-5 text-blue-600"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-500">User Usage Limit</p>
                    <p class="text-base font-semibold text-gray-800 mt-1">
                        <%= voucher.getUserUsageLimit() == null ? "Unlimited" : voucher.getUserUsageLimit()%> use
                    </p>
                </div>
            </div>

            <!-- Status -->
            <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-<%= voucher.isIsActive() ? "green" : "red"%>-100 flex items-center justify-center rounded-lg">
                        <i data-lucide="<%= voucher.isIsActive() ? "check-circle" : "x-circle"%>" class="w-5 h-5 text-<%= voucher.isIsActive() ? "green" : "red"%>-600"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Status</p>
                        <p class="text-base font-semibold text-<%= voucher.isIsActive() ? "green" : "red"%>-600">
                            <%= voucher.isIsActive() ? "Active" : "Inactive"%>
                        </p>
                    </div>
                </div>
                <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium
                      <%= voucher.isIsActive() ? "bg-green-100 text-green-800" : "bg-red-100 text-red-800"%>">
                    <span class="w-2 h-2 mr-2 rounded-full <%= voucher.isIsActive() ? "bg-green-400" : "bg-red-400"%>"></span>
                    <%= voucher.isIsActive() ? "Active" : "Inactive"%>
                </span>
            </div>

            <!-- Valid Time -->
            <div class="bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm flex items-center gap-3">
                <div class="w-10 h-10 bg-blue-100 flex items-center justify-center rounded-lg">
                    <i data-lucide="calendar" class="w-5 h-5 text-blue-600"></i>
                </div>
                <div>
                    <p class="text-sm text-gray-500">Valid Time</p>
                    <p class="text-base font-semibold text-gray-800">
                        <%= validFromFormatted%> - <%= validToFormatted%>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>



