<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <title>Thông Báo - ShopBanOto</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #0B0C10; }
        ::-webkit-scrollbar-thumb { background: #00F0FF; border-radius: 4px; }
    </style>
</head>
<body class="bg-[#0B0C10] text-white font-sans min-h-screen flex flex-col justify-between">
    <nav class="sticky top-0 z-50 bg-[#0B0C10]/95 backdrop-blur-md border-b border-gray-800 px-8 py-4 flex justify-between items-center shadow-lg">
        <a href="home" class="text-2xl font-black text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055]">SHOPBANOTO</a>
        <div class="space-x-6 text-sm font-semibold flex items-center">
            <a href="home" class="hover:text-[#FF0055] transition">Trang Chủ</a>
            <a href="product" class="hover:text-[#FF0055] transition">Sản Phẩm</a>
            <a href="consulting" class="hover:text-[#FF0055] transition">Tư Vấn</a>
            <a href="cart" class="hover:text-[#FF0055] transition">Giỏ Hàng / Đặt Cọc</a>
            
            <c:if test="${not empty sessionScope.acc && sessionScope.acc.vaiTro eq 'Admin'}">
                <a href="admin?action=consulting" class="text-purple-400 hover:text-[#FF0055] transition font-bold">Xử Lý Tư Vấn / Hủy Cọc</a>
                <a href="admin" class="hover:text-[#FF0055] transition text-yellow-400 font-bold">Quản Lý</a>
            </c:if>
            <c:if test="${not empty sessionScope.acc && sessionScope.acc.vaiTro eq 'Employee'}">
                <a href="employee" class="hover:text-[#FF0055] transition text-cyan-400 font-bold">Xử Lý TV</a>
            </c:if>
            
            <a href="profile" class="hover:text-[#FF0055] transition">Tài Khoản</a>

            <c:choose>
                <c:when test="${not empty sessionScope.acc}">
                    <div class="flex items-center space-x-3 bg-gray-800 px-4 py-2 rounded-xl border border-gray-600 shadow-inner">
                        <span class="text-[#00F0FF] font-bold text-xs">Chào, ${empty sessionScope.acc.hoTen ? sessionScope.acc.tenDangNhap : sessionScope.acc.hoTen}</span>
                        <a href="logout" class="bg-[#FF0055] text-white px-3 py-1 rounded-lg text-xs font-bold hover:opacity-90 transition">Đăng Xuất</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="auth.jsp" class="bg-gradient-to-r from-[#FF0055] to-[#00F0FF] text-white px-4 py-2 rounded-xl text-xs font-bold hover:opacity-90 transition">Đăng Nhập</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <!-- Main Content / Popup Box lớn ở giữa dành cho thao tác XÁC NHẬN quan trọng -->
    <main class="flex-grow flex items-center justify-center px-4 py-12">
        <div class="max-w-md w-full bg-[#111622] border border-gray-800 p-8 rounded-3xl shadow-2xl text-center space-y-6">
            
            <% 
                String msg = (String) request.getAttribute("message");
                String type = (String) request.getAttribute("type");
                if (msg == null) msg = "Thao tác thực hiện thành công!";
                if (type == null) type = "success";
                
                String icon = "🎉";
                String borderColor = "border-emerald-500/50";
                String textColor = "text-emerald-400";
                
                if ("error".equals(type)) {
                    icon = "⚠️";
                    borderColor = "border-red-500/50";
                    textColor = "text-red-400";
                } else if ("pending".equals(type)) {
                    icon = "⏳";
                    borderColor = "border-amber-500/50";
                    textColor = "text-amber-400";
                }
            %>

            <div class="w-16 h-16 mx-auto flex items-center justify-center text-3xl rounded-2xl bg-gray-900 border <%= borderColor %>">
                <%= icon %>
            </div>

            <h2 class="text-2xl font-black text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055] uppercase tracking-wide">
                Xác Nhận Hệ Thống
            </h2>

            <p class="text-gray-200 text-sm font-medium leading-relaxed <%= textColor %>">
                <%= msg %>
            </p>

            <div class="pt-2">
                <a href="${empty redirectUrl ? 'home' : redirectUrl}" class="block w-full bg-gradient-to-r from-[#00F0FF] to-[#FF0055] py-3.5 rounded-xl font-extrabold text-white text-sm hover:opacity-90 transition uppercase tracking-wider">
                    Xác Nhận & Tiếp Tục
                </a>
            </div>

        </div>
    </main>

    <!-- Footer -->
    <footer class="border-t border-gray-800 text-center py-6 text-gray-500 text-sm bg-[#0B0C10]">
        &copy; 2026 ShopBanOto. All Rights Reserved.
    </footer>
</body>
</html>
