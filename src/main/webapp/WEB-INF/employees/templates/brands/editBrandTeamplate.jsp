<%-- 
    Document   : editBrandTeamplate
    Created on : Jul 5, 2025, 1:32:30 AM
    Author     : Modern 15
--%>
<!-- EDIT BRAND MODAL -->
<div id="editBrandModal" class="fixed inset-0 z-50 hidden flex items-center justify-center bg-black bg-opacity-30 transition-all duration-300">
    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md p-0 relative transform scale-95 opacity-0 translate-y-8 transition-all duration-300 flex flex-col">
        <div class="bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-t-2xl px-6 py-4 flex items-center justify-between">
            <h2 class="text-xl font-bold flex items-center gap-2">
                <i data-lucide="edit-3" class="w-7 h-7 text-white"></i> Edit Brand
            </h2>
        </div>
        <form onsubmit="event.preventDefault(); handleUpdateBrand();" class="space-y-5 p-8 pt-6" enctype="multipart/form-data">
            <input type="hidden" id="editBrandId">
            <div>
                <label for="editBrandName" class="block text-sm font-medium text-gray-700 mb-1">Brand Name</label>
                <input type="text" id="editBrandName" placeholder="Enter brand name"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition text-base">
                <span id="editBrandNameError" class="text-red-500 text-sm mt-1 block"></span>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Current Image</label>
                <div id="editBrandCurrentImageWrapper" class="flex items-center"></div>
            </div>
            <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-1">Upload New Image (optional)</label>
                <input type="file" id="editBrandImage" name="image" accept="image/*" class="hidden" onchange="showFileName(this)">
                <label for="editBrandImage"
                       class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition-colors">
                    <span class="text-gray-500 text-sm">Click to upload or drag & drop</span>
                    <span class="text-gray-400 text-xs">PNG, JPG, JPEG, GIF (max 10MB)</span>
                </label>
                <span class="file-name text-xs text-gray-500 ml-3">No file chosen</span>
                <div id="editBrandImagePreview" class="mt-2 flex justify-center"></div>
                <p id="editBrandImageError" class="text-red-500 text-sm mt-1"></p>
            </div>
            <div class="flex justify-end gap-3 pt-2">
                <button type="button" onclick="closeEditModal()"
                        class="px-5 py-2 rounded-lg bg-gray-100 text-gray-700 hover:bg-gray-200 transition font-semibold">Cancel</button>
                <button type="submit"
                        class="flex items-center gap-2 px-5 py-2 rounded-lg bg-gradient-to-r from-blue-600 to-blue-400 text-white hover:from-blue-700 hover:to-blue-500 shadow-lg font-semibold transition-all duration-200">
                    <svg id="loadingIconEdit" class="hidden animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"></path></svg>
                    Update
                </button>
            </div>
        </form>
    </div>
</div>

