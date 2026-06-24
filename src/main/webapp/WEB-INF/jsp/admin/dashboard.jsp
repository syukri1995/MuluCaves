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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
</head>
<body class="admin-body">

<!-- Admin navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-success shadow-sm">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fa-solid fa-mountain-sun me-2"></i>Mulu Admin
        </a>
        <ul class="navbar-nav ms-auto align-items-lg-center">
            <li class="nav-item me-lg-3">
                <span class="text-white-50 small">
                    <i class="fa-solid fa-user-shield me-1"></i>
                    Signed in as <strong class="text-white">${fn:escapeXml(admin.username)}</strong>
                </span>
            </li>
            <li class="nav-item">
                <a class="btn btn-sm btn-outline-light" href="${pageContext.request.contextPath}/home" target="_blank">
                    <i class="fa-solid fa-up-right-from-square me-1"></i> View site
                </a>
            </li>
            <li class="nav-item ms-lg-2">
                <a class="btn btn-sm btn-light" href="${pageContext.request.contextPath}/admin/logout">
                    <i class="fa-solid fa-right-from-bracket me-1"></i> Logout
                </a>
            </li>
        </ul>
    </div>
</nav>

<div class="container-fluid px-4 py-4">

    <!-- Stat cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card stat-card border-0 shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small">Total inquiries</div>
                            <div class="fs-2 fw-bold">${fn:length(inquiries)}</div>
                        </div>
                        <i class="fa-solid fa-inbox stat-icon text-success"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card border-0 shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small">From social media</div>
                            <div class="fs-2 fw-bold">
                                <c:set var="socialCount" value="0" scope="page"/>
                                <c:forEach var="inq" items="${inquiries}">
                                    <c:if test="${inq.heardFrom eq 'Social Media'}">
                                        <c:set var="socialCount" value="${socialCount + 1}" scope="page"/>
                                    </c:if>
                                </c:forEach>
                                ${socialCount}
                            </div>
                        </div>
                        <i class="fa-solid fa-share-nodes stat-icon text-primary"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card border-0 shadow-sm h-100">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="text-muted small">From referrals</div>
                            <div class="fs-2 fw-bold">
                                <c:set var="refCount" value="0" scope="page"/>
                                <c:forEach var="inq" items="${inquiries}">
                                    <c:if test="${inq.heardFrom eq 'Friend'}">
                                        <c:set var="refCount" value="${refCount + 1}" scope="page"/>
                                    </c:if>
                                </c:forEach>
                                ${refCount}
                            </div>
                        </div>
                        <i class="fa-solid fa-people-group stat-icon text-warning"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Inquiries table -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white">
            <h5 class="mb-0"><i class="fa-solid fa-table me-2 text-success"></i>Inquiry submissions</h5>
        </div>
        <div class="card-body">
            <table id="inquiriesTable" class="table table-striped table-hover align-middle">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Contact</th>
                        <th>Gender</th>
                        <th>Email</th>
                        <th>Heard from</th>
                        <th>Message</th>
                        <th>Submitted at</th>
                        <th class="text-center" style="width: 100px;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="inq" items="${inquiries}" varStatus="s">
                        <tr>
                            <td>${s.count}</td>
                            <td>${fn:escapeXml(inq.name)}</td>
                            <td>${fn:escapeXml(inq.contact)}</td>
                            <td>
                                <span class="badge bg-${inq.gender eq 'Male' ? 'primary' : (inq.gender eq 'Female' ? 'danger' : 'secondary')}">
                                    ${fn:escapeXml(inq.gender)}
                                </span>
                            </td>
                            <td>${fn:escapeXml(inq.email)}</td>
                            <td>${fn:escapeXml(inq.heardFrom)}</td>
                            <td class="text-truncate" style="max-width: 200px;" title="${fn:escapeXml(inq.message)}">
                                ${fn:escapeXml(inq.message)}
                            </td>
                            <td><fmt:formatDate value="${inq.submittedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td class="text-center">
                                <div class="btn-group btn-group-sm">
                                    <button type="button" class="btn btn-outline-success edit-btn"
                                            data-id="${inq.id}"
                                            data-name="${fn:escapeXml(inq.name)}"
                                            data-contact="${fn:escapeXml(inq.contact)}"
                                            data-gender="${fn:escapeXml(inq.gender)}"
                                            data-email="${fn:escapeXml(inq.email)}"
                                            data-heard="${fn:escapeXml(inq.heardFrom)}"
                                            data-message="${fn:escapeXml(inq.message)}"
                                            title="Edit Inquiry">
                                        <i class="fa-solid fa-pencil"></i>
                                    </button>
                                    <button type="button" class="btn btn-outline-danger delete-btn"
                                            data-id="${inq.id}"
                                            data-name="${fn:escapeXml(inq.name)}"
                                            title="Delete Inquiry">
                                        <i class="fa-solid fa-trash-can"></i>
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

<!-- Edit Inquiry Modal -->
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title" id="editModalLabel"><i class="fa-solid fa-pen-to-square me-2"></i>Edit Inquiry</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="editForm">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" id="editId">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="editName" class="form-label fw-semibold">Full Name</label>
                            <input type="text" class="form-control" name="name" id="editName" required>
                        </div>
                        <div class="col-md-6">
                            <label for="editContact" class="form-label fw-semibold">Contact Number</label>
                            <input type="text" class="form-control" name="contact" id="editContact" required>
                        </div>
                        <div class="col-md-6">
                            <label for="editGender" class="form-label fw-semibold">Gender</label>
                            <select class="form-select" name="gender" id="editGender" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="editEmail" class="form-label fw-semibold">Email Address</label>
                            <input type="email" class="form-control" name="email" id="editEmail" required>
                        </div>
                        <div class="col-md-12">
                            <label for="editHeardFrom" class="form-label fw-semibold">Heard About Us From</label>
                            <select class="form-select" name="heard_from" id="editHeardFrom" required>
                                <option value="Social Media">Social Media</option>
                                <option value="Friend">Friend / Recommendation</option>
                                <option value="Google Search">Google Search</option>
                                <option value="Travel Blog">Travel Blog</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-12">
                            <label for="editMessage" class="form-label fw-semibold">Message</label>
                            <textarea class="form-control" name="message" id="editMessage" rows="4" required></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-success"><i class="fa-solid fa-save me-1"></i>Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function () {
        // Initialize DataTables
        const table = $('#inquiriesTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50],
            order: [[7, 'desc']],           // sort by Submitted At (index 7) desc
            columnDefs: [
                { orderable: false, targets: [6, 8] } // message and actions columns not sortable
            ],
            language: {
                search: "Search inquiries:",
                emptyTable: "No inquiries yet — submit one from the public site to see it here."
            }
        });

        // Edit button click event
        $('#inquiriesTable').on('click', '.edit-btn', function() {
            $('#editId').val($(this).data('id'));
            $('#editName').val($(this).data('name'));
            $('#editContact').val($(this).data('contact'));
            $('#editGender').val($(this).data('gender'));
            $('#editEmail').val($(this).data('email'));
            $('#editHeardFrom').val($(this).data('heard'));
            $('#editMessage').val($(this).data('message'));
            $('#editModal').modal('show');
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
                        $('#editModal').modal('hide');
                        Swal.fire({
                            icon: 'success',
                            title: 'Updated!',
                            text: 'Inquiry details have been updated successfully.',
                            timer: 1500,
                            showConfirmButton: false
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
                confirmButtonColor: '#d33',
                cancelButtonColor: '#6c757d',
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