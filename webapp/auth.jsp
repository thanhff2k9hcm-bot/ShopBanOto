<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <title>Đăng Nhập / Đăng Ký - ShopBanOto</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #0B0C10; }
        ::-webkit-scrollbar-thumb { background: #00F0FF; border-radius: 4px; }
    </style>
</head>
<body class="bg-[#0B0C10] text-white font-sans min-h-screen flex flex-col justify-between">

    <!-- Navbar -->
    <nav class="sticky top-0 z-50 bg-[#0B0C10]/95 backdrop-blur-md border-b border-gray-800/80 px-8 py-4 flex justify-between items-center shadow-lg">
        <a href="home" class="text-2xl font-black text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055]">SHOPBANOTO</a>
        <div class="space-x-6 text-sm font-semibold flex items-center">
            <a href="home" class="hover:text-[#FF0055] transition">Trang Chủ</a>
            <a href="product" class="hover:text-[#FF0055] transition">Sản Phẩm</a>
            <a href="consulting" class="hover:text-[#FF0055] transition">Tư Vấn</a>
            <a href="cart" class="hover:text-[#FF0055] transition">Giỏ Hàng / Đặt Cọc</a>
        </div>
    </nav>

    <!-- Main Form Section -->
    <main class="flex-grow flex items-center justify-center px-4 py-12">
        <div class="max-w-md w-full bg-[#111622] border border-gray-800/90 p-8 rounded-3xl shadow-2xl backdrop-blur-md space-y-6">
            
            <!-- Tabs Switcher -->
            <div class="flex border-b border-gray-800 pb-4">
                <button onclick="switchTab('login')" id="loginTabBtn" class="flex-1 pb-2 text-base font-black text-[#00F0FF] border-b-2 border-[#00F0FF] transition uppercase tracking-wider">Đăng Nhập</button>
                <button onclick="switchTab('register')" id="registerTabBtn" class="flex-1 pb-2 text-base font-black text-gray-400 hover:text-white transition uppercase tracking-wider">Đăng Ký</button>
            </div>

            <!-- Thông báo lỗi hoặc thành công -->
            <c:if test="${not empty message}">
                <div class="p-3 bg-emerald-500/20 border border-emerald-500/50 text-emerald-400 rounded-xl text-xs text-center font-bold">
                    ${message}
                </div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="p-3 bg-red-500/20 border border-red-500/50 text-red-400 rounded-xl text-xs text-center font-bold">
                    ⚠️ ${errorMsg}
                </div>
            </c:if>

            <!-- Form Đăng Nhập -->
            <form id="loginForm" action="login" method="POST" class="space-y-4">
                <div>
                    <label class="block text-xs font-bold text-gray-400 mb-1.5 uppercase">Tên Đăng Nhập / Email</label>
                    <input type="text" name="tenDangNhap" required placeholder="Nhập tài khoản..." 
                           class="w-full bg-[#1A202C] border border-gray-700/80 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-[#00F0FF] text-white">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-400 mb-1.5 uppercase">Mật Khẩu</label>
                    <input type="password" name="matKhau" required placeholder="Nhập mật khẩu..." 
                           class="w-full bg-[#1A202C] border border-gray-700/80 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-[#00F0FF] text-white">
                </div>
                <button type="submit" class="w-full bg-gradient-to-r from-[#00F0FF] to-[#FF0055] py-3.5 rounded-xl font-extrabold text-white text-sm shadow-lg shadow-[#00F0FF]/20 hover:opacity-90 transition uppercase tracking-wider mt-2">
                    Đăng Nhập Ngay
                </button>
            </form>

            <!-- Form Đăng Ký (Ẩn mặc định) -->
            <form id="registerForm" action="register" method="POST" class="space-y-4 hidden">
                <div>
                    <label class="block text-xs font-bold text-gray-400 mb-1.5 uppercase">Tên Đăng Nhập</label>
                    <input type="text" name="tenDangNhap" required placeholder="Chọn tên tài khoản..." 
                           class="w-full bg-[#1A202C] border border-gray-700/80 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-[#FF0055] text-white">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-400 mb-1.5 uppercase">Họ và Tên</label>
                    <input type="text" name="hoTen" required placeholder="Nhập họ và tên..." 
                           class="w-full bg-[#1A202C] border border-gray-700/80 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-[#FF0055] text-white">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-400 mb-1.5 uppercase">Số Điện Thoại</label>
                    <input type="tel" name="sdt" required placeholder="Nhập số điện thoại..." 
                           class="w-full bg-[#1A202C] border border-gray-700/80 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-[#FF0055] text-white">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-400 mb-1.5 uppercase">Email</label>
                    <input type="email" name="email" required placeholder="Nhập email của bạn..." 
                           class="w-full bg-[#1A202C] border border-gray-700/80 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-[#FF0055] text-white">
                </div>
                <div>
                    <label class="block text-xs font-bold text-gray-400 mb-1.5 uppercase">Mật Khẩu</label>
                    <input type="password" name="matKhau" required placeholder="Tạo mật khẩu..." 
                           class="w-full bg-[#1A202C] border border-gray-700/80 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-[#FF0055] text-white">
                </div>
                <button type="submit" class="w-full bg-gradient-to-r from-[#FF0055] to-[#00F0FF] py-3.5 rounded-xl font-extrabold text-white text-sm shadow-lg shadow-[#FF0055]/20 hover:opacity-90 transition uppercase tracking-wider mt-2">
                    Đăng Ký Tài Khoản
                </button>
            </form>

        </div>
    </main>

    <!-- Footer -->
    <footer class="border-t border-gray-800 text-center py-6 text-gray-500 text-sm">
        &copy; 2026 ShopBanOto. All Rights Reserved.
    </footer>

    <script>
        function switchTab(tab) {
            const loginForm = document.getElementById('loginForm');
            const registerForm = document.getElementById('registerForm');
            const loginTabBtn = document.getElementById('loginTabBtn');
            const registerTabBtn = document.getElementById('registerTabBtn');

            if (tab === 'login') {
                loginForm.classList.remove('hidden');
                registerForm.classList.add('hidden');
                loginTabBtn.className = "flex-1 pb-2 text-base font-black text-[#00F0FF] border-b-2 border-[#00F0FF] transition uppercase tracking-wider";
                registerTabBtn.className = "flex-1 pb-2 text-base font-black text-gray-400 hover:text-white transition uppercase tracking-wider";
            } else {
                registerForm.classList.remove('hidden');
                loginForm.classList.add('hidden');
                registerTabBtn.className = "flex-1 pb-2 text-base font-black text-[#FF0055] border-b-2 border-[#FF0055] transition uppercase tracking-wider";
                loginTabBtn.className = "flex-1 pb-2 text-base font-black text-gray-400 hover:text-white transition uppercase tracking-wider";
            }
        }
    </script>
</body>
</html>