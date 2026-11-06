<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <title>Giỏ Hàng & Đặt Cọc Xe - ShopBanOto</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #0B0C10; }
        ::-webkit-scrollbar-thumb { background: #00F0FF; border-radius: 4px; }
        .bg-card { background-color: #121620; }
        .bg-input { background-color: #1A202C; }
    </style>
</head>
<body class="bg-[#0B0C10] text-white font-sans min-h-screen flex flex-col justify-between">
    <nav class="sticky top-0 z-50 bg-[#0B0C10]/95 backdrop-blur-md border-b border-gray-800/80 px-8 py-4 flex justify-between items-center shadow-lg">
        <a href="home" class="text-2xl font-black text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055]">SHOPBANOTO</a>
        <div class="space-x-6 text-sm font-semibold flex items-center">
            <a href="home" class="hover:text-[#FF0055] transition">Trang Chủ</a>
            <a href="product" class="hover:text-[#FF0055] transition">Sản Phẩm</a>
            <a href="consulting" class="hover:text-[#FF0055] transition">Tư Vấn</a>
            <a href="cart" class="text-[#00F0FF] font-bold border-b-2 border-[#FF0055] pb-1">Giỏ Hàng / Đặt Cọc</a>
            
            <c:if test="${not empty sessionScope.acc && sessionScope.acc.vaiTro eq 'Admin'}">
                <a href="admin?action=consulting" class="text-purple-400 hover:text-[#FF0055] transition font-bold">Xử Lý Tư Vấn / Hủy Cọc</a>
                <a href="admin" class="text-yellow-400 hover:text-[#FF0055] transition font-bold">Quản Lý</a>
            </c:if>
            <c:if test="${not empty sessionScope.acc && sessionScope.acc.vaiTro eq 'Employee'}">
                <a href="employee" class="text-[#00F0FF] hover:text-[#FF0055] transition font-bold">Xử Lý Tư Vấn</a>
            </c:if>

            <c:choose>
                <c:when test="${not empty sessionScope.acc && not empty sessionScope.acc.tenDangNhap}">
                    <a href="profile" class="hover:text-[#FF0055] transition">Tài Khoản</a>
                    <div class="flex items-center space-x-3 bg-gray-800/80 px-4 py-1.5 rounded-xl border border-gray-700">
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

    <main class="max-w-[1400px] mx-auto px-6 py-8 flex-grow w-full space-y-6">
        <h1 class="text-3xl font-black text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055] uppercase tracking-wider">
            GIỎ HÀNG & ĐẶT CỌC SIÊU XE
        </h1>

        <c:choose>
            <c:when test="${not empty sessionScope.cartList && sessionScope.cartList.size() > 0}">
                <form action="cart" method="POST" class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                    <div class="lg:col-span-7 bg-[#111622] border border-gray-800/90 rounded-2xl p-6 shadow-2xl space-y-6">
                        <h2 class="text-lg font-bold text-[#00F0FF] flex items-center space-x-2 border-b border-gray-800/80 pb-4">
                            <span>🏎️</span> <span>Danh Sách Xe Đã Chọn</span>
                        </h2>

                        <div class="space-y-4">
                            <c:forEach var="item" items="${sessionScope.cartList}">
                                <c:set var="qty" value="${sessionScope.cartQuantities[item.maXe] != null ? sessionScope.cartQuantities[item.maXe] : 1}"/>
                                <div class="flex items-center justify-between border-b border-gray-800/60 pb-5 last:border-0 last:pb-0 gap-4">
                                    <div class="flex items-center space-x-4">
                                        <img src="${item.hinhAnhDaiDien}" alt="${item.tenXe}" class="w-28 h-18 object-cover rounded-xl border border-gray-800">
                                        <div>
                                            <h3 class="font-bold text-base text-white">${item.tenXe}</h3>
                                            <p class="text-xs text-gray-400">Hãng: ${item.hangXe}</p>
                                            <p class="text-sm font-extrabold text-[#00F0FF] mt-1">
                                                <fmt:formatNumber value="${item.gia}" type="number" groupingUsed="true"/> đ
                                            </p>
                                        </div>
                                    </div>
                                    <div class="flex items-center space-x-4">
                                        <div class="flex items-center border border-gray-700/80 rounded-lg overflow-hidden bg-[#1A202C]">
                                            <input type="number" min="1" name="soLuong_${item.maXe}" value="${qty}" data-price="${item.gia}" 
                                                   onchange="updateCartTotal()" class="cart-qty w-14 bg-transparent text-center text-xs font-bold py-1.5 focus:outline-none text-white">
                                        </div>
                                        <a href="cart?action=remove&maXe=${item.maXe}" class="text-red-400 hover:text-red-300 font-bold text-xs bg-red-500/10 px-3 py-1.5 rounded-lg transition border border-red-500/20">Xóa</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="lg:col-span-5 bg-[#111622] border border-gray-800/90 rounded-2xl p-6 shadow-2xl space-y-5 sticky top-24">
                        <h2 class="text-lg font-bold text-[#FF0055] flex items-center space-x-2 border-b border-gray-800/80 pb-3">
                            <span>📝</span> <span>Thông Tin Đặt Cọc</span>
                        </h2>

                        <div class="space-y-4">
                            <div>
                                <label class="block text-xs font-bold text-gray-400 mb-1.5 uppercase">HỌ VÀ TÊN <span class="text-[#FF0055]">*</span></label>
                                <input type="text" name="hoTen" value="${sessionScope.acc != null ? sessionScope.acc.hoTen : ''}" required 
                                       placeholder="Nhập họ và tên..." 
                                       class="w-full bg-[#1A202C] border border-gray-700/80 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-[#00F0FF] text-white">
                            </div>

                            <div>
                                <label class="block text-xs font-bold text-gray-400 mb-1.5 uppercase">SỐ ĐIỆN THOẠI <span class="text-[#FF0055]">*</span></label>
                                <input type="tel" name="sdt" value="${sessionScope.acc != null ? sessionScope.acc.sdt : ''}" required 
                                       placeholder="Nhập số điện thoại..." 
                                       class="w-full bg-[#1A202C] border border-gray-700/80 rounded-xl px-4 py-3 text-sm font-medium focus:outline-none focus:border-[#00F0FF] text-white">
                            </div>
                        </div>

                        <c:if test="${empty sessionScope.acc}">
                            <div class="p-3 bg-[#0B2536] border border-cyan-800/60 rounded-xl text-xs text-[#00F0FF] flex items-center space-x-2 font-medium">
                                <span>💡</span>
                                <span>Đặt cọc với tư cách <strong class="text-white">Khách vãng lai</strong>.</span>
                            </div>
                        </c:if>

                        <div class="border-t border-gray-800/80 pt-4 space-y-3">
                            <div class="flex justify-between text-gray-300 font-medium text-sm">
                                <span>Tổng tiền xe:</span>
                                <span class="text-white font-bold"><span id="totalPriceText">0</span> đ</span>
                            </div>
                            <div class="flex justify-between text-base font-extrabold pt-2 border-t border-gray-800/80">
                                <span class="text-[#00F0FF]">Tiền đặt cọc (35%):</span>
                                <span class="text-[#FF0055] text-lg"><span id="depositPriceText">0</span> đ</span>
                            </div>
                        </div>

                        <button type="submit" class="w-full bg-gradient-to-r from-[#00F0FF] to-[#FF0055] py-3.5 rounded-xl font-extrabold text-white text-sm shadow-lg shadow-[#00F0FF]/20 hover:opacity-90 transition uppercase tracking-wider">
                            XÁC NHẬN ĐẶT CỌC NGAY (35%)
                        </button>
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="bg-[#111622] border border-gray-800/90 rounded-2xl p-12 text-center space-y-6 max-w-xl mx-auto">
                    <div class="text-6xl">🛒</div>
                    <h2 class="text-xl font-bold text-gray-300">Giỏ hàng của bạn đang trống!</h2>
                    <p class="text-gray-500 text-sm">Hãy chọn mẫu xe ưa thích và bấm "ĐẶT CỌC NGAY" để tiến hành giữ xe.</p>
                    <a href="product" class="inline-block bg-[#00F0FF] text-black font-extrabold px-6 py-3 rounded-xl hover:opacity-80 transition text-sm">
                        Xem Danh Sách Xe
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <script>
        function updateCartTotal() {
            let total = 0;
            const qtyInputs = document.querySelectorAll('.cart-qty');
            qtyInputs.forEach(input => {
                let price = parseFloat(input.getAttribute('data-price')) || 0;
                let quantity = parseInt(input.value) || 1;
                if (quantity < 1) quantity = 1;
                total += price * quantity;
            });
            let deposit = total * 0.35;
            document.getElementById('totalPriceText').innerText = total.toLocaleString('vi-VN');
            document.getElementById('depositPriceText').innerText = deposit.toLocaleString('vi-VN');
        }
        window.onload = function() {
            updateCartTotal();
        };
    </script>

    <footer class="border-t border-gray-800 text-center py-6 text-gray-500 text-sm mt-8">
        &copy; 2026 ShopBanOto. All Rights Reserved.
    </footer>
</body>
</html>
