<%@page import="Models.Address"%>
<%@page import="java.util.List"%>
<%@page import="Models.Customer"%>
<%
    Customer pro = (Customer) session.getAttribute("customer");
    String avatarUrl = pro.getAvatar();
    if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
        avatarUrl = "/assets/images/no-avatar.png";
    } else if (!avatarUrl.startsWith("http") && !avatarUrl.startsWith("/")) {
        avatarUrl = "/" + avatarUrl;
    }
    List<Address> addressList = (List<Address>) session.getAttribute("addressList");
%>
<style>
    footer.mt-20 {
        margin-top: 0;
    }
</style>

<div class="bg-white/95 backdrop-blur-sm rounded-3xl p-8 shadow-2xl">
    <h1 class="text-3xl font-bold text-gray-800 text-center mb-8">My Profile</h1>

    <form method="post" action="/customer/self" id="customerUpdateForm" enctype="multipart/form-data" class="space-y-6">
        <input type="hidden" name="type" value="update" />

        <!-- Basic Info -->
        <div class="bg-pink-50 border border-pink-200 rounded-xl p-6 space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <%
                    String[][] inputs = {
                        {"Name", "nameEdit", pro.getName()},
                        {"Email", "emailEdit", pro.getEmail()},
                        {"Phone Number", "phoneEdit", pro.getPhone()}
                    };
                    for (String[] input : inputs) {
                %>
                <div class="relative">
                    <label class="block text-sm font-semibold text-gray-700 uppercase tracking-wide mb-2"><%= input[0]%></label>
                    <input type="text" id="<%= input[1]%>" name="<%= input[1]%>" value="<%= input[2]%>"
                           data-original="<%= input[2]%>" readonly
                           class="editable-field w-full px-4 py-3 pr-10 border border-gray-300 rounded-lg bg-gray-50 text-gray-700 focus:outline-none"
                           placeholder="Enter new <%= input[0].toLowerCase()%>...">
                        <p id="<%= input[1].replace("Edit", "Error")%>" class="text-sm text-red-500"></p>
                        <button type="button" onclick="toggleEdit(this, '<%= input[1]%>')"
                                class="absolute top-11 right-3 text-gray-500 hover:text-blue-600 transition">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none"
                                 viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round"
                                      d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5M18.5 2.5a2.121 2.121 0 113 3L12 15l-4 1 1-4 9.5-9.5z"/>
                            </svg>
                        </button>
                </div>
                <% } %>
            </div>
        </div>

        <!-- Address list -->
        <div class="bg-blue-50 border border-blue-200 rounded-xl p-6 space-y-6">
            <label class="block text-sm font-semibold text-gray-700 uppercase tracking-wide">Addresses</label>
            <% if (addressList != null && !addressList.isEmpty()) {
                    int index = 1;
                    for (Address addr : addressList) {
                        int addrId = addr.getId();
            %>
            <div class="relative mb-6 address-item" data-addr-id="<%= addrId%>">
                <input type="hidden" name="addressIdList" value="<%= addrId%>" />
                <label class="block text-xs font-medium text-gray-600 mb-1">
                    Address #<%= index++%>
                    <% if (addr.isIsDefault()) { %>
                    <span class="text-green-600 font-semibold">(Default)</span>
                    <% }%>
                </label>

                <button type="button" onclick="toggleEditAddress(this, '<%= addrId%>')"
                        class="absolute top-1 right-3 text-gray-500 hover:text-blue-600 transition">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none"
                         viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round"
                              d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5M18.5 2.5a2.121 2.121 0 113 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                </button>

                <input type="text" name="recipient_<%= addrId%>" id="recipient_<%= addrId%>"
                       value="<%= addr.getRecipientName()%>" data-original="<%= addr.getRecipientName()%>"
                       readonly class="editable-field w-full px-4 py-3 mt-2 border border-gray-300 rounded-lg bg-gray-50 text-gray-700 focus:outline-none"
                       placeholder="Recipient name..." />
                <p id="recipientError_<%= addrId%>" class="text-sm text-red-500"></p>

                <input type="text" name="addressDetails_<%= addrId%>" id="address_<%= addrId%>"
                       value="<%= addr.getDetails()%>" data-original="<%= addr.getDetails()%>"
                       readonly class="editable-field w-full px-4 py-3 mt-2 border border-gray-300 rounded-lg bg-gray-50 text-gray-700 focus:outline-none"
                       placeholder="Address details..." />
                <p id="addressError_<%= addrId%>" class="text-sm text-red-500"></p>

                <input type="text" name="phone_<%= addrId%>" id="phone_<%= addrId%>"
                       value="<%= addr.getPhone()%>" data-original="<%= addr.getPhone()%>"
                       readonly class="editable-field w-full px-4 py-3 mt-2 border border-gray-300 rounded-lg bg-gray-50 text-gray-700 focus:outline-none"
                       placeholder="Phone number..." />
                <p id="phoneError_<%= addrId%>" class="text-sm text-red-500"></p>

                <div class="mt-2 flex items-center space-x-2 text-sm hidden default-radio">
                    <input type="radio" name="defaultAddressId" value="<%= addrId%>" <%= addr.isIsDefault() ? "checked data-original=\"true\"" : "data-original=\"false\"" %> />
                    <span class="<%= addr.isIsDefault() ? "text-green-600 font-semibold" : "text-gray-700"%>">Set as default</span>
                </div>
            </div>
            <% }
            } else { %>
            <p class="text-sm text-red-500">No addresses found.</p>
            <% }%>
        </div>

        <!-- Avatar Upload -->
        <div class="flex flex-col bg-gray-50 border border-gray-200 rounded-xl p-6 space-y-6">
            <label class="block text-sm font-semibold text-gray-700 uppercase tracking-wide">Avatar</label>
            <div class="flex">
                <div class="flex-1 flex flex-col items-center justify-center">
                    <div class="relative inline-block rounded-full border-4 border-white shadow-lg ring-2 ring-blue-200 p-2 bg-gradient-to-tr from-blue-100 to-indigo-100">
                        <img src="<%= avatarUrl%>" alt="Avatar" class="h-40 w-40 object-cover rounded-full" style="aspect-ratio: 1 / 1;" />
                    </div>
                </div>

                <div class="flex items-center px-6">
                    <div class="w-px h-full bg-gradient-to-b from-gray-200 via-gray-500 to-gray-200 rounded-full"></div>
                </div>

                <div class="flex-1 flex flex-col items-center">
                    <img id="avatar-image-preview-tag"
                         class="h-32 w-32 mb-5 object-cover rounded-full border border-gray-200 shadow hidden"
                         alt="Avatar Preview" />
                    <input type="file" id="avatar" name="avatar" accept="image/*" class="hidden" />
                    <label for="avatar" class="upload-zone relative border-2 border-dashed border-blue-300 rounded-2xl p-6 hover:bg-blue-50 transition cursor-pointer block text-center space-y-2">
                        <i data-lucide="upload-cloud" class="w-10 h-10 mx-auto text-blue-400"></i>
                        <p class="text-sm text-blue-600 font-medium">Click to upload or drag & drop</p>
                        <p class="text-xs text-gray-400">JPG, PNG, GIF (max 5MB)</p>
                    </label>
                    <p id="avatarError" class="text-red-500 text-sm mt-1"></p>
                </div>
            </div>
        </div>

        <!-- Save button -->
        <div class="flex justify-end">
            <button type="submit" id="updateCustomerBtn"
                    class="flex items-center gap-2 bg-green-600 text-white py-3 px-6 rounded-xl font-semibold text-lg transition hover:scale-105 hover:shadow-lg">
                Save
            </button>
        </div>
    </form>
</div>
