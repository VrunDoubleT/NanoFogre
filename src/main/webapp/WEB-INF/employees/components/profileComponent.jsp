<%-- 
    Document   : profileTemplate
    Created on : Jul 17, 2025, 10:02:33 PM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@page import="Models.Employee"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="">
    <!-- Header Section -->
    <div class="bg-white px-8 py-6 mb-8 rounded-2xl border border-gray-200 overflow-hidden">
        <h2 class="text-2xl font-bold mb-2">Profile Information</h2>
        <p>Manage your personal information</p>
    </div>

    <div class="bg-white rounded-2xl border border-gray-200 overflow-hidden">
        <form id="staffProfileForm" action="/profile" method="post" enctype="multipart/form-data" class="p-8" data-staff-id="${staff.id}">
            <input type="hidden" name="id" id="id" value="${staff.id}" />

            <!-- Avatar Section -->
            <div class="mb-8 flex flex-col items-center">
                <div class="relative group">
                    <!-- Avatar preview -->
                    <img id="avatar-preview" src="${staff.avatar}" alt="Avatar"
                         class="h-32 w-32 rounded-full object-cover border-4 border-gray-200 shadow-lg transition-transform" />
                </div>
                <!-- File input -->
                <label class="mt-4 cursor-pointer bg-blue-50 hover:bg-blue-100 text-blue-700 font-medium py-2 px-4 rounded-lg border border-blue-200 transition-colors duration-200">
                    <span>Change Avatar</span>
                    <input type="file" id="avatar" name="avatarFile" accept="image/*" class="hidden" />
                </label>
            </div>


            <!-- Form Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Full Name -->
                <div class="md:col-span-2">
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Full Name</label>
                    <div class="relative group">
                        <input type="text" id="nameEdit" name="nameEdit" value="${staff.name}"
                               data-original="${staff.name}" readonly
                               class="editable-field w-full px-4 py-3 pr-10 border border-gray-300 rounded-lg bg-gray-100 text-gray-700 focus:outline-none"
                               placeholder="Enter new name...">
                        <p id="nameError" class="text-sm text-red-500"></p>
                        <button type="button" onclick="toggleEdit(this, 'nameEdit')" 
                                class="absolute top-1/2 right-3 -translate-y-1/2 p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-full transition-all duration-200">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- Email -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Email Address</label>
                    <div class="relative group">
                        <input type="text" value="${staff.email}" readonly
                               class="editable-field w-full px-4 py-3 pr-10 border border-gray-300 rounded-lg bg-gray-100 text-gray-700 focus:outline-none">
                    </div>
                </div>

                <!-- Phone -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Phone Number</label>
                    <div class="relative group">
                        <input type="text" id="phoneEdit" name="phoneEdit" value="${staff.phoneNumber}"
                               data-original="${staff.phoneNumber}" readonly
                               class="editable-field w-full px-4 py-3 pr-10 border border-gray-300 rounded-lg bg-gray-100 text-gray-700 focus:outline-none"
                               placeholder="Enter new phone number...">
                        <p id="phoneError" class="text-sm text-red-500"></p>
                        <button type="button" onclick="toggleEdit(this, 'phoneEdit')" 
                                class="absolute top-1/2 right-3 -translate-y-1/2 p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-full transition-all duration-200">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- Citizen ID -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Citizen ID</label>
                    <div class="relative group">
                        <input type="text" value="${staff.citizenIdentityId}" readonly
                               class="editable-field w-full px-4 py-3 pr-10 border border-gray-300 rounded-lg bg-gray-100 text-gray-700 focus:outline-none">
                    </div>
                </div>

                <!-- Date of Birth -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Date of Birth</label>
                    <div class="relative group">
                        <input type="text" id="dobEdit" name="dobEdit" value="${staff.dateOfBirth}" 
                               data-original="${staff.dateOfBirth}" readonly
                               class="editable-field w-full px-4 py-3 pr-10 border border-gray-300 rounded-lg bg-gray-100 text-gray-700 focus:outline-none">
                        <p id="dobError" class="text-sm text-red-500"></p>
                        <button type="button" onclick="toggleEdit(this, 'dobEdit')" 
                                class="absolute top-1/2 right-3 -translate-y-1/2 p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-full transition-all duration-200">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- Gender -->
                <div>
                    <label for="genderEdit" class="block text-sm font-semibold text-gray-700 mb-2">Gender</label>
                    <div class="relative group">
                        <select id="genderEdit" name="genderEdit"
                                class="appearance-none editable-field w-full px-4 py-3 pr-10 border border-gray-300 rounded-lg bg-gray-100 text-gray-900 focus:outline-none"
                                disabled
                                data-original="${staff.gender}">
                            <option value="Male" ${staff.gender == 'Male' ? 'selected' : ''}>Male</option>
                            <option value="Female" ${staff.gender == 'Female' ? 'selected' : ''}>Female</option>
                            <option value="Other" ${staff.gender == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                        <button type="button" onclick="toggleEdit(this, 'genderEdit')"
                                class="absolute top-1/2 right-3 -translate-y-1/2 p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-full transition-all duration-200">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                  d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                            </svg>
                        </button>
                    </div>
                </div>

                <!-- Address -->
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Address</label>
                    <div class="relative group">
                        <div class="relative group">
                            <input type="text" id="addressEdit" name="addressEdit" value="${staff.address}"
                                   data-original="${staff.address}" readonly
                                   class="editable-field w-full px-4 py-3 pr-10 border border-gray-300 rounded-lg bg-gray-100 text-gray-700 focus:outline-none"
                                   placeholder="Enter new address...">
                            <p id="addressError" class="text-sm text-red-500"></p>
                            <button type="button" onclick="toggleEdit(this, 'addressEdit')" 
                                    class="absolute top-1/2 right-3 -translate-y-1/2 p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-full transition-all duration-200">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="flex justify-end gap-3 mt-8 pt-6 border-t border-gray-200">
                <button type="submit" class="px-6 py-3 cursor-pointer bg-blue-50 hover:bg-blue-100 text-blue-700 font-medium py-3 px-4 rounded-lg border border-blue-200 transition-colors duration-200 flex items-center gap-2">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                    </svg>
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>