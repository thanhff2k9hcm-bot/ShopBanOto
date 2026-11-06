<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <title>Đăng Ký Tư Vấn & Đặt Xe - ShopBanOto</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #0D0E12; }
        ::-webkit-scrollbar-thumb { background: #00F0FF; border-radius: 4px; }
    </style>
</head>
<body class="bg-[#0D0E12] text-white font-sans min-h-screen flex flex-col justify-between">
    <!-- Navbar -->
    <nav class="sticky top-0 z-50 bg-[#0D0E12]/90 backdrop-blur-md border-b border-gray-800 px-6 py-4 flex justify-between items-center">
        <a href="home" class="text-2xl font-black text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055]">SHOPBANOTO</a>
        <div class="space-x-6 text-sm font-medium flex items-center">
            <a href="home" class="hover:text-[#FF0055] transition">Trang Chủ</a>
            <a href="product" class="hover:text-[#FF0055] transition">Sản Phẩm</a>
            <a href="consulting" class="text-[#FF0055] font-bold border-b-2 border-[#FF0055] pb-1">Tư Vấn</a>
            <a href="cart" class="hover:text-[#FF0055] transition">Giỏ Hàng / Đặt Cọc</a>
            
            <c:if test="${not empty sessionScope.acc && sessionScope.acc.vaiTro eq 'Admin'}">
                <a href="admin?action=consulting" class="text-purple-400 hover:text-[#FF0055] transition font-bold">Xử Lý Tư Vấn / Hủy Cọc</a>
                <a href="admin" class="hover:text-[#FF0055] transition text-yellow-400 font-bold">Quản Lý</a>
            </c:if>

            <c:choose>
                <c:when test="${not empty sessionScope.acc && not empty sessionScope.acc.tenDangNhap}">
                    <a href="profile" class="hover:text-[#FF0055] transition">Tài Khoản</a>
                    <div class="flex items-center space-x-3 bg-gray-800/80 px-4 py-2 rounded-xl border border-gray-700">
                        <span class="text-[#00F0FF] font-bold text-xs">Chào, ${empty sessionScope.acc.hoTen ? sessionScope.acc.tenDangNhap : sessionScope.acc.hoTen}</span>
                        <a href="logout" class="bg-[#FF0055] text-white px-3 py-1 rounded-lg text-xs font-bold hover:opacity-80 transition">Đăng Xuất</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="auth.jsp" class="bg-gradient-to-r from-[#FF0055] to-[#00F0FF] text-white font-bold px-4 py-2 rounded-xl text-xs hover:opacity-90 transition">Đăng Nhập / Đăng Ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <!-- Main Content: Form Tư Vấn -->
    <main class="max-w-3xl mx-auto px-6 py-12 flex-grow w-full">
        <div class="bg-gray-900 border border-gray-800 rounded-3xl p-8 shadow-2xl space-y-6">
            <div class="border-b border-gray-800 pb-4">
                <h1 class="text-2xl font-black uppercase text-[#00F0FF] tracking-wider">ĐĂNG KÝ TƯ VẤN & ĐẶT XE Ô TÔ</h1>
                <p class="text-xs text-gray-400 mt-1">Vui lòng điền đầy đủ thông tin bên dưới, nhân viên tư vấn của chúng tôi sẽ liên hệ lại với bạn sớm nhất.</p>
            </div>

            <!-- Hiển thị ảnh sản phẩm nếu có chọn từ danh sách -->
            <c:if test="${not empty selectedProduct}">
                <div class="bg-black/40 border border-gray-800 rounded-2xl p-4 flex items-center space-x-4">
                    <img src="${selectedProduct.hinhAnhDaiDien}" alt="${selectedProduct.tenXe}" class="w-32 h-20 object-cover rounded-xl border border-gray-700 shadow-md">
                    <div>
                        <span class="text-[10px] font-bold bg-[#FF0055]/20 text-[#FF0055] px-2.5 py-1 rounded uppercase border border-[#FF0055]/30">${selectedProduct.hangXe}</span>
                        <h2 class="text-lg font-bold text-white mt-1">${selectedProduct.tenXe}</h2>
                        <p class="text-sm font-black text-[#00F0FF] mt-0.5">
                            <fmt:formatNumber value="${selectedProduct.gia}" type="number" groupingUsed="true"/> VNĐ
                        </p>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="p-4 bg-emerald-500/20 border border-emerald-500 text-emerald-400 rounded-xl text-sm text-center font-bold">
                    ${message}
                </div>
            </c:if>

            <form action="consulting" method="POST" class="space-y-4">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs text-gray-400 mb-1">Họ và tên khách hàng</label>
                        <input type="text" name="hoTen" value="${sessionScope.acc != null ? sessionScope.acc.hoTen : ''}" placeholder="Nhập họ và tên..." required 
                               class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF] text-white">
                    </div>
                    <div>
                        <label class="block text-xs text-gray-400 mb-1">Số điện thoại liên hệ</label>
                        <input type="text" name="sdt" value="${sessionScope.acc != null ? sessionScope.acc.sdt : ''}" placeholder="Nhập số điện thoại..." required 
                               class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF] text-white">
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs text-gray-400 mb-1">Địa chỉ Email</label>
                        <input type="email" name="email" value="${sessionScope.acc != null ? sessionScope.acc.email : ''}" placeholder="Nhập email..." required 
                               class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF] text-white">
                    </div>
                    <div>
                        <label class="block text-xs text-gray-400 mb-1">Dòng xe quan tâm</label>
                        <input type="text" name="tenXe" value="${selectedProduct != null ? selectedProduct.tenXe : param.tenXe}" readonly 
                               class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm text-[#00F0FF] font-bold focus:outline-none cursor-not-allowed">
                    </div>
                </div>

                <div>
                    <label class="block text-xs text-gray-400 mb-1">Nội dung yêu cầu / Ghi chú</label>
                    <textarea name="noiDung" rows="4" placeholder="Nhập yêu cầu tư vấn chi tiết..." 
                              class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF] text-white"></textarea>
                </div>

                <button type="submit" class="w-full bg-gradient-to-r from-[#00F0FF] to-teal-500 text-black font-black py-3.5 rounded-xl hover:opacity-90 transition uppercase shadow-lg">
                    Gửi Yêu Cầu Tư Vấn
                </button>
            </form>
        </div>
    </main>

    <!-- Footer -->
    <footer class="border-t border-gray-800 text-center py-6 text-gray-500 text-sm">
        &copy; 2026 ShopBanOto. All Rights Reserved.
    </footer>
</body>
</html>
