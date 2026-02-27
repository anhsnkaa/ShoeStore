<%-- 
    Document   : deleteProductModal
    Created on : Feb 28, 2026, 4:21:07 AM
    Author     : FPTShop
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Delete Product Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="close" data-dismiss="modal">
                    &times;
                </button>
            </div>

            <div class="modal-body text-center">
                <h5 id="deleteProductName"></h5>
                <h5>Are you sure you want to delete this product?</h5>
                <p class="text-muted">This action cannot be undone.</p>
            </div>

            <div class="modal-footer justify-content-center">
                <form id="deleteForm" method="POST">
                    <button type="button"
                            class="btn btn-secondary"
                            data-dismiss="modal">
                        No
                    </button>

                    <button type="submit"
                            class="btn btn-danger">
                        Yes, Delete
                    </button>
                </form>
            </div>

        </div>
    </div>
</div>