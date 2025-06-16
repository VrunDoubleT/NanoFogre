<%-- 
    Document   : loading
    Created on : Jun 14, 2025, 3:52:02 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    @keyframes slideInLeft {
        0% {
            transform: translateX(-100%);
            opacity: 0;
        }
        100% {
            transform: translateX(0);
            opacity: 1;
        }
    }

    @keyframes spin {
        0% {
            transform: rotate(0deg);
        }
        100% {
            transform: rotate(360deg);
        }
    }

    .slide-in-left {
        animation: slideInLeft 2s ease-out infinite;
    }

    .spin-animation {
        animation: spin 2s linear infinite;
    }

    .letter-delay-1 {
        animation-delay: 0.15s;
    }
    .letter-delay-2 {
        animation-delay: 0.3s;
    }
    .letter-delay-3 {
        animation-delay: 0.45s;
    }
    .letter-delay-4 {
        animation-delay: 0.60s;
    }
    .letter-delay-5 {
        animation-delay: 0.75s;
    }
    .letter-delay-6 {
        animation-delay: 0.90s;
    }
    .letter-delay-7 {
        animation-delay: 1.05s;
    }
    .letter-delay-8 {
        animation-delay: 1.20s;
    }
    .letter-delay-9 {
        animation-delay: 1.35s;
    }
</style>
<div id="mainLoading" class="bg-gray-900/85 bg-opacity-40 fixed z-[1000] inset-0 hidden items-center justify-center">
    <!-- Loading Container -->
    <div class="relative flex items-center justify-center">
        <!-- Outer Spinning Circle -->
        <div class="spin-animation w-[148px] h-[148px] border-4 border-blue-500 border-t-transparent rounded-full absolute"></div>

        <!-- Text Container -->
        <div class="text-center z-10">
            <div class="text-2xl px-6 w-full font-bold text-white mb-2 overflow-hidden">
                <div>
                    <span class="inline-block slide-in-left an letter-delay-1">N</span>
                    <span class="inline-block slide-in-left letter-delay-2">a</span>
                    <span class="inline-block slide-in-left letter-delay-3">n</span>
                    <span class="inline-block slide-in-left letter-delay-4">o</span>
                </div>
                <div>
                    <span class="inline-block slide-in-left letter-delay-5">F</span>
                    <span class="inline-block slide-in-left letter-delay-6">o</span>
                    <span class="inline-block slide-in-left letter-delay-7">r</span>
                    <span class="inline-block slide-in-left letter-delay-8">g</span>
                    <span class="inline-block slide-in-left letter-delay-9">e</span>
                </div>
            </div>

            <!-- Loading dots -->
            <div class="flex justify-center space-x-1 mt-4">
                <div class="w-2 h-2 bg-blue-500 rounded-full animate-bounce"></div>
                <div class="w-2 h-2 bg-blue-500 rounded-full animate-bounce" style="animation-delay: 0.1s;"></div>
                <div class="w-2 h-2 bg-blue-500 rounded-full animate-bounce" style="animation-delay: 0.2s;"></div>
            </div>
        </div>
    </div>
</div>