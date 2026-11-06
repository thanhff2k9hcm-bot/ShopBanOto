<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:if test="${empty sessionScope.acc || empty sessionScope.acc.tenDangNhap}">
    <c:redirect url="auth.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <title>Trang Cá Nhân & Lịch Sử - ShopBanOto</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #0D0E12; }
        ::-webkit-scrollbar-thumb { background: #00F0FF; border-radius: 4px; }
    </style>
</head>
<body class="bg-[#0D0E12] text-white font-sans min-h-screen flex flex-col justify-between">
    <nav class="sticky top-0 z-50 bg-[#0D0E12]/90 backdrop-blur-md border-b border-gray-800 px-6 py-4 flex justify-between items-center">
        <a href="home" class="text-2xl font-black text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055]">SHOPBANOTO</a>
        <div class="space-x-6 text-sm font-medium flex items-center">
            <a href="home" class="hover:text-[#FF0055] transition">Trang Chủ</a>
            <a href="product" class="hover:text-[#FF0055] transition">Sản Phẩm</a>
            <a href="consulting" class="hover:text-[#FF0055] transition">Tư Vấn</a>
            <a href="cart" class="hover:text-[#FF0055] transition">Giỏ Hàng / Đặt Cọc</a>
            
            <c:if test="${not empty sessionScope.acc && sessionScope.acc.vaiTro eq 'Admin'}">
                <a href="admin?action=consulting" class="text-purple-400 hover:text-[#FF0055] transition font-bold">Xử Lý Tư Vấn / Hủy Cọc</a>
                <a href="admin" class="text-yellow-400 hover:text-[#FF0055] transition font-bold">Quản Lý</a>
            </c:if>
            <c:if test="${not empty sessionScope.acc && sessionScope.acc.vaiTro eq 'Employee'}">
                <a href="employee" class="text-[#00F0FF] hover:text-[#FF0055] transition text-cyan-400 font-bold">Xử Lý TV</a>
            </c:if>
            
            <a href="profile" class="text-[#FF0055] font-bold border-b-2 border-[#FF0055] pb-1">Tài Khoản</a>
            
            <c:choose>
                <c:when test="${not empty sessionScope.acc && not empty sessionScope.acc.tenDangNhap}">
                    <div class="flex items-center space-x-3 bg-gray-800/80 px-4 py-2 rounded-xl border border-gray-700">
                        <span class="text-[#00F0FF] font-bold text-xs">Chào, ${empty sessionScope.acc.hoTen ? sessionScope.acc.tenDangNhap : sessionScope.acc.hoTen}</span>
                        <a href="logout" class="bg-[#FF0055] text-white px-3 py-1 rounded-lg text-xs font-bold hover:opacity-80 transition">Đăng Xuất</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="auth.jsp" class="bg-gradient-to-r from-[#FF0055] to-[#00F0FF] text-white px-4 py-2 rounded-xl text-xs font-bold hover:opacity-90 transition">Đăng Nhập</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <div class="max-w-5xl mx-auto px-6 py-12 space-y-10 flex-grow w-full">
        <h1 class="text-3xl font-extrabold border-l-4 border-[#00F0FF] pl-3 uppercase">Trang Cá Nhân & Lịch Sử</h1>

        <c:if test="${not empty message}">
            <div class="p-4 bg-emerald-500/20 border border-emerald-500 text-emerald-400 rounded-xl text-sm text-center font-bold">
                ${message}
            </div>
        </c:if>
        <c:if test="${not empty errorMsg}">
            <div class="p-4 bg-red-500/20 border border-red-500 text-red-400 rounded-xl text-sm text-center font-bold animate-pulse">
                ⚠️ ${errorMsg}
            </div>
        </c:if>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div class="bg-gray-900 border border-gray-800 p-6 rounded-3xl space-y-4 shadow-xl">
                <h2 class="text-xl font-bold text-[#00F0FF]">Cập Nhật Thông Tin</h2>
                <form action="profile?action=updateInfo" method="POST" class="space-y-4">
                    <div>
                        <label class="block text-xs text-gray-400 mb-1">Họ và tên</label>
                        <input type="text" name="hoTen" value="${sessionScope.acc.hoTen}" placeholder="Họ và tên" required class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF]">
                    </div>
                    <div>
                        <label class="block text-xs text-gray-400 mb-1">Email</label>
                        <input type="email" name="email" value="${sessionScope.acc.email}" placeholder="Email" required class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF]">
                    </div>
                    <div>
                        <label class="block text-xs text-gray-400 mb-1">Số điện thoại</label>
                        <input type="text" name="sdt" value="${sessionScope.acc.sdt}" placeholder="Số điện thoại" required class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF]">
                    </div>
                    <button type="submit" class="w-full bg-[#00F0FF] text-black font-extrabold py-3 rounded-xl hover:bg-[#FF0055] hover:text-white transition uppercase">Lưu Thay Đổi</button>
                </form>
            </div>

            <div class="bg-gray-900 border border-gray-800 p-6 rounded-3xl space-y-4 shadow-xl">
                <h2 class="text-xl font-bold text-[#FF0055]">Đổi Mật Khẩu</h2>
                <form action="profile?action=changePassword" method="POST" class="space-y-4">
                    <div>
                        <label class="block text-xs text-gray-400 mb-1">Mật khẩu hiện tại</label>
                        <input type="password" name="oldPassword" placeholder="Mật khẩu hiện tại" required class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#FF0055]">
                    </div>
                    <div>
                        <label class="block text-xs text-gray-400 mb-1">Mật khẩu mới</label>
                        <input type="password" name="newPassword" placeholder="Mật khẩu mới" required class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#FF0055]">
                    </div>
                    <div>
                        <label class="block text-xs text-gray-400 mb-1">Xác nhận mật khẩu mới</label>
                        <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required class="w-full bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#FF0055]">
                    </div>
                    <button type="submit" class="w-full bg-[#FF0055] text-white font-extrabold py-3 rounded-xl hover:opacity-90 transition uppercase">Cập Nhật Mật Khẩu</button>
                </form>
            </div>
        </div>

        <div class="bg-gray-900 border border-gray-800 p-8 rounded-3xl overflow-x-auto shadow-xl">
            <h2 class="text-xl font-bold mb-6">Lịch Sử Đơn Hàng Của Bạn</h2>
            <table class="w-full text-left border-collapse text-sm">
                <thead>
                    <tr class="border-b border-gray-800 text-gray-400 uppercase text-xs">
                        <th class="py-3 px-2">Mã ĐH</th>
                        <th class="py-3 px-2">Xe Đặt Cọc</th>
                        <th class="py-3 px-2">Tiền Cọc (35%)</th>
                        <th class="py-3 px-2">Trạng Thái</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-800">
                    <c:choose>
                        <c:when test="${not empty orderList}">
                            <c:forEach var="o" items="${orderList}">
                                <tr class="hover:bg-gray-800/50 transition">
                                    <td class="py-3 px-2 font-bold text-[#00F0FF]">#${o.maDH}</td>
                                    <td class="py-3 px-2 text-white font-semibold">${o.tenXe}</td>
                                    <td class="py-3 px-2 text-[#FF0055] font-bold">
                                        <fmt:formatNumber value="${o.tienDatCoc}" type="number" groupingUsed="true"/> VNĐ
                                    </td>
                                    <td class="py-3 px-2">
                                        <span class="px-2.5 py-1 rounded-lg font-bold text-xs inline-block uppercase
                                            <c:choose>
                                                <c:when test="${o.trangThai eq 'Đã xác nhận'}">bg-emerald-500/20 text-emerald-400 border border-emerald-500/40</c:when>
                                                <c:when test="${o.trangThai eq 'Đã hủy đơn' || o.trangThai eq 'Đã hủy cọc'}">bg-red-900/40 text-red-400 border border-red-700/50</c:when>
                                                <c:when test="${o.trangThai eq 'Khách hủy cọc'}">bg-amber-500/20 text-amber-400 border border-amber-500/40</c:when>
                                                <c:otherwise>bg-yellow-500/20 text-yellow-400 border border-yellow-500/40</c:otherwise>
                                            </c:choose>">
                                            ${empty o.trangThai ? 'Chờ xử lý' : o.trangThai}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="4" class="py-8 text-center text-gray-400">
                                    Bạn chưa có lịch sử đơn hàng hoặc giao dịch đặt cọc nào.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <footer class="border-t border-gray-800 text-center py-6 text-gray-500 text-sm">
        &copy; 2026 ShopBanOto. All Rights Reserved.
    </footer>
</body>
</html>
