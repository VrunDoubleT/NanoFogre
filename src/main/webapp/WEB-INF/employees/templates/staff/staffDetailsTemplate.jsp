<%-- 
    Document   : staffDetailsTemplate
    Created on : Jun 16, 2025, 9:54:14 AM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@page import="Models.Employee"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Employee staff = (Employee) request.getAttribute("staff");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String formattedDate = staff.getCreatedAt() != null ? staff.getCreatedAt().format(dtf) : "N/A";
    String formattedDob = staff.getDateOfBirth() != null ? staff.getDateOfBirth().format(dtf) : "N/A";
%>

<div class="bg-gray-100">
    <div class="w-4x1 min-w-[680px] h-[90vh] max-h-full mx-auto flex flex-col bg-white shadow-2xl overflow-hidden">
        <!-- Header -->
        <div class="bg-gradient-to-r from-indigo-500 via-purple-500 to-blue-600 px-6 py-5 flex items-center gap-3">
            <i data-lucide="file-text" class="w-6 h-6 text-white"></i>
            <h1 class="text-2xl font-bold text-white">Staff Details</h1>
        </div>

        <!-- Body -->
        <div class="px-8 flex-1 overflow-y-auto py-8 space-y-6">
            <!-- Avatar -->
            <div class="flex justify-center">
                <div class="relative">
                    <img src="<%= staff.getAvatar() != null && !staff.getAvatar().isEmpty() ? staff.getAvatar() : "/default-avatar.png"%>"
                         class="w-28 h-28 rounded-full object-cover border-4 border-white shadow-lg ring-2 ring-gray-200">
                </div>
            </div>

            <!-- Name -->
            <div class="text-center">
                <h2 class="text-2xl font-semibold text-gray-800 uppercase tracking-wider"><%= staff.getName()%></h2>
            </div>

            <!-- Info Cards -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                <!-- Citizen ID -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-yellow-100 rounded-lg mr-3">
                        <i data-lucide="id-card" class="text-yellow-600 w-5 h-5"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Citizen ID</p>
                        <p class="font-semibold text-gray-800"><%= staff.getCitizenIdentityId() != null ? staff.getCitizenIdentityId() : "N/A"%></p>
                    </div>
                </div>

                <!-- Email -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-blue-100 rounded-lg mr-3">
                        <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Email</p>
                        <p class="font-semibold text-gray-800"><%= staff.getEmail()%></p>
                    </div>
                </div>

                <!-- Phone Number -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-emerald-100 rounded-lg mr-3">
                        <i data-lucide="phone" class="text-emerald-600 w-5 h-5"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Phone</p>
                        <p class="font-semibold text-gray-800"><%= staff.getPhoneNumber() != null ? staff.getPhoneNumber() : "N/A"%></p>
                    </div>
                </div>

                <!-- Address -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-gray-200 rounded-lg mr-3">
                        <i data-lucide="map-pin" class="text-gray-600 w-5 h-5"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Address</p>
                        <p class="font-semibold text-gray-800"><%= staff.getAddress() != null ? staff.getAddress() : "N/A"%></p>
                    </div>
                </div>

                <!-- Gender -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <c:choose>
                        <c:when test="${staff.gender eq 'Male'}">
                            <div class="w-10 h-10 flex items-center justify-center bg-blue-100 rounded-lg mr-3">
                                <i data-lucide="mars" class="w-5 h-5 text-blue-600"></i>
                            </div>
                        </c:when>
                        <c:when test="${staff.gender eq 'Female'}">
                            <div class="w-10 h-10 flex items-center justify-center bg-pink-100 rounded-lg mr-3">
                                <i data-lucide="venus" class="w-5 h-5 text-pink-600"></i>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="w-10 h-10 flex items-center justify-center bg-red-100 rounded-lg mr-3">
                                <i data-lucide="transgender" class="w-5 h-5 text-red-600"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div>
                        <p class="text-sm text-gray-500">Gender</p>
                        <p class="font-semibold text-gray-800"><%= staff.getGender() != null ? staff.getGender() : "N/A"%></p>
                    </div>
                </div>

                <!-- Date of Birth -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-indigo-100 rounded-lg mr-3">
                        <i data-lucide="calendar-days" class="text-indigo-600 w-5 h-5"></i>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Date of Birth</p>
                        <p class="font-semibold text-gray-800"><%= formattedDob%></p>
                    </div>
                </div>

                <!-- Order Approved -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-purple-100 rounded-lg mr-3">
                        <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Orders Approved</p>
                        <p class="font-semibold text-gray-800">
                            <%= request.getAttribute("orderCount")%> orders
                        </p>
                    </div>
                </div>

                <!-- Created At -->
                <div class="flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm">
                    <div class="w-10 h-10 flex items-center justify-center bg-green-100 rounded-lg mr-3">
                        <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                              d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <div>
                        <p class="text-sm text-gray-500">Created At</p>
                        <p class="font-semibold text-gray-800"><%= formattedDate%></p>
                    </div>
                </div>

                <!-- Status -->
                <div class="md:col-span-2 flex items-center bg-gray-50 border border-gray-200 rounded-lg p-4 shadow-sm justify-between">
                    <div class="flex items-center">
                        <div class="w-10 h-10 flex items-center justify-center bg-<%= staff.isIsBlock() ? "red" : "green"%>-100 rounded-lg mr-3">
                            <svg class="w-5 h-5 text-<%= staff.isIsBlock() ? "red" : "green"%>-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <% if (staff.isIsBlock()) { %>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728L5.636 5.636"/>
                            <% } else { %>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            <% }%>
                            </svg>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Status</p>
                            <p class="font-semibold text-<%= staff.isIsBlock() ? "red" : "green"%>-600">
                                <%= staff.isIsBlock() ? "Blocked" : "Active"%>
                            </p>
                        </div>
                    </div>
                    <span class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium
                          <%= staff.isIsBlock() ? "bg-red-100 text-red-800" : "bg-green-100 text-green-800"%>">
                        <span class="w-2 h-2 mr-2 rounded-full <%= staff.isIsBlock() ? "bg-red-400" : "bg-green-400"%>"></span>
                        <%= staff.isIsBlock() ? "Blocked" : "Active"%>
                    </span>
                </div>
            </div>
        </div>
    </div>
</div>


