<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${empty sessionScope.acc || sessionScope.acc.vaiTro ne 'Admin'}">
    <c:redirect url="auth.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" class="dark">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị (Admin) - ShopBanOto</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        ::-webkit-scrollbar { width: 8px; }
        ::-webkit-scrollbar-track { background: #0D0E12; }
        ::-webkit-scrollbar-thumb { background: #00F0FF; border-radius: 4px; }
    </style>
</head>
<body class="bg-[#0D0E12] text-white font-sans">

    <nav class="sticky top-0 z-50 bg-[#0D0E12]/90 backdrop-blur-md border-b border-gray-800 px-6 py-4 flex justify-between items-center">
        <a href="admin" class="text-2xl font-black text-transparent bg-clip-text bg-gradient-to-r from-[#00F0FF] to-[#FF0055]">ADMIN PANEL</a>
        <div class="space-x-6 text-sm font-medium flex items-center">
            <a href="home" class="hover:text-[#FF0055] transition">Trang Chủ</a>
            <a href="product" class="hover:text-[#FF0055] transition">Sản Phẩm</a>
            <a href="consulting" class="hover:text-[#FF0055] transition">Tư Vấn</a>
            <a href="cart" class="hover:text-[#FF0055] transition">Giỏ Hàng / Đặt Cọc</a>
            
            <c:if test="${not empty sessionScope.acc && sessionScope.acc.vaiTro eq 'Admin'}">
                <a href="admin?action=consulting" class="text-purple-400 hover:text-[#FF0055] transition font-bold">Xử Lý Tư Vấn / Hủy Cọc</a>
                <a href="admin" class="text-[#FF0055] font-bold border-b-2 border-[#FF0055] pb-1">Quản Lý</a>
            </c:if>
            <c:if test="${not empty sessionScope.acc && sessionScope.acc.vaiTro eq 'Employee'}">
                <a href="employee" class="hover:text-[#FF0055] transition text-cyan-400 font-bold">Xử Lý TV</a>
            </c:if>

            <a href="profile" class="hover:text-[#FF0055] transition">Tài Khoản</a>
            
            <div class="flex items-center space-x-3 bg-gray-800/80 px-4 py-2 rounded-xl border border-gray-700">
                <span class="text-[#00F0FF] font-bold text-xs">Chào Admin, ${empty sessionScope.acc.hoTen ? sessionScope.acc.tenDangNhap : sessionScope.acc.hoTen}</span>
                <a href="logout" class="bg-[#FF0055] text-white px-3 py-1 rounded-lg text-xs font-bold hover:opacity-80 transition">Đăng Xuất</a>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-6 py-10 space-y-12">
        <!-- Thống kê tổng quan -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div class="bg-gray-900 border border-gray-800 p-6 rounded-2xl">
                <p class="text-gray-400 text-sm">Tổng Sản Phẩm (Tồn)</p>
                <h3 class="text-3xl font-black mt-2 text-[#00F0FF]">${empty totalProducts ? 0 : totalProducts}</h3>
            </div>
            <div class="bg-gray-900 border border-gray-800 p-6 rounded-2xl">
                <p class="text-gray-400 text-sm">Tổng Loại Xe</p>
                <h3 class="text-3xl font-black mt-2 text-purple-400">${empty tongLoaiXe ? 0 : tongLoaiXe}</h3>
            </div>
            <div class="bg-gray-900 border border-gray-800 p-6 rounded-2xl">
                <p class="text-gray-400 text-sm">Còn Hàng</p>
                <h3 class="text-3xl font-black mt-2 text-emerald-400">${empty soLuongCon ? 0 : soLuongCon}</h3>
            </div>
            <div class="bg-gray-900 border border-gray-800 p-6 rounded-2xl">
                <p class="text-gray-400 text-sm">Hết Hàng</p>
                <h3 class="text-3xl font-black mt-2 text-[#FF0055]">${empty soLuongHet ? 0 : soLuongHet}</h3>
            </div>
        </div>

        <!-- Form Thêm / Sửa Xe -->
        <div class="bg-gray-900 border border-gray-800 p-8 rounded-3xl" id="form-container">
            <h2 class="text-xl font-bold mb-6 text-[#00F0FF] uppercase">
                ${not empty editingProduct ? 'Cập Nhật Thông Tin Xe (Mã: #' : 'Thêm Xe Mới Vào Hệ Thống'} ${not empty editingProduct ? editingProduct.maXe : ''}${not empty editingProduct ? ')' : ''}
            </h2>
            <form action="admin" method="POST" onsubmit="prepareSubmit()" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <input type="hidden" name="maXe" value="${editingProduct.maXe}">
                <input type="hidden" name="action" value="${not empty editingProduct ? 'update' : 'add'}">

                <input type="text" name="tenXe" value="${editingProduct.tenXe}" placeholder="Tên xe" required class="bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF]">
                <input type="text" name="hangXe" value="${editingProduct.hangXe}" placeholder="Hãng xe" required class="bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF]">
                
                <input type="text" id="giaInput" name="gia" 
                       value="<fmt:formatNumber value='${editingProduct.gia}' pattern='#,##0' groupingUsed='true'/>" 
                       placeholder="Giá xe (VD: 12000000000)" required 
                       oninput="formatCurrencyInput(this)"
                       class="bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF]">
                
                <input type="number" min="0" name="soLuongTon" value="${editingProduct.soLuongTon}" placeholder="Số lượng tồn" required class="bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF]">
                <select name="status" class="bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm text-white focus:outline-none focus:border-[#00F0FF]">
                    <option value="con" ${empty editingProduct || editingProduct.soLuongTon > 0 ? 'selected' : ''}>Còn hàng</option>
                    <option value="het" ${not empty editingProduct && editingProduct.soLuongTon <= 0 ? 'selected' : ''}>Hết hàng</option>
                </select>
                <input type="text" name="hinhAnhDaiDien" value="${editingProduct.hinhAnhDaiDien}" placeholder="Link ảnh đại diện" class="bg-black/60 border border-gray-700 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-[#00F0FF]">
                
                <div class="md:col-span-2 flex space-x-4">
                    <button type="submit" class="flex-1 bg-[#00F0FF] text-black hover:bg-[#FF0055] hover:text-white py-3 rounded-xl font-black transition uppercase">
                        ${not empty editingProduct ? 'Lưu Thay Đổi' : 'Thêm Xe Mới'}
                    </button>
                    <c:if test="${not empty editingProduct}">
                        <a href="admin" class="bg-gray-700 text-white px-6 py-3 rounded-xl font-bold hover:bg-gray-600 transition text-center flex items-center justify-center">Hủy</a>
                    </c:if>
                </div>
            </form>
        </div>

        <!-- Bảng Quản Lý Sản Phẩm -->
        <div class="bg-gray-900 border border-gray-800 p-8 rounded-3xl overflow-x-auto shadow-xl">
            <h2 class="text-xl font-bold mb-6 text-[#00F0FF] uppercase">Quản Lý Danh Sách Sản Phẩm (Xe)</h2>
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="border-b border-gray-800 text-gray-400 text-sm">
                        <th class="py-3">Mã Xe</th>
                        <th class="py-3">Hình Ảnh</th>
                        <th class="py-3">Tên Xe</th>
                        <th class="py-3">Hãng Xe</th>
                        <th class="py-3">Giá (VNĐ)</th>
                        <th class="py-3">Số Lượng Tồn</th>
                        <th class="py-3 text-center">Hành Động</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-800 text-sm">
                    <c:choose>
                        <c:when test="${not empty productList}">
                            <c:forEach var="p" items="${productList}">
                                <tr>
                                    <td class="py-3">#${p.maXe}</td>
                                    <td class="py-3">
                                        <img src="${p.hinhAnhDaiDien}" alt="Ảnh xe" class="w-16 h-10 object-cover rounded-lg border border-gray-700">
                                    </td>
                                    <td class="py-3 font-bold text-white">${p.tenXe}</td>
                                    <td class="py-3 text-gray-400">${p.hangXe}</td>
                                    <td class="py-3 text-[#00F0FF] font-bold">
                                        <fmt:formatNumber value="${p.gia}" type="number" groupingUsed="true"/>
                                    </td>
                                    <td class="py-3">
                                        <c:choose>
                                            <c:when test="${p.soLuongTon > 0}">
                                                <span class="px-2.5 py-1 rounded-lg bg-emerald-500/20 text-emerald-400 font-bold">${p.soLuongTon}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="px-2.5 py-1 rounded-lg bg-[#FF0055]/20 text-[#FF0055] font-bold">Hết hàng (0)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="py-3 text-center space-x-2">
                                        <a href="admin?action=editForm&maXe=${p.maXe}" class="bg-[#00F0FF]/20 text-[#00F0FF] border border-[#00F0FF]/40 px-3 py-1.5 rounded-lg font-bold hover:bg-[#00F0FF] hover:text-black transition inline-block">Sửa</a>
                                        <a href="admin?action=delete&maXe=${p.maXe}" onclick="return confirm('Bạn có chắc chắn muốn xóa xe này không?');" class="bg-[#FF0055]/20 text-[#FF0055] border border-[#FF0055]/40 px-3 py-1.5 rounded-lg font-bold hover:bg-[#FF0055] hover:text-white transition inline-block">Xóa</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="py-6 text-center text-gray-400">Không tìm thấy sản phẩm nào trong hệ thống.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Bảng Quản Lý Đơn Hàng & Tiền Đặt Cọc -->
        <div class="bg-gray-900 border border-gray-800 p-8 rounded-3xl overflow-x-auto shadow-xl space-y-6">
            <div class="flex flex-col md:flex-row justify-between items-center gap-4">
                <h2 class="text-xl font-bold text-[#FF0055] uppercase">Quản Lý Đơn Hàng & Tiền Đặt Cọc</h2>
                
                <!-- Thanh tìm kiếm theo SĐT và lọc Trạng thái -->
                <form action="admin" method="GET" class="flex items-center gap-3 w-full md:w-auto">
                    <input type="text" name="orderKeyword" value="${param.orderKeyword}" placeholder="Nhập tên hoặc số điện thoại..." 
                           class="bg-black/60 border border-gray-700 rounded-xl px-4 py-2 text-xs text-white focus:outline-none focus:border-[#00F0FF] w-full md:w-64">
                    
                    <select name="statusFilter" class="bg-black/60 border border-gray-700 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-[#00F0FF]">
                        <option value="ALL" ${empty param.statusFilter || param.statusFilter eq 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="Chờ xử lý" ${param.statusFilter eq 'Chờ xử lý' ? 'selected' : ''}>Chờ xử lý</option>
                        <option value="Đã xác nhận" ${param.statusFilter eq 'Đã xác nhận' ? 'selected' : ''}>Đã xác nhận</option>
                        <option value="Đã hủy cọc" ${param.statusFilter eq 'Đã hủy cọc' ? 'selected' : ''}>Đã hủy cọc</option>
                    </select>

                    <button type="submit" class="bg-[#00F0FF] text-black font-bold px-4 py-2 rounded-xl text-xs hover:bg-cyan-400 transition">
                        Tìm Kiếm
                    </button>
                </form>
            </div>

            <table class="w-full text-left border-collapse text-sm">
                <thead>
                    <tr class="border-b border-gray-800 text-gray-400">
                        <th class="py-3">Mã ĐH</th>
                        <th class="py-3">Tên Khách</th>
                        <th class="py-3">Số ĐT</th>
                        <th class="py-3">Sản Phẩm Đặt</th>
                        <th class="py-3">Tiền Gốc</th>
                        <th class="py-3">Tiền Đặt Cọc (35%)</th>
                        <th class="py-3">Trạng Thái</th>
                        <th class="py-3 text-center">Hành Động</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-800">
                    <c:choose>
                        <c:when test="${not empty orderList}">
                            <c:forEach var="o" items="${orderList}">
                                <c:set var="tienCocChinhXac" value="${o.gia * 0.35}" />
                                <c:set var="st" value="${fn:trim(o.trangThai)}" />
                                <tr>
                                    <td class="py-4 font-bold text-[#00F0FF]">#${o.maDH}</td>
                                    <td class="py-4 font-bold text-white">${o.tenKhachHang}</td>
                                    <td class="py-4 text-gray-300">${o.sdt}</td>
                                    <td class="py-4 text-gray-300">${not empty o.tenXe ? o.tenXe : 'Xe ô tô cao cấp'}</td>
                                    <td class="py-4 text-gray-400">
                                        <fmt:formatNumber value="${o.gia}" type="number" groupingUsed="true"/> đ
                                    </td>
                                    <td class="py-4 text-[#FF0055] font-bold">
                                        <fmt:formatNumber value="${tienCocChinhXac}" type="number" groupingUsed="true"/> đ
                                    </td>
                                    <td class="py-4 font-bold uppercase text-xs">
                                        <c:choose>
                                            <c:when test="${st eq 'Đã hủy cọc' || st eq 'Khách hủy cọc' || st eq 'Đã hủy đơn' || fn:contains(st, 'hủy')}">
                                                <span class="text-red-400">ĐÃ HỦY CỌC</span>
                                            </c:when>
                                            <c:when test="${st eq 'Hoàn thành' || st eq 'Đã hoàn tất' || st eq 'Đã xác nhận'}">
                                                <span class="text-emerald-400">HOÀN THÀNH</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-amber-400">${empty o.trangThai ? 'Chờ xử lý' : o.trangThai}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="py-4 text-center">
                                        <c:choose>
                                            <%-- 1. Nếu đơn hàng đã hoàn thành hoặc đã hủy cọc -> Hiển thị nhãn Đã hoàn tất / Khóa thành công --%>
                                            <c:when test="${st eq 'Hoàn thành' || st eq 'Đã hoàn tất' || st eq 'Đã hủy cọc' || st eq 'Đã hủy đơn' || fn:contains(st, 'hủy')}">
                                                <span class="bg-gray-800 text-gray-500 border border-gray-700 px-3 py-1.5 rounded-lg font-bold text-[11px] inline-block uppercase cursor-not-allowed opacity-75">
                                                    Đã Hoàn Tất
                                                </span>
                                            </c:when>
                                            
                                            <%-- 2. Nếu đơn hàng chưa được xử lý xong ở trang tư vấn/hủy cọc -> KHÓA LẠI TUYỆT ĐỐI, HIỂN THỊ CHỜ DUYỆT XỬ LÝ --%>
                                            <c:otherwise>
                                                <span class="bg-gray-800 text-gray-500 border border-gray-700 px-3 py-1.5 rounded-lg font-bold text-[11px] inline-block uppercase cursor-not-allowed opacity-75" title="Cần hoàn tất duyệt ở trang tư vấn/hủy cọc trước">
                                                    Chờ Duyệt Xử Lý
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8" class="py-8 text-center text-gray-400">Không tìm thấy đơn hàng nào phù hợp.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <footer class="border-t border-gray-800 text-center py-6 text-gray-500 text-sm mt-12">
        &copy; 2026 ShopBanOto. All Rights Reserved.
    </footer>

    <script>
        function formatCurrencyInput(input) {
            let value = input.value.replace(/\D/g, "");
            if (value) {
                input.value = new Intl.NumberFormat('vi-VN').format(value);
            } else {
                input.value = "";
            }
        }

        function prepareSubmit() {
            let giaInput = document.getElementById("giaInput");
            if (giaInput) {
                giaInput.value = giaInput.value.replace(/\./g, "").replace(/,/g, "");
            }
        }
    </script>
</body>
</html>