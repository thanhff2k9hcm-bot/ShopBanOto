<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <title>ShopBanOto - Thế Hệ Tiếp Theo</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #0B0C10; }
        ::-webkit-scrollbar-thumb { background: #00F0FF; border-radius: 4px; }
    </style>
</head>
<body class="bg-[#0B0C10] text-white font-sans min-h-screen flex flex-col justify-between">
    <!-- Navigation Bar -->
    <nav class="sticky top-0 z-50 bg-[#0B0C10]/95 backdrop-blur-md border-b border-gray-800/80 px-8 py-4 flex justify-between items-center shadow-lg">
        <a href="home" class="text-2xl font-black text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055]">SHOPBANOTO</a>
        <div class="space-x-6 text-sm font-semibold flex items-center">
            <a href="home" class="text-[#00F0FF] font-bold border-b-2 border-[#FF0055] pb-1">Trang Chủ</a>
            <a href="product" class="hover:text-[#FF0055] transition">Sản Phẩm</a>
            <a href="consulting" class="hover:text-[#FF0055] transition">Tư Vấn</a>
            <a href="cart" class="hover:text-[#FF0055] transition">Giỏ Hàng / Đặt Cọc</a>
            
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

    <!-- Hero Section -->
    <section class="relative py-20 px-6 text-center space-y-6 max-w-4xl mx-auto">
        <h1 class="text-5xl md:text-6xl font-black tracking-tight text-white uppercase">
            BỨC PHÁ <span class="text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055]">TỐC ĐỘ</span>
        </h1>
        <p class="text-gray-400 text-sm md:text-base max-w-2xl mx-auto">
            Đỉnh cao thiết kế thể thao, công nghệ xe hơi tương lai năng động & mạnh mẽ.
        </p>
        <div class="flex justify-center items-center space-x-4 pt-4">
            <a href="product" class="bg-gradient-to-r from-[#00F0FF] to-[#FF0055] text-white font-bold px-8 py-3 rounded-xl shadow-lg shadow-[#00F0FF]/20 hover:opacity-90 transition text-sm">
                Khám Phá Xe Ngay
            </a>
            <a href="consulting" class="bg-gray-800 border border-gray-700 text-white font-bold px-8 py-3 rounded-xl hover:bg-gray-700 transition text-sm">
                Đăng Ký Tư Vấn
            </a>
        </div>
    </section>

    <!-- Featured Products Section -->
    <main class="max-w-[1400px] mx-auto px-6 py-8 flex-grow w-full space-y-8">
        <div class="flex justify-between items-center border-b border-gray-800 pb-4">
            <h2 class="text-2xl font-black uppercase tracking-wider border-l-4 border-[#FF0055] pl-3">
                DÒNG XE SIÊU CẤP
            </h2>
            <a href="product" class="text-xs font-bold text-[#00F0FF] hover:underline">Xem Tất Cả &rarr;</a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <c:forEach var="p" items="${productList}">
                <div class="bg-[#111622] border border-gray-800/90 rounded-2xl overflow-hidden hover:border-[#00F0FF] transition duration-300 shadow-2xl flex flex-col justify-between group">
                    <div class="h-52 overflow-hidden relative">
                        <img src="${p.hinhAnhDaiDien}" alt="${p.tenXe}" class="w-full h-full object-cover group-hover:scale-105 transition duration-300">
                    </div>
                    <div class="p-6 space-y-4 flex-grow flex flex-col justify-between">
                        <div class="space-y-2">
                            <span class="text-[10px] font-bold bg-[#FF0055]/10 text-[#FF0055] px-2.5 py-1 rounded-md uppercase border border-[#FF0055]/20">${p.hangXe}</span>
                            <h3 class="font-bold text-xl text-white group-hover:text-[#00F0FF] transition">${p.tenXe}</h3>
                        </div>
                        
                        <div class="space-y-3 pt-3 border-t border-gray-800/80">
                            <div class="text-base font-black text-[#FF0055]">
                                <fmt:formatNumber value="${p.gia}" type="number" groupingUsed="true"/> VNĐ
                            </div>
                            <div class="text-xs text-gray-400">
                                Còn lại: <span class="text-white font-bold">${p.soLuongTon} chiếc</span>
                            </div>

                            <!-- Bộ 3 nút bấm đồng bộ: Đặt cọc, Thêm giỏ, Cần tư vấn -->
                            <div class="grid grid-cols-3 gap-1.5">
                                <a href="cart?maXe=${p.maXe}" class="text-center bg-gradient-to-r from-[#00F0FF] to-[#FF0055] text-white font-bold py-2 rounded-xl hover:opacity-90 transition text-[10px] uppercase flex items-center justify-center">
                                    ĐẶT CỌC
                                </a>
                                <a href="cart?action=add&maXe=${p.maXe}" class="text-center bg-gray-800 border border-gray-700 text-white font-bold py-2 rounded-xl hover:bg-gray-700 transition text-[10px] uppercase flex items-center justify-center">
                                    THÊM GIỎ
                                </a>
                                <a href="consulting?maXe=${p.maXe}" class="text-center bg-purple-600/80 border border-purple-500/50 text-white font-bold py-2 rounded-xl hover:bg-purple-600 transition text-[10px] uppercase flex items-center justify-center">
                                    TƯ VẤN
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>

    <!-- Toast Notification -->
    <div id="toast-notification" class="fixed bottom-6 right-6 hidden z-50 flex items-center space-x-3 bg-[#111622]/95 border border-[#00F0FF]/40 text-white px-5 py-4 rounded-2xl shadow-2xl backdrop-blur-md border-l-4 border-l-[#00F0FF] transition-all duration-300 transform translate-y-4 opacity-0">
        <span class="text-xl">🎉</span>
        <div>
            <p class="text-[11px] font-bold text-[#00F0FF] uppercase tracking-wider">Thông Báo</p>
            <p id="toast-message" class="text-xs font-semibold text-gray-200 mt-0.5">Thêm sản phẩm vào giỏ hàng thành công!</p>
        </div>
    </div>

    <script>
        function showToast(message) {
            const toast = document.getElementById('toast-notification');
            const toastMsg = document.getElementById('toast-message');
            if (message) toastMsg.innerText = message;
            
            toast.classList.remove('hidden');
            setTimeout(() => {
                toast.classList.remove('translate-y-4', 'opacity-0');
                toast.classList.add('translate-y-0', 'opacity-100');
            }, 10);
            
            setTimeout(() => {
                toast.classList.remove('translate-y-0', 'opacity-100');
                toast.classList.add('translate-y-4', 'opacity-0');
                setTimeout(() => {
                    toast.classList.add('hidden');
                }, 300);
            }, 5000);
        }

        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('a[href*="action=add"]').forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const url = this.getAttribute('href');
                    fetch(url)
                        .then(res => res.text())
                        .then(data => {
                            showToast(data || "Thêm sản phẩm vào giỏ hàng thành công!");
                        })
                        .catch(err => {
                            showToast("Thêm vào giỏ hàng thành công!");
                        });
                });
            });
        });
    </script>

    <footer class="border-t border-gray-800 text-center py-6 text-gray-500 text-sm mt-8">
        &copy; 2026 ShopBanOto. All Rights Reserved.
    </footer>
</body>
</html>
