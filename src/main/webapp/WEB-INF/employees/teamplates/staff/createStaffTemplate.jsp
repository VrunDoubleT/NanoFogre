 <%-- 
    Document   : createStaffTemplate
    Created on : Jun 15, 2025, 12:19:42 PM
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
    <div class="w-4x1 mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
        <!-- Header Section -->
        <div class="bg-gradient-to-r flex justify-between from-blue-600 to-purple-600 px-8 py-3">
            <h1 class="text-2xl font-bold text-white m-2 ml-0">Create New Staff</h1>
            <div class="flex items-center space-x-4">
                <button id="create-staff-btn" class="px-4 py-2 flex bg-green-500 rounded-lg text-white hover:bg-green-600 transition-all">
                    <i data-lucide="plus"></i>
                    <i class="fas fa-save mr-2"></i>Create
                </button>
            </div>
        </div>

        <!-- Tab Content -->
        <div class="p-8 w-full h-full overflow-y-auto">
            <!-- Details Tab -->
            <div id="details-content" class="tab-content w-full">
                <div id="staffForm">
                    <div class="bg-gray-50 rounded-xl p-6">
                        <h3 class="text-lg font-semibold text-gray-900 mb-4">Basic Information</h3>

                        <div class="space-y-4">
                            <!-- Name -->
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Name</label>
                                <input placeholder="Enter name" type="text" name="name" id="name"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                <span id="nameError" class="text-sm text-red-500 mt-1 block"></span>
                            </div>

                            <!-- Email -->
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                                <input placeholder="Enter email address" type="text" name="email" id="email"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none">
                                <span id="emailError" class="text-sm text-red-500 mt-1 block"></span>
                            </div>

                            <!-- Password -->
                            <div>
                                <label for="password" class="block text-sm font-medium text-gray-700 mb-2">Password</label>
                                <input type="text" id="password" name="password"
                                       class="w-full px-4 py-3 bg-gray-100 border-2 border-gray-200 rounded-lg text-gray-600 cursor-not-allowed"
                                       readonly/>
                                <div id="generatedPassword"
                                     class="hidden mt-3 p-3 bg-slate-50 border border-slate-200 rounded-lg">
                                    <p class="text-sm text-gray-600 mb-1">Generated Password:</p>
                                    <code class="font-mono text-sm font-semibold text-slate-800 break-all"
                                          id="passwordDisplay"></code>
                                </div>
                                <p class="text-sm text-gray-500 mt-1">Password will be automatically created and sent via email</p>
                            </div>

                            <!-- Account Status -->
                            <div>
                                <label for="block" class="block text-sm font-medium text-gray-700 mb-2">Account Status</label>
                                <div class="flex items-center">
                                    <input type="checkbox" name="block" id="block"
                                           class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                                    <label for="block" class="ml-2 text-sm font-medium text-gray-700">Mark as blocked</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


