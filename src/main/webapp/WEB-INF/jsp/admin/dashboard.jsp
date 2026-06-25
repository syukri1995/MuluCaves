<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard · Mulu Caves</title>
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- DataTables Base CSS -->
    <link href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" rel="stylesheet">
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: "#0f5a3f",
              accent: "#d97706",
              dark: "#0f172a",
            },
            fontFamily: {
              display: ['"Cormorant Garamond"', "serif"],
              sans: ['"Inter"', "sans-serif"],
            }
          }
        }
      }
    </script>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        
        /* Customizing DataTables to fit Tailwind slightly better */
        .dataTables_wrapper .dataTables_length select,
        .dataTables_wrapper .dataTables_filter input {
            border: 1px solid #e2e8f0;
            border-radius: 0.375rem;
            padding: 0.25rem 0.5rem;
            outline: none;
        }
        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            background: #0f5a3f !important;
            color: white !important;
            border: none !important;
            border-radius: 0.375rem;
        }
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            background: #0d4a32 !important;
            color: white !important;
            border: none !important;
        }
        table.dataTable.no-footer { border-bottom: 1px solid #e2e8f0; }
        table.dataTable thead th { border-bottom: 2px solid #e2e8f0; }
        
        /* Simple Modal backdrop */
        .modal-backdrop {
            display: none;
            position: fixed;
            inset: 0;
            background-color: rgba(0,0,0,0.5);
            z-index: 40;
        }
        .modal-backdrop.show { display: block; }
    </style>
</head>
<body class="text-gray-800 antialiased min-h-screen flex flex-col">

<!-- Admin navbar -->
<nav class="bg-primary shadow-md sticky top-0 z-30">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="flex items-center text-white font-display text-2xl font-semibold tracking-tight hover:text-accent transition-colors">
                    <i class="fa-solid fa-mountain-sun mr-2 text-accent"></i> Mulu Admin
                </a>
            </div>
            <div class="flex items-center space-x-6">
                <div class="text-white/80 text-sm hidden sm:block">
                    <i class="fa-solid fa-user-shield mr-1"></i>
                    Signed in as <strong class="text-white font-medium">${fn:escapeXml(admin.username)}</strong>
                </div>
                <div class="flex space-x-3">
                    <a href="${pageContext.request.contextPath}/home" target="_blank" class="text-white bg-white/10 hover:bg-white/20 border border-white/20 px-3 py-1.5 rounded text-sm transition-colors flex items-center">
                        <i class="fa-solid fa-up-right-from-square mr-1.5"></i> View site
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/logout" class="bg-white text-primary hover:bg-gray-100 px-3 py-1.5 rounded text-sm font-medium transition-colors flex items-center shadow-sm">
                        <i class="fa-solid fa-right-from-bracket mr-1.5"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 w-full flex-grow">

    <!-- Header & Breadcrumbs -->
    <div class="mb-8 flex justify-between items-end">
        <div>
            <h1 class="text-3xl font-display font-semibold text-gray-900">Dashboard</h1>
            <p class="text-gray-500 mt-1">Manage inquiries and platform activity</p>
        </div>
    </div>

    <!-- Stat cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <!-- Stat 1 -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 flex justify-between items-center hover:shadow-md transition-shadow">
            <div>
                <div class="text-gray-500 text-sm font-medium mb-1">Total inquiries</div>
                <div class="text-3xl font-bold text-gray-900">${fn:length(inquiries)}</div>
            </div>
            <div class="h-12 w-12 rounded-full bg-green-50 flex items-center justify-center text-primary text-xl">
                <i class="fa-solid fa-inbox"></i>
            </div>
        </div>
        
        <!-- Stat 2 -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 flex justify-between items-center hover:shadow-md transition-shadow">
            <div>
                <div class="text-gray-500 text-sm font-medium mb-1">From Social Media</div>
                <div class="text-3xl font-bold text-gray-900">
                    <c:set var="socialCount" value="0" scope="page"/>
                    <c:forEach var="inq" items="${inquiries}">
                        <c:if test="${inq.heardFrom eq 'Social Media'}">
                            <c:set var="socialCount" value="${socialCount + 1}" scope="page"/>
                        </c:if>
                    </c:forEach>
                    ${socialCount}
                </div>
            </div>
            <div class="h-12 w-12 rounded-full bg-blue-50 flex items-center justify-center text-blue-600 text-xl">
                <i class="fa-solid fa-share-nodes"></i>
            </div>
        </div>
        
        <!-- Stat 3 -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 flex justify-between items-center hover:shadow-md transition-shadow">
            <div>
                <div class="text-gray-500 text-sm font-medium mb-1">From Referrals</div>
                <div class="text-3xl font-bold text-gray-900">
                    <c:set var="refCount" value="0" scope="page"/>
                    <c:forEach var="inq" items="${inquiries}">
                        <c:if test="${inq.heardFrom eq 'Friend'}">
                            <c:set var="refCount" value="${refCount + 1}" scope="page"/>
                        </c:if>
                    </c:forEach>
                    ${refCount}
                </div>
            </div>
            <div class="h-12 w-12 rounded-full bg-orange-50 flex items-center justify-center text-accent text-xl">
                <i class="fa-solid fa-people-group"></i>
            </div>
        </div>
    </div>

    <!-- Inquiries table -->
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-200 bg-gray-50 flex items-center">
            <i class="fa-solid fa-table text-primary mr-2 text-lg"></i>
            <h2 class="text-lg font-semibold text-gray-800">Inquiry Submissions</h2>
        </div>
        <div class="p-6 overflow-x-auto">
            <table id="inquiriesTable" class="w-full text-left border-collapse stripe hover">
                <thead class="bg-white">
                    <tr class="text-gray-500 text-sm border-b-2 border-gray-200">
                        <th class="py-3 px-2 font-semibold">#</th>
                        <th class="py-3 px-2 font-semibold">Name</th>
                        <th class="py-3 px-2 font-semibold">Contact</th>
                        <th class="py-3 px-2 font-semibold">Gender</th>
                        <th class="py-3 px-2 font-semibold">Email</th>
                        <th class="py-3 px-2 font-semibold">Heard from</th>
                        <th class="py-3 px-2 font-semibold">Message</th>
                        <th class="py-3 px-2 font-semibold">Submitted at</th>
                        <th class="py-3 px-2 font-semibold text-center w-24">Actions</th>
                    </tr>
                </thead>
                <tbody class="text-sm">
                    <c:forEach var="inq" items="${inquiries}" varStatus="s">
                        <tr class="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                            <td class="py-3 px-2 text-gray-500">${s.count}</td>
                            <td class="py-3 px-2 font-medium text-gray-900">${fn:escapeXml(inq.name)}</td>
                            <td class="py-3 px-2 text-gray-600">${fn:escapeXml(inq.contact)}</td>
                            <td class="py-3 px-2">
                                <span class="px-2 py-1 rounded text-xs font-medium 
                                    ${inq.gender eq 'Male' ? 'bg-blue-100 text-blue-700' : (inq.gender eq 'Female' ? 'bg-pink-100 text-pink-700' : 'bg-gray-100 text-gray-700')}">
                                    ${fn:escapeXml(inq.gender)}
                                </span>
                            </td>
                            <td class="py-3 px-2 text-gray-600">${fn:escapeXml(inq.email)}</td>
                            <td class="py-3 px-2 text-gray-600">${fn:escapeXml(inq.heardFrom)}</td>
                            <td class="py-3 px-2 text-gray-600 truncate max-w-[150px]" title="${fn:escapeXml(inq.message)}">
                                ${fn:escapeXml(inq.message)}
                            </td>
                            <td class="py-3 px-2 text-gray-500"><fmt:formatDate value="${inq.submittedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td class="py-3 px-2">
                                <div class="flex items-center justify-center space-x-2">
                                    <button type="button" class="edit-btn text-blue-600 hover:text-blue-800 bg-blue-50 hover:bg-blue-100 h-8 w-8 rounded flex items-center justify-center transition-colors"
                                            data-id="${inq.id}"
                                            data-name="${fn:escapeXml(inq.name)}"
                                            data-contact="${fn:escapeXml(inq.contact)}"
                                            data-gender="${fn:escapeXml(inq.gender)}"
                                            data-email="${fn:escapeXml(inq.email)}"
                                            data-heard="${fn:escapeXml(inq.heardFrom)}"
                                            data-message="${fn:escapeXml(inq.message)}"
                                            title="Edit Inquiry">
                                        <i class="fa-solid fa-pencil text-xs"></i>
                                    </button>
                                    <button type="button" class="delete-btn text-red-600 hover:text-red-800 bg-red-50 hover:bg-red-100 h-8 w-8 rounded flex items-center justify-center transition-colors"
                                            data-id="${inq.id}"
                                            data-name="${fn:escapeXml(inq.name)}"
                                            title="Delete Inquiry">
                                        <i class="fa-solid fa-trash-can text-xs"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Edit Inquiry Modal Backdrop (Custom Tailwind Modal) -->
<div class="modal-backdrop" id="modalBackdrop">
    <div class="fixed inset-0 flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-3xl max-h-[90vh] flex flex-col transform transition-all relative overflow-hidden" id="editModalContent" style="display: none;">
            
            <div class="bg-primary text-white px-6 py-4 flex justify-between items-center">
                <h3 class="font-semibold text-lg flex items-center">
                    <i class="fa-solid fa-pen-to-square mr-2"></i> Edit Inquiry
                </h3>
                <button type="button" class="close-modal text-white/80 hover:text-white transition-colors">
                    <i class="fa-solid fa-xmark text-xl"></i>
                </button>
            </div>
            
            <form id="editForm" class="flex flex-col flex-grow overflow-hidden">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" id="editId">
                
                <div class="p-6 overflow-y-auto bg-gray-50 flex-grow">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Full Name</label>
                            <input type="text" name="name" id="editName" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Contact Number</label>
                            <input type="text" name="contact" id="editContact" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Gender</label>
                            <select name="gender" id="editGender" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent bg-white">
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Email Address</label>
                            <input type="email" name="email" id="editEmail" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent">
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-1">Heard About Us From</label>
                            <select name="heard_from" id="editHeardFrom" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent bg-white">
                                <option value="Social Media">Social Media</option>
                                <option value="Friend">Friend / Recommendation</option>
                                <option value="Google Search">Google Search</option>
                                <option value="Travel Blog">Travel Blog</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-gray-700 mb-1">Message</label>
                            <textarea name="message" id="editMessage" rows="4" required class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"></textarea>
                        </div>
                    </div>
                </div>
                
                <div class="px-6 py-4 border-t border-gray-200 bg-white flex justify-end space-x-3">
                    <button type="button" class="close-modal px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium transition-colors">Cancel</button>
                    <button type="submit" class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-[#0d4a32] font-medium transition-colors flex items-center shadow-sm">
                        <i class="fa-solid fa-save mr-2"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function () {
        // Initialize DataTables
        const table = $('#inquiriesTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50],
            order: [[7, 'desc']], // sort by Submitted At (index 7) desc
            columnDefs: [
                { orderable: false, targets: [6, 8] } // message and actions columns not sortable
            ],
            language: {
                search: "Search inquiries:",
                emptyTable: "No inquiries yet — submit one from the public site to see it here."
            }
        });

        // Simple Modal Logic
        function openModal() {
            $('#modalBackdrop').addClass('show');
            $('#editModalContent').fadeIn(200);
        }
        function closeModal() {
            $('#editModalContent').fadeOut(200, function() {
                $('#modalBackdrop').removeClass('show');
            });
        }
        $('.close-modal').on('click', closeModal);

        // Edit button click event
        $('#inquiriesTable').on('click', '.edit-btn', function() {
            $('#editId').val($(this).data('id'));
            $('#editName').val($(this).data('name'));
            $('#editContact').val($(this).data('contact'));
            $('#editGender').val($(this).data('gender'));
            $('#editEmail').val($(this).data('email'));
            $('#editHeardFrom').val($(this).data('heard'));
            $('#editMessage').val($(this).data('message'));
            openModal();
        });

        // Edit form submit event
        $('#editForm').on('submit', function(e) {
            e.preventDefault();
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/dashboard',
                type: 'POST',
                data: $(this).serialize(),
                success: function(response) {
                    if (response.success) {
                        closeModal();
                        Swal.fire({
                            icon: 'success',
                            title: 'Updated!',
                            text: 'Inquiry details have been updated successfully.',
                            timer: 1500,
                            showConfirmButton: false,
                            customClass: {
                                confirmButton: 'bg-primary text-white px-4 py-2 rounded'
                            }
                        }).then(() => {
                            location.reload();
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Validation Failed',
                            text: response.message || 'Could not update inquiry details.'
                        });
                    }
                },
                error: function(xhr) {
                    let errMsg = 'An error occurred while connecting to the server.';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errMsg = xhr.responseJSON.message;
                    }
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: errMsg
                    });
                }
            });
        });

        // Delete button click event
        $('#inquiriesTable').on('click', '.delete-btn', function() {
            const id = $(this).data('id');
            const name = $(this).data('name');
            
            Swal.fire({
                title: 'Are you sure?',
                text: `You are about to delete the inquiry from "${name}". This action cannot be undone!`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc2626',
                cancelButtonColor: '#6b7280',
                confirmButtonText: 'Yes, delete it!',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/admin/dashboard',
                        type: 'POST',
                        data: {
                            action: 'delete',
                            id: id
                        },
                        success: function(response) {
                            if (response.success) {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Deleted!',
                                    text: 'Inquiry has been deleted.',
                                    timer: 1500,
                                    showConfirmButton: false
                                }).then(() => {
                                    location.reload();
                                });
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Failed',
                                    text: response.message || 'Could not delete inquiry.'
                                });
                            }
                        },
                        error: function(xhr) {
                            let errMsg = 'An error occurred while connecting to the server.';
                            if (xhr.responseJSON && xhr.responseJSON.message) {
                                errMsg = xhr.responseJSON.message;
                            }
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: errMsg
                            });
                        }
                    });
                }
            });
        });
    });
</script>

</body>
</html>