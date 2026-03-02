<%-- 
    Document   : sizeContent
    Created on : Feb 28, 2026, 1:38:56 AM
    Author     : FPTShop
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<table class="table table-bordered">
    <tr>
        <th>Size</th>
        <th>Quantity</th>
    </tr>

    <c:forEach items="${sizes}" var="s">
        <c:if test="${s.quantity > 0}">
            <tr>
                <td>${s.size}</td>
                <td>${s.quantity}</td>
            </tr>
        </c:if>
    </c:forEach>

</table>
