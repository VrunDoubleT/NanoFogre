<%-- 
    Document   : customer
    Created on : Jun 6, 2025, 4:32:52 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="">
    <div class="bg-white w-full rounded-xl shadow-sm border border-gray-100">
        <div class="flex items-center justify-between p-6">  
            <div class="flex items-center gap-3">
                <div class="h-10 w-10 bg-blue-100 rounded-lg flex items-center justify-center">
                    <i data-lucide="users" class="w-6 h-6 text-blue-600"></i>
                </div>
                <div>
                    <h2 class="text-[20px] font-semibold text-gray-800">Customer List</h2>
                </div>
            </div>
        </div>

        <div class="w-full">
            <table class="w-full max-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">#</th>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Information</th>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Active</th>
                        <th class="px-10 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider text-center">Actions</th>
                    </tr>
                </thead>
                <tbody id="tabelContainer" class="bg-white divide-y divide-gray-200">

                </tbody>
            </table>
            <div id="loadingCustomer"></div>
        </div>
    </div>
</div>     
</div>
<div id="pagination"></div>
