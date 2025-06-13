function loadBrandContentAndEvent(page = 1, category = 'all') {
    document.getElementById('brandContainer').innerHTML = '';
    document.getElementById('loadingBrand').innerHTML = `
        <div class="flex justify-center items-center py-8">
            <svg class="animate-spin h-8 w-8 text-blue-600" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path>
            </svg>
            <span class="ml-2 text-blue-600 font-medium">Loading brands...</span>
        </div>
    `;

    let url = `/admin/view?viewPage=brand&page=${page}&category=${encodeURIComponent(category)}`;

    fetch(url)
        .then(res => res.text())
        .then(html => {
            document.getElementById('loadingBrand').innerHTML = '';
            document.getElementById('brandContainer').innerHTML = html;
            lucide.createIcons();
            setBrandActionEvents();
        })
        .catch(error => console.error('Error loading brands:', error));
}


function filterByCategory(category) {
    loadBrandContentAndEvent(1, category); 
}

function setBrandActionEvents() {
    document.querySelectorAll('[onclick^="editBrand"]').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            const brandId = this.dataset.brandId;
            handleEditBrand(brandId);
        });
    });

    document.querySelectorAll('[onclick^="deleteBrand"]').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            const brandId = this.dataset.brandId;
            confirmDeleteBrand(brandId);
        });
    });
}

document.addEventListener('DOMContentLoaded', () => {
    const categoryFilter = document.getElementById('brandCategoryFilter');
    if (categoryFilter) {
        categoryFilter.addEventListener('change', function() {
            loadBrandContentAndEvent(1, this.value);
        });
    }
});

function handleEditBrand(brandId) {
    console.log('Editing brand ID:', brandId);
}

function confirmDeleteBrand(brandId) {
    if (confirm('Are you sure you want to delete this brand?')) {
        console.log('Deleting brand ID:', brandId);
    }
}
