<%-- 
    Document   : createCustomerAddress
    Created on : Jul 8, 2025, 11:34:02 AM
    Author     : Duong Tran Ngoc Chau - CE181040
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .tab-button.active {
        color: #2563eb;
        border-color: #2563eb;
    }
    .tab-content.hidden {
        display: none;
    }
</style>

<div class="bg-gray-100">
    <!-- Modal container -->
    <div class="w-4x1 mx-auto h-[90vh] w-[600px] flex flex-col bg-white shadow-2xl overflow-hidden">
        <!-- Header Section -->
        <div class="bg-gradient-to-r flex justify-between from-blue-600 to-purple-600 px-8 py-3">
            <h1 class="text-lg font-bold text-white m-2">New Address</h1>
            <div class="flex items-center space-x-4">
                <button id="create-address-btn" class="px-4 py-2 flex bg-green-500 rounded-lg text-white hover:bg-green-600 transition-all">
                    <i data-lucide="plus"></i>
                    <span class="ml-1">Create</span>
                </button>
            </div>
        </div>

        <!-- Form Content -->
        <div class="p-6 w-full h-full overflow-y-auto">
            <div id="addressForm">
                <div class="bg-gray-50 rounded-xl p-6">

                    <div class="space-y-4">
                        <!-- Address Name -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Address Name</label>
                            <input placeholder="e.g. Home, Office..." type="text" name="addressName" id="addressName"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                            <span id="addressNameError" class="text-sm text-red-500 mt-1 block"></span>
                        </div>

                        <!-- Recipient Name -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Recipient Name</label>
                            <input placeholder="Enter recipient name" type="text" name="recipientName" id="recipientName"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                            <span id="recipientNameError" class="text-sm text-red-500 mt-1 block"></span>
                        </div>

                        <!-- Address Details -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Address Details</label>
                            <input placeholder="e.g. 123 Main Street, District 1" type="text" name="addressDetails" id="addressDetails"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                            <span id="addressDetailsError" class="text-sm text-red-500 mt-1 block"></span>
                        </div>

                        <!-- Phone -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-2">Phone Number</label>
                            <input placeholder="Enter phone number" type="text" name="addressPhone" id="addressPhone"
                                   class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                            <span id="addressPhoneError" class="text-sm text-red-500 mt-1 block"></span>
                        </div>

                        <!-- Default Address -->
                        <div>
                            <label for="isDefault" class="block text-sm font-medium text-gray-700 mb-2">Set as Default</label>
                            <div class="flex items-center">
                                <input type="checkbox" name="isDefault" id="isDefault"
                                       class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                                <label for="isDefault" class="ml-2 text-sm font-medium text-gray-700">Mark this as your default address</label>
                            </div>
                        </div>
                    </div> <!-- end space-y-4 -->
                </div>
            </div>
        </div>
    </div>
</div>

