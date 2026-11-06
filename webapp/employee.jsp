<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <title>Trang Nhân Viên Tư Vấn - ShopBanOto</title>
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
        <a href="home" class="text-2xl font-black text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055]">EMPLOYEE PANEL</a>
        <div class="space-x-6 text-sm font-semibold flex items-center">
            <a href="home" class="hover:text-[#FF0055] transition">Trang Chủ</a>
            <a href="product" class="hover:text-[#FF0055] transition">Sản Phẩm</a>
            <a href="consulting" class="hover:text-[#FF0055] transition">Tư Vấn</a>
            <a href="employee" class="text-[#00F0FF] font-bold border-b-2 border-[#FF0055] pb-1">Xử Lý Tư Vấn</a>
            <a href="profile" class="hover:text-[#FF0055] transition">Tài Khoản</a>

            <div class="flex items-center space-x-3 bg-gray-800/80 px-4 py-1.5 rounded-xl border border-gray-700">
                <span class="text-[#00F0FF] font-bold text-xs">Chào NV, ${empty sessionScope.acc.hoTen ? sessionScope.acc.tenDangNhap : sessionScope.acc.hoTen}</span>
                <a href="logout" class="bg-[#FF0055] text-white px-3 py-1 rounded-lg text-xs font-bold hover:opacity-80 transition">Đăng Xuất</a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="max-w-[1400px] mx-auto px-6 py-8 flex-grow w-full space-y-10">
        <div class="border-b border-gray-800 pb-4">
            <h1 class="text-2xl font-black uppercase tracking-wider border-l-4 border-[#FF0055] pl-3">
                QUẢN LÝ PHIẾU TƯ VẤN & ĐẶT CỌC KHÁCH HÀNG
            </h1>
            <p class="text-xs text-gray-400 mt-1 pl-4">
                Phân tách chi tiết giữa danh sách khách hàng đặt cọc xe và khách hàng tư vấn thông thường.
            </p>
        </div>

        <c:set var="masterList" value="${not empty phieuList ? phieuList : consultingList}" />

        <!-- BẢNG 1: KHÁCH HÀNG ĐẶT CỌC -->
        <div class="bg-[#111622] border border-gray-800 rounded-2xl p-6 shadow-2xl space-y-4">
            <h2 class="text-lg font-bold text-[#FF0055] flex items-center space-x-2">
                <span>💰 1. DANH SÁCH KHÁCH HÀNG ĐẶT CỌC XE</span>
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
                            <th class="p-3 text-center">HÀNH ĐỘNG</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-800/60">
                        <c:set var="hasDatCoc" value="false" />
                        <c:forEach var="c" items="${masterList}">
                            <c:set var="tienGocVal" value="${c.tienGoc != null ? c.tienGoc : (c.tienDatCoc != null ? c.tienDatCoc : 0)}" />
                            
                            <c:if test="${tienGocVal > 0 || fn:contains(c.ghiChu, 'Đặt cọc') || fn:contains(c.ghiChu, 'giỏ hàng')}">
                                <c:set var="hasDatCoc" value="true" />
                                <c:set var="st" value="${fn:trim(c.trangThai)}" />
                                <c:set var="isLocked" value="${st eq 'Khách hủy cọc' || st eq 'Đã hủy cọc' || st eq 'Chờ hủy cọc' || st eq 'Hoàn thành' || fn:contains(st, 'hủy cọc')}" />

                                <tr class="hover:bg-gray-800/40 transition">
                                    <td class="p-3 font-bold text-[#00F0FF]">#${not empty c.maPTV ? c.maPTV : c.maTV}</td>
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
                                            <c:when test="${st eq 'Hoàn thành' || st eq 'Đã hủy cọc'}">
                                                <span class="text-emerald-400">${empty c.trangThai ? 'Chờ xử lý' : c.trangThai}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-amber-400">${empty c.trangThai ? 'Chờ xử lý' : c.trangThai}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="p-3 text-center">
                                        <form action="employee" method="POST" class="flex items-center justify-center space-x-2">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="maPTV" value="${not empty c.maPTV ? c.maPTV : c.maTV}">

                                            <c:choose>
                                                <c:when test="${isLocked}">
                                                    <select disabled class="bg-gray-800 text-gray-500 border border-gray-700 rounded-lg px-2 py-1 text-xs cursor-not-allowed">
                                                        <option selected>${st eq 'Hoàn thành' ? 'Đã hoàn thành' : 'Đã khóa xử lý'}</option>
                                                    </select>
                                                    <button type="button" disabled class="bg-gray-700 text-gray-500 px-3 py-1 rounded-lg font-bold text-xs cursor-not-allowed border border-gray-600 opacity-60">
                                                        Đã khóa
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <select name="trangThai" class="bg-gray-900 text-white border border-gray-700 rounded-lg px-2 py-1 text-xs focus:outline-none focus:border-[#00F0FF]">
                                                        <option value="Chờ xử lý" ${st eq 'Chờ xử lý' ? 'selected' : ''}>Chờ xử lý</option>
                                                        <option value="Đã tư vấn" ${st eq 'Đã tư vấn' ? 'selected' : ''}>Đã tư vấn</option>
                                                        <option value="Khách hủy cọc" ${st eq 'Khách hủy cọc' ? 'selected' : ''}>Gửi hủy cọc (Admin duyệt)</option>
                                                        <option value="Hoàn thành" ${st eq 'Hoàn thành' ? 'selected' : ''}>Hoàn thành</option>
                                                    </select>
                                                    <button type="submit" class="bg-[#00F0FF] hover:bg-cyan-400 text-black px-3 py-1 rounded-lg font-bold text-xs transition">
                                                        Cập Nhật
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not hasDatCoc}">
                            <tr>
                                <td colspan="9" class="p-6 text-center text-gray-500 italic">
                                    Không có phiếu đặt cọc nào.
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
                <span>💬 2. DANH SÁCH KHÁCH HÀNG TƯ VẤN THÔNG THƯỜNG</span>
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
                            <th class="p-3">TRẠNG THÁI</th>
                            <th class="p-3 text-center">HÀNH ĐỘNG</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-800/60">
                        <c:set var="hasTuVan" value="false" />
                        <c:forEach var="c" items="${masterList}">
                            <c:set var="tienGocVal" value="${c.tienGoc != null ? c.tienGoc : (c.tienDatCoc != null ? c.tienDatCoc : 0)}" />
                            
                            <c:if test="${tienGocVal <= 0 && !fn:contains(c.ghiChu, 'Đặt cọc') && !fn:contains(c.ghiChu, 'giỏ hàng')}">
                                <c:set var="hasTuVan" value="true" />
                                <c:set var="st" value="${fn:trim(c.trangThai)}" />
                                <c:set var="isCompleted" value="${st eq 'Hoàn thành'}" />

                                <tr class="hover:bg-gray-800/40 transition">
                                    <td class="p-3 font-bold text-[#00F0FF]">#${not empty c.maPTV ? c.maPTV : c.maTV}</td>
                                    <td class="p-3 font-bold text-white">${c.hoTen}</td>
                                    <td class="p-3 text-gray-300">${c.sdt}</td>
                                    <td class="p-3 text-gray-300">${c.email}</td>
                                    <td class="p-3 font-semibold text-white">${c.tenXe}</td>
                                    <td class="p-3 text-gray-400">${c.ngayGui}</td>
                                    <td class="p-3 font-bold uppercase text-xs">
                                        <c:choose>
                                            <c:when test="${st eq 'Hoàn thành'}">
                                                <span class="text-emerald-400">${empty c.trangThai ? 'Chờ xử lý' : c.trangThai}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-amber-400">${empty c.trangThai ? 'Chờ xử lý' : c.trangThai}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="p-3 text-center">
                                        <form action="employee" method="POST" class="flex items-center justify-center space-x-2">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="maPTV" value="${not empty c.maPTV ? c.maPTV : c.maTV}">

                                            <c:choose>
                                                <c:when test="${isCompleted}">
                                                    <select disabled class="bg-gray-800 text-gray-500 border border-gray-700 rounded-lg px-2 py-1 text-xs cursor-not-allowed">
                                                        <option selected>Đã hoàn thành</option>
                                                    </select>
                                                    <button type="button" disabled class="bg-gray-700 text-gray-500 px-3 py-1 rounded-lg font-bold text-xs cursor-not-allowed border border-gray-600 opacity-60">
                                                        Đã khóa
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <select name="trangThai" class="bg-gray-900 text-white border border-gray-700 rounded-lg px-2 py-1 text-xs focus:outline-none focus:border-[#00F0FF]">
                                                        <option value="Chờ xử lý" ${st eq 'Chờ xử lý' ? 'selected' : ''}>Chờ xử lý</option>
                                                        <option value="Đã tư vấn" ${st eq 'Đã tư vấn' ? 'selected' : ''}>Đã tư vấn</option>
                                                        <option value="Hoàn thành" ${st eq 'Hoàn thành' ? 'selected' : ''}>Hoàn thành</option>
                                                    </select>
                                                    <button type="submit" class="bg-[#00F0FF] hover:bg-cyan-400 text-black px-3 py-1 rounded-lg font-bold text-xs transition">
                                                        Cập Nhật
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not hasTuVan}">
                            <tr>
                                <td colspan="8" class="p-6 text-center text-gray-500 italic">
                                    Không có phiếu tư vấn thông thường nào.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <footer class="border-t border-gray-800 text-center py-6 text-gray-500 text-sm mt-8">
        &copy; 2026 ShopBanOto. All Rights Reserved.
    </footer>
</body>
</html>