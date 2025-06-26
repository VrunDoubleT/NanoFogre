const createAndUpdateProductSkeletonLoading = `<div class="bg-gray-100">
    <div class="w-[900px] mx-auto h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
        <!-- Header Skeleton -->
        <div class="bg-gray-200 px-8 py-3 flex justify-between">
            <div class="h-9 w-40 bg-gray-300 rounded animate-pulse"></div>
            <div class="h-10 w-24 bg-gray-300 rounded-lg animate-pulse"></div>
        </div>

        <!-- Content Skeleton -->
        <div class="p-8 h-full w-full overflow-y-auto">
            <div class="space-y-6">
                <!-- Basic Information Skeleton -->
                <div class="bg-gray-50 rounded-xl p-6">
                    <div class="h-6 w-36 bg-gray-300 rounded animate-pulse mb-4"></div>
                    <div class="space-y-4">
                        <!-- Title Field -->
                        <div>
                            <div class="h-4 w-12 bg-gray-300 rounded animate-pulse mb-2"></div>
                            <div class="h-10 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                        </div>
                        <!-- Description Field -->
                        <div>
                            <div class="h-4 w-20 bg-gray-300 rounded animate-pulse mb-2"></div>
                            <div class="h-24 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                        </div>
                        <!-- Material Field -->
                        <div>
                            <div class="h-4 w-16 bg-gray-300 rounded animate-pulse mb-2"></div>
                            <div class="h-10 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                        </div>
                    </div>
                </div>

                <!-- Price and Quantity Skeleton -->
                <div class="bg-gray-50 rounded-xl p-6 border border-gray-200">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <!-- Price Field -->
                        <div>
                            <div class="h-4 w-10 bg-gray-300 rounded animate-pulse mb-2"></div>
                            <div class="h-10 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                        </div>
                        <!-- Quantity Field -->
                        <div>
                            <div class="h-4 w-16 bg-gray-300 rounded animate-pulse mb-2"></div>
                            <div class="h-10 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                        </div>
                    </div>
                </div>

                <!-- Product Images Skeleton -->
                <div class="bg-gray-50 rounded-xl p-6">
                    <div class="h-6 w-32 bg-gray-300 rounded animate-pulse mb-4"></div>
                    <div class="space-y-4">
                        <!-- Upload Zone Skeleton -->
                        <div>
                            <div class="h-4 w-48 bg-gray-300 rounded animate-pulse mb-2"></div>
                            <div class="h-32 w-full bg-gray-300 rounded-lg border-2 border-dashed border-gray-400 animate-pulse"></div>
                        </div>
                        
                        <!-- Info Message Skeleton -->
                        <div class="bg-gray-100 border border-gray-300 rounded-lg p-3">
                            <div class="flex items-center">
                                <div class="h-4 w-4 bg-gray-300 rounded-full animate-pulse mr-2"></div>
                                <div class="h-4 w-64 bg-gray-300 rounded animate-pulse"></div>
                            </div>
                        </div>

                        <!-- Image Grid Skeleton -->
                        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
                            <div class="relative">
                                <div class="h-32 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                                <div class="absolute top-2 right-2 h-5 w-5 bg-gray-400 rounded animate-pulse"></div>
                            </div>
                            <div class="relative">
                                <div class="h-32 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                                <div class="absolute top-2 right-2 h-5 w-5 bg-gray-400 rounded animate-pulse"></div>
                            </div>
                            <div class="relative">
                                <div class="h-32 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                                <div class="absolute top-2 right-2 h-5 w-5 bg-gray-400 rounded animate-pulse"></div>
                            </div>
                            <div class="relative">
                                <div class="h-32 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                                <div class="absolute top-2 right-2 h-5 w-5 bg-gray-400 rounded animate-pulse"></div>
                            </div>
                            <div class="relative">
                                <div class="h-32 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                                <div class="absolute top-2 right-2 h-5 w-5 bg-gray-400 rounded animate-pulse"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Category & Brand Skeleton -->
                <div class="bg-gray-50 rounded-xl p-6 border border-gray-200">
                    <div class="h-6 w-32 bg-gray-300 rounded animate-pulse mb-4"></div>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <!-- Category Field -->
                        <div>
                            <div class="h-4 w-16 bg-gray-300 rounded animate-pulse mb-2"></div>
                            <div class="h-10 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                        </div>
                        <!-- Brand Field -->
                        <div>
                            <div class="h-4 w-12 bg-gray-300 rounded animate-pulse mb-2"></div>
                            <div class="h-10 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                        </div>
                    </div>
                </div>

                <!-- Attribute Section Skeleton -->
                <div class="bg-gray-50 rounded-xl p-6">
                    <div class="h-6 w-28 bg-gray-300 rounded animate-pulse mb-4"></div>
                    <div class="space-y-3">
                        <div class="h-10 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                        <div class="h-10 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                        <div class="h-10 w-full bg-gray-300 rounded-lg animate-pulse"></div>
                    </div>
                </div>

                <!-- Product Status Skeleton -->
                <div class="bg-gray-50 rounded-xl p-6 border border-gray-200">
                    <div class="h-6 w-28 bg-gray-300 rounded animate-pulse mb-4"></div>
                    <div class="flex items-center">
                        <div class="h-4 w-4 bg-gray-300 rounded animate-pulse mr-2"></div>
                        <div class="h-4 w-48 bg-gray-300 rounded animate-pulse"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>`

