<%-- 
    Document   : paginationTeamplate
    Created on : Jun 8, 2025, 10:37:07 PM
    Author     : Tran Thanh Van - CE181019
--%>


<%-- 
    Document   : paginationTemplate
    Created on : Jun 8, 2025, 10:37:07 PM
    Author     : Tran Thanh Van - CE181019
--%>
<%
    Integer totalAttr = (Integer) request.getAttribute("total");
    Integer limitAttr = (Integer) request.getAttribute("limit");
    Integer pageAttr = (Integer) request.getAttribute("page");

    int total = totalAttr != null ? totalAttr : 0;
    int limit = limitAttr != null ? limitAttr : 10;
    int currentPage = pageAttr != null ? pageAttr : 1;
    int totalPages = (int) Math.ceil((double) total / limit);
    int maxPagesToShow = 5;
    int half = maxPagesToShow / 2;
    int startPage = Math.max(1, currentPage - half);
    int endPage = Math.min(totalPages, currentPage + half);
    if (endPage - startPage + 1 < maxPagesToShow) {
        if (startPage == 1) {
            endPage = Math.min(totalPages, startPage + maxPagesToShow - 1);
        } else if (endPage == totalPages) {
            startPage = Math.max(1, endPage - maxPagesToShow + 1);
        }
    }
%>
<% if (total > 0) {%>
<!-- Modern Pagination Component -->
<div class="flex flex-col items-center space-y-4 mt-8">
    <!-- Pagination Info -->
    <div class="text-sm text-gray-600 font-medium">
        Showing <span id="from" class="font-semibold text-gray-900"><%= Math.min((currentPage - 1) * limit + 1, total)%></span> 
        to <span id="end" class="font-semibold text-gray-900"><%= Math.min(currentPage * limit, total)%></span> 
        of <span id="total" class="font-semibold text-gray-900"><%= total%></span> results
    </div>

    <!-- Pagination Navigation -->
    <nav class="isolate inline-flex -space-x-px rounded-xl shadow-lg bg-white ring-1 ring-gray-200" aria-label="Pagination">
        <!-- First Button -->
        <div page="1" 
             class="pagination relative inline-flex items-center px-3 py-2 rounded-l-xl text-sm font-medium
             <%= currentPage == 1 ? "text-gray-400 cursor-not-allowed bg-gray-50"
                   : "text-gray-700 bg-white cursor-pointer hover:bg-gray-50 hover:text-gray-900 active:bg-gray-100"%>
             transition-all duration-200 ease-in-out group"
             <%= currentPage == 1 ? "aria-disabled='true'" : ""%>>
            <svg class="h-4 w-4 group-hover:scale-110 transition-transform duration-200" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M18.75 19.5l-7.5-7.5 7.5-7.5m-6 15L5.25 12l6-6" />
            </svg>
            <span class="sr-only">First page</span>
        </div>

        <!-- Previous Button -->
        <div page="<%= Math.max(1, currentPage - 1)%>" 
             class="pagination relative inline-flex items-center px-3 py-2 text-sm font-medium
             <%= currentPage == 1 ? "text-gray-400 cursor-not-allowed bg-gray-50"
                   : "text-gray-700 bg-white cursor-pointer hover:bg-gray-50 hover:text-gray-900 active:bg-gray-100"%>
             transition-all duration-200 ease-in-out group"
             <%= currentPage == 1 ? "aria-disabled='true'" : ""%>>
            <svg class="h-4 w-4 group-hover:scale-110 transition-transform duration-200" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
            </svg>
            <span class="sr-only">Previous page</span>
        </div>

        <!-- Ellipsis (Start) -->
        <% if (startPage > 1) { %>
        <span class="relative inline-flex items-center px-3 py-2 text-sm font-medium text-gray-400 bg-white">
            <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
            <path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z"/>
            </svg>
        </span>
        <% } %>

        <!-- Page Numbers -->
        <% for (int i = startPage; i <= endPage; i++) {%>
        <div page="<%= i%>" 
             class="pagination cursor-pointer relative inline-flex items-center px-4 py-2 text-sm font-semibold
             <%= i == currentPage
                     ? "z-10 bg-gradient-to-r from-blue-600 to-indigo-600 text-white shadow-lg ring-2 ring-blue-500 ring-offset-2 transform scale-105"
                     : "text-gray-700 bg-white hover:bg-gradient-to-r hover:from-gray-50 hover:to-gray-100 hover:text-gray-900 hover:shadow-md hover:scale-105"%>
             transition-all duration-200 ease-in-out"
             aria-current="<%= i == currentPage ? "page" : "false"%>">
            <%= i%>
        </div>
        <% } %>

        <!-- Ellipsis (End) -->
        <% if (endPage < totalPages) { %>
        <span class="relative inline-flex items-center px-3 py-2 text-sm font-medium text-gray-400 bg-white">
            <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
            <path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z"/>
            </svg>
        </span>
        <% }%>

        <!-- Next Button -->
        <div page="<%= Math.min(totalPages, currentPage + 1)%>" 
             class="pagination relative inline-flex items-center px-3 py-2 text-sm font-medium
             <%= currentPage == totalPages ? "text-gray-400 cursor-not-allowed bg-gray-50"
                   : "text-gray-700 bg-white hover:bg-gray-50 cursor-pointer hover:text-gray-900 active:bg-gray-100"%>
             transition-all duration-200 ease-in-out group"
             <%= currentPage == totalPages ? "aria-disabled='true'" : ""%>>
            <svg class="h-4 w-4 group-hover:scale-110 transition-transform duration-200" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
            <span class="sr-only">Next page</span>
        </div>

        <!-- Last Button -->
        <div page="<%= totalPages%>" 
             class="pagination relative inline-flex items-center px-3 py-2 rounded-r-xl text-sm font-medium
             <%= currentPage == totalPages ? "text-gray-400 cursor-not-allowed bg-gray-50"
                   : "text-gray-700 bg-white cursor-pointer hover:bg-gray-50 hover:text-gray-900 active:bg-gray-100"%>
             transition-all duration-200 ease-in-out group"
             <%= currentPage == totalPages ? "aria-disabled='true'" : ""%>>
            <svg class="h-4 w-4 group-hover:scale-110 transition-transform duration-200" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M5.25 4.5l7.5 7.5-7.5 7.5m6-15l7.5 7.5-7.5 7.5" />
            </svg>
            <span class="sr-only">Last page</span>
        </div>
    </nav>

    <!-- Mobile Pagination (Hidden on desktop) -->
    <div class="flex items-center justify-between w-full max-w-xs sm:hidden">
        <div page="<%= Math.max(1, currentPage - 1)%>" 
             class="pagination relative inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
             <%= currentPage == 1 ? "style='pointer-events: none; opacity: 0.5;'" : ""%>>
            Previous
        </div>

        <span class="text-sm text-gray-700 font-medium">
            Page <%= currentPage%> of <%= totalPages%>
        </span>

        <div page="<%= Math.min(totalPages, currentPage + 1)%>" 
             class="pagination relative inline-flex items-center px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
             <%= currentPage == totalPages ? "style='pointer-events: none; opacity: 0.5;'" : ""%>>
            Next
        </div>
    </div>
</div>
<% }%>