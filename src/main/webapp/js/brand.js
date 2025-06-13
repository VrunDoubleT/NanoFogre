function loadBrandContentAndEvent(page = 1, category = 'all', search = '') {
    // Clear previous brand list content
    document.getElementById('brandContainer').innerHTML = '';
    // Show loading spinner
    document.getElementById('loadingBrand').innerHTML = `
        <div class="flex justify-center items-center py-8">
            <svg class="animate-spin h-8 w-8 text-blue-600" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path>
            </svg>
            <span class="ml-2 text-blue-600 font-medium">Loading brands...</span>
        </div>
    `;
    let url = `/admin/view?viewPage=brand&page=${page}`;
    if (category && category !== 'all') url += `&category=${encodeURIComponent(category)}`;

    // Fetch the brand list from the server
    fetch(url)
        .then(res => res.text())
        .then(html => {
            // Remove loading spinner
            document.getElementById('loadingBrand').innerHTML = '';
            // Render the brand list HTML
            document.getElementById('brandContainer').innerHTML = html;
            // Render Lucide icons
            lucide.createIcons();
            // Attach event listeners for action buttons
            setBrandActionEvents();
        });
}

function filterByCategory(category) {
    const search = document.getElementById('brandSearchInput') ? document.getElementById('brandSearchInput').value : '';
    loadBrandContentAndEvent(1, category, search);
}


// Gắn sự kiện cho các nút action
function setBrandActionEvents() {
    document.querySelectorAll('[onclick^="editBrand"]').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.stopPropagation();
        });
    });
    document.querySelectorAll('[onclick^="deleteBrand"]').forEach(btn => {
        btn.addEventListener('click', function (e) {
            e.stopPropagation();
        });
    });
}

window.addEventListener('DOMContentLoaded', function () {
    const categoryFilter = document.getElementById('brandCategoryFilter');
    if (categoryFilter) {
        categoryFilter.addEventListener('change', function () {
            filterByCategory(this.value);
        });
    }
});