const productDetailSkeletonLoading = `<div class="w-[1120px] h-[90vh] flex flex-col bg-white shadow-2xl overflow-hidden">
    <div class="">
        <!-- Header Section Skeleton -->
        <div class="bg-gray-300 flex justify-between px-8 py-3">
            <div class="bg-gray-400 animate-pulse h-8 w-24 rounded"></div>
            <div class="flex items-center space-x-4">
                <div class="bg-gray-400 animate-pulse h-6 w-20 rounded-full"></div>
                <div class="bg-gray-400 animate-pulse h-6 w-16 rounded-full"></div>
            </div>
        </div>

        <!-- Tab Navigation Skeleton -->
        <div class="border-b border-gray-200">
            <nav class="flex px-8" aria-label="Tabs">
                <div class="px-6 py-3">
                    <div class="bg-gray-300 animate-pulse h-5 w-28 rounded"></div>
                </div>
                <div class="px-6 py-3">
                    <div class="bg-gray-300 animate-pulse h-5 w-20 rounded"></div>
                </div>
            </nav>
        </div>
    </div>

    <!-- Tab Content Skeleton -->
    <div class="p-8 h-full w-full overflow-y-auto">
        <div class="w-full">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <!-- Product Images Skeleton -->
                <div class="space-y-4">
                    <div class="relative">
                        <div class="bg-gray-300 animate-pulse w-full h-96 rounded-xl"></div>
                        <div class="absolute top-4 right-4">
                            <div class="bg-gray-400 animate-pulse h-6 w-16 rounded-full"></div>
                        </div>
                    </div>
                    <!-- Image Gallery Skeleton -->
                    <div class="flex space-x-3 overflow-x-auto p-2">
                        <div class="bg-gray-300 animate-pulse w-20 h-20 rounded-lg flex-shrink-0"></div>
                        <div class="bg-gray-300 animate-pulse w-20 h-20 rounded-lg flex-shrink-0"></div>
                        <div class="bg-gray-300 animate-pulse w-20 h-20 rounded-lg flex-shrink-0"></div>
                        <div class="bg-gray-300 animate-pulse w-20 h-20 rounded-lg flex-shrink-0"></div>
                    </div>
                    <!-- Description Section Skeleton -->
                    <div class="mt-8 bg-gray-50 rounded-xl p-6">
                        <div class="bg-gray-300 animate-pulse h-6 w-40 rounded mb-4"></div>
                        <div class="space-y-2">
                            <div class="bg-gray-300 animate-pulse h-4 w-full rounded"></div>
                            <div class="bg-gray-300 animate-pulse h-4 w-full rounded"></div>
                            <div class="bg-gray-300 animate-pulse h-4 w-3/4 rounded"></div>
                        </div>
                    </div>
                </div>

                <!-- Product Information Skeleton -->
                <div class="space-y-6">
                    <div class="bg-gray-300 animate-pulse h-8 w-3/4 rounded"></div>
                    
                    <!-- Price Section Skeleton -->
                    <div class="bg-gray-50 p-6 rounded-xl border border-gray-200">
                        <div class="flex items-center justify-between">
                            <div>
                                <div class="bg-gray-300 animate-pulse h-4 w-10 rounded mb-2"></div>
                                <div class="bg-gray-300 animate-pulse h-8 w-24 rounded"></div>
                            </div>
                            <div class="text-right">
                                <div class="bg-gray-300 animate-pulse h-4 w-16 rounded mb-2"></div>
                                <div class="bg-gray-300 animate-pulse h-6 w-12 rounded"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Basic Information Skeleton -->
                    <div class="bg-gray-50 rounded-xl p-6">
                        <div class="bg-gray-300 animate-pulse h-5 w-36 rounded mb-4"></div>
                        <div class="space-y-3">
                            <div class="flex justify-between">
                                <div class="bg-gray-300 animate-pulse h-4 w-16 rounded"></div>
                                <div class="bg-gray-300 animate-pulse h-4 w-20 rounded"></div>
                            </div>
                            <div class="flex justify-between">
                                <div class="bg-gray-300 animate-pulse h-4 w-12 rounded"></div>
                                <div class="bg-gray-300 animate-pulse h-4 w-16 rounded"></div>
                            </div>
                            <div class="flex justify-between">
                                <div class="bg-gray-300 animate-pulse h-4 w-14 rounded"></div>
                                <div class="bg-gray-300 animate-pulse h-4 w-18 rounded"></div>
                            </div>
                            <div class="flex justify-between">
                                <div class="bg-gray-300 animate-pulse h-4 w-12 rounded"></div>
                                <div class="bg-gray-300 animate-pulse h-4 w-14 rounded"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Info Skeleton -->
                    <div class="bg-gray-50 rounded-xl p-6 border border-gray-200">
                        <div class="bg-gray-300 animate-pulse h-5 w-40 rounded mb-3"></div>
                        <div class="space-y-2">
                            <div class="flex justify-between gap-4">
                                <div class="bg-gray-300 animate-pulse h-4 w-20 rounded"></div>
                                <div class="bg-gray-300 animate-pulse h-4 w-24 rounded"></div>
                            </div>
                            <div class="flex justify-between gap-4">
                                <div class="bg-gray-300 animate-pulse h-4 w-16 rounded"></div>
                                <div class="bg-gray-300 animate-pulse h-4 w-18 rounded"></div>
                            </div>
                            <div class="flex justify-between gap-4">
                                <div class="bg-gray-300 animate-pulse h-4 w-22 rounded"></div>
                                <div class="bg-gray-300 animate-pulse h-4 w-20 rounded"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>`
