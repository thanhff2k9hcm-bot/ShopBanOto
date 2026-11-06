<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Phiếu Tư Vấn & Hủy Cọc - ShopBanOto Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        ::-webkit-scrollbar { width: 8px; height: 8px; }
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
            
            <c:if test="${not empty sessionScope.acc && sessionScope.acc.vaiTro eq 'Admin'}">
                <a href="admin?action=consulting" class="text-purple-400 font-bold border-b-2 border-[#FF0055] pb-1">Xử Lý Hủy Cọc</a>
                <a href="admin" class="text-yellow-400 hover:text-[#FF0055] transition font-bold">Quản Lý</a>
            </c:if>

            <div class="flex items-center space-x-3 bg-gray-800/80 px-4 py-1.5 rounded-xl border border-gray-700">
                <span class="text-[#00F0FF] font-bold text-xs">Chào, ${empty sessionScope.acc.hoTen ? sessionScope.acc.tenDangNhap : sessionScope.acc.hoTen}</span>
                <a href="logout" class="bg-[#FF0055] text-white px-3 py-1 rounded-lg text-xs font-bold hover:opacity-80 transition">Đăng Xuất</a>
            </div>
        </div>
    </nav>

    <!-- Main Admin Content -->
    <main class="max-w-[1400px] mx-auto px-6 py-8 flex-grow w-full space-y-10">
        <div class="border-b border-gray-800 pb-4">
            <h1 class="text-2xl font-black uppercase tracking-wider border-l-4 border-[#FF0055] pl-3">
                QUẢN LÝ PHIẾU TƯ VẤN & HỦY CỌC (ADMIN)
            </h1>
            <p class="text-xs text-gray-400 mt-1 pl-4">
                Quản lý các khoản đặt cọc/hủy cọc và theo dõi tiến độ tư vấn thông thường của nhân viên.
            </p>
        </div>

        <c:set var="masterList" value="${not empty consultingList ? consultingList : phieuList}" />

        <!-- BẢNG 1: KHÁCH HÀNG ĐẶT CỌC & XỬ LÝ HỦY CỌC -->
        <div class="bg-[#111622] border border-gray-800 rounded-2xl p-6 shadow-2xl space-y-4">
            <h2 class="text-lg font-bold text-[#FF0055] flex items-center space-x-2">
                <span>💰 1. DANH SÁCH ĐẶT CỌC & XỬ LÝ HỦY CỌC</span>
            </h2>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse text-xs">
                    <thead>
                        <tr class="bg-gray-900/80 text-gray-400 border-b border-gray-800 uppercase tracking-wider">
                            <th class="p-3">MÃ PTV</th>
                            <th class="p-3">KHÁCH HÀNG</th>
                            <th class="p-3">SỐ ĐIỆN THOẠI</th>
                            <th class="p-3">EMAIL</th>
                            <th class="p-3">DÒNG XE</th>
                            <th class="p-3">TIỀN CỌC (35%)</th>
                            <th class="p-3">NGÀY GỬI</th>
                            <th class="p-3">TRẠNG THÁI</th>
                            <th class="p-3 text-center">THAO TÁC</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-800/60">
                        <c:set var="hasDatCocAdmin" value="false" />
                        <c:forEach var="c" items="${masterList}">
                            <c:set var="tienGocVal" value="${c.tienGoc != null ? c.tienGoc : (c.tienDatCoc != null ? c.tienDatCoc : 0)}" />
                            
                            <c:if test="${tienGocVal > 0 || fn:contains(c.ghiChu, 'Đặt cọc') || fn:contains(c.ghiChu, 'giỏ hàng')}">
                                <c:set var="hasDatCocAdmin" value="true" />
                                <c:set var="st" value="${fn:trim(c.trangThai)}" />
                                <c:set var="isAlreadyCanceled" value="${st eq 'Đã hủy cọc' || st eq 'Hoàn thành' || fn:contains(st, 'Đã hoàn tất')}" />

                                <tr class="hover:bg-gray-800/40 transition">
                                    <td class="p-3 font-bold text-[#00F0FF]">#${not empty c.maTV ? c.maTV : c.maPTV}</td>
                                    <td class="p-3 font-bold text-white">${c.hoTen}</td>
                                    <td class="p-3 text-gray-300">${c.sdt}</td>
                                    <td class="p-3 text-gray-300">${c.email}</td>
                                    <td class="p-3 font-semibold text-white">${c.tenXe}</td>
                                    <td class="p-3 font-bold text-[#FF0055]">
                                        <c:choose>
                                            <c:when test="${tienGocVal > 0}">
                                                <fmt:formatNumber value="${tienGocVal * 0.35}" type="number" groupingUsed="true"/> VNĐ
                                            </c:when>
                                            <c:otherwise>0 VNĐ</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="p-3 text-gray-400">${c.ngayGui}</td>
                                    <td class="p-3 font-bold uppercase text-xs">
                                        <c:choose>
                                            <c:when test="${st eq 'Đã hủy cọc'}">
                                                <span class="text-red-400">${c.trangThai}</span>
                                            </c:when>
                                            <c:when test="${st eq 'Hoàn thành'}">
                                                <span class="text-emerald-400">${c.trangThai}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-amber-400">${empty c.trangThai ? 'Chờ xử lý' : c.trangThai}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="p-3 text-center">
                                        <c:choose>
                                            <c:when test="${st eq 'Khách hủy cọc' || fn:contains(st, 'hủy cọc') && !isAlreadyCanceled}">
                                                <button onclick="openConfirmModal('${not empty c.maTV ? c.maTV : c.maPTV}', '${c.hoTen}', '${c.tenXe}')" 
                                                        class="bg-gradient-to-r from-[#FF0055] to-red-600 hover:opacity-90 text-white text-[11px] font-black px-3 py-1.5 rounded-xl shadow-md transition uppercase">
                                                    Xác Nhận Hủy Cọc
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="bg-gray-800 text-gray-500 border border-gray-700 px-3 py-1 rounded-lg font-bold text-[10px] inline-block uppercase cursor-not-allowed opacity-75">
                                                    Đã Khóa / Xử Lý Xong
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not hasDatCocAdmin}">
                            <tr>
                                <td colspan="9" class="p-6 text-center text-gray-500 italic">
                                    Không có phiếu đặt cọc hoặc yêu cầu hủy cọc nào.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- BẢNG 2: KHÁCH HÀNG TƯ VẤN THÔNG THƯỜNG -->
        <div class="bg-[#111622] border border-gray-800 rounded-2xl p-6 shadow-2xl space-y-4">
            <h2 class="text-lg font-bold text-[#00F0FF] flex items-center space-x-2">
                <span>💬 2. DANH SÁCH TƯ VẤN THÔNG THƯỜNG (THEO DÕI TIẾN ĐỘ)</span>
            </h2>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse text-xs">
                    <thead>
                        <tr class="bg-gray-900/80 text-gray-400 border-b border-gray-800 uppercase tracking-wider">
                            <th class="p-3">MÃ PTV</th>
                            <th class="p-3">KHÁCH HÀNG</th>
                            <th class="p-3">SỐ ĐIỆN THOẠI</th>
                            <th class="p-3">EMAIL</th>
                            <th class="p-3">DÒNG XE / NỘI DUNG</th>
                            <th class="p-3">NGÀY GỬI</th>
                            <th class="p-3">TRẠNG THÁI TIẾN ĐỘ</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-800/60">
                        <c:set var="hasTuVanAdmin" value="false" />
                        <c:forEach var="c" items="${masterList}">
                            <c:set var="tienGocVal" value="${c.tienGoc != null ? c.tienGoc : (c.tienDatCoc != null ? c.tienDatCoc : 0)}" />
                            
                            <c:if test="${tienGocVal <= 0 && !fn:contains(c.ghiChu, 'Đặt cọc') && !fn:contains(c.ghiChu, 'giỏ hàng')}">
                                <c:set var="hasTuVanAdmin" value="true" />
                                <c:set var="st" value="${fn:trim(c.trangThai)}" />
                                <tr class="hover:bg-gray-800/40 transition">
                                    <td class="p-3 font-bold text-[#00F0FF]">#${not empty c.maTV ? c.maTV : c.maPTV}</td>
                                    <td class="p-3 font-bold text-white">${c.hoTen}</td>
                                    <td class="p-3 text-gray-300">${c.sdt}</td>
                                    <td class="p-3 text-gray-300">${c.email}</td>
                                    <td class="p-3 font-semibold text-white">${c.tenXe}</td>
                                    <td class="p-3 text-gray-400">${c.ngayGui}</td>
                                    <td class="p-3 font-bold uppercase text-xs">
                                        <c:choose>
                                            <c:when test="${st eq 'Hoàn thành'}">
                                                <span class="text-emerald-400">${c.trangThai}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-amber-400">${empty c.trangThai ? 'Chờ xử lý' : c.trangThai}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not hasTuVanAdmin}">
                            <tr>
                                <td colspan="7" class="p-6 text-center text-gray-500 italic">
                                    Không có phiếu tư vấn thông thường nào.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- MODAL XÁC NHẬN HỦY CỌC -->
    <div id="confirm-modal" class="fixed inset-0 bg-black/80 backdrop-blur-sm hidden z-50 flex items-center justify-center p-4">
        <div class="bg-[#111622] border border-gray-700 max-w-md w-full rounded-3xl p-6 shadow-2xl text-center space-y-5 transform transition-all scale-95 opacity-0 duration-200" id="modal-box">
            <div class="w-14 h-14 mx-auto flex items-center justify-center text-3xl rounded-2xl bg-red-900/30 border border-red-500/40 text-red-400">
                ⚠️
            </div>

            <h3 class="text-xl font-black text-white uppercase tracking-wider">XÁC NHẬN HỦY CỌC</h3>
            
            <p class="text-xs text-gray-300 leading-relaxed" id="modal-msg">
                Bạn có chắc chắn muốn phê duyệt hủy cọc cho đơn hàng này không?
            </p>

            <form action="admin" method="POST" class="space-y-3 pt-2">
                <input type="hidden" name="action" value="cancelDeposit">
                <input type="hidden" name="maTV" id="modal-maTV" value="">

                <div class="grid grid-cols-2 gap-3">
                    <button type="button" onclick="closeConfirmModal()" class="bg-gray-800 border border-gray-700 text-gray-300 py-3 rounded-xl font-bold text-xs hover:bg-gray-700 transition uppercase">
                        Hủy Bỏ
                    </button>
                    <button type="submit" class="bg-gradient-to-r from-[#FF0055] to-red-600 text-white py-3 rounded-xl font-black text-xs hover:opacity-90 transition uppercase shadow-lg shadow-red-500/20">
                        Xác Nhận Lần 2
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openConfirmModal(maTV, hoTen, tenXe) {
            document.getElementById('modal-maTV').value = maTV;
            document.getElementById('modal-msg').innerHTML = 
                'Xác nhận hoàn tiền cọc cho khách hàng <b class="text-[#00F0FF]">' + hoTen + '</b> với sản phẩm <b class="text-[#FF0055]">' + tenXe + '</b>?<br/><span class="text-gray-400 text-[11px]">Hành động này sẽ cập nhật trạng thái đơn thành "Đã hủy cọc" và lưu vào danh sách.</span>';
            
            const modal = document.getElementById('confirm-modal');
            const box = document.getElementById('modal-box');
            modal.classList.remove('hidden');
            setTimeout(() => {
                box.classList.remove('scale-95', 'opacity-0');
                box.classList.add('scale-100', 'opacity-100');
            }, 10);
        }

        function closeConfirmModal() {
            const modal = document.getElementById('confirm-modal');
            const box = document.getElementById('modal-box');
            box.classList.remove('scale-100', 'opacity-100');
            box.classList.add('scale-95', 'opacity-0');
            setTimeout(() => {
                modal.classList.add('hidden');
            }, 200);
        }
    </script>

    <!-- Footer -->
    <footer class="border-t border-gray-800 text-center py-6 text-gray-500 text-sm mt-8">
        &copy; 2026 ShopBanOto. All Rights Reserved.
    </footer>
</body>
</html>