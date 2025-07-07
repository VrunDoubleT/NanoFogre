<%-- 
    Document   : header
    Created on : Jul 1, 2025, 5:13:10 PM
    Author     : Tran Thanh Van - CE181019
--%>

<!-- Header -->
<header class="w-full z-50 py-4 px-6 lg:px-12 bg-slate-900/90 backdrop-blur-sm fixed top-0 shadow-md">
  <div class="max-w-6xl mx-auto flex items-center justify-between">
    
    <!-- Logo -->
    <a href="#" class="text-white text-2xl font-bold tracking-wide flex items-center space-x-2">
      <svg class="w-6 h-6 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
      </svg>
      <span>Model Universe</span>
    </a>

    <!-- Search Bar -->
<div class="flex-1 px-6 hidden md:block">
  <div class="relative max-w-xl mx-auto">
    <form action="/SearchServlet" method="get" autocomplete="off">
      <input
        type="text"
        name="keyword"
        placeholder="Search models..."
        class="w-full px-4 py-2 rounded-full bg-slate-800 text-white placeholder-blue-200 border border-slate-600 focus:outline-none focus:ring-2 focus:ring-yellow-400"
        value="${param.keyword != null ? param.keyword : ''}"
        autocomplete="off"
      />
      <button type="submit" class="absolute top-1/2 right-3 -translate-y-1/2 text-yellow-400 hover:text-yellow-300">
        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
          <path fill-rule="evenodd" d="M8 4a4 4 0 014 4v.586l2.707 2.707a1 1 0 01-1.414 1.414L10.586 10H10a4 4 0 110-6z" clip-rule="evenodd" />
        </svg>
      </button>
    </form>
  </div>
</div>

    <!-- Login / Register -->
    <div class="flex items-center space-x-4">
      <a href="${pageContext.request.contextPath}/AuthServlet?action=login" class="text-sm text-blue-100 hover:text-white transition font-medium">Login</a>
      <a href="${pageContext.request.contextPath}/AuthServlet?action=register" class="px-4 py-2 bg-gradient-to-r from-yellow-400 to-orange-500 text-white rounded-full text-sm font-semibold shadow hover:scale-105 transition">
        Register
      </a>
    </div>
  </div>
</header>
<script src="/js/search.js"></script>

