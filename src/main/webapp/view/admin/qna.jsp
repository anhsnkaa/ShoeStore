<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Q&A Management</title>
        <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
        <link href="${pageContext.request.contextPath}/vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/sb-admin.css" rel="stylesheet">
    </head>
    <body>
        <div class="container-fluid mt-4">
            <div class="card mb-3">
                <div class="card-header">
                    <i class="fas fa-question-circle"></i>
                    Pending Questions
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-secondary float-right">
                        Back To Dashboard
                    </a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Product</th>
                                    <th>User</th>
                                    <th>Question</th>
                                    <th>Created</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty pendingQuestions}">
                                    <tr>
                                        <td colspan="6" class="text-center">No pending questions</td>
                                    </tr>
                                </c:if>
                                <c:forEach items="${pendingQuestions}" var="q">
                                    <tr>
                                        <td>#${q.id}</td>
                                        <td>${q.product.name}</td>
                                        <td>${q.user.fullName}</td>
                                        <td>${q.content}</td>
                                        <td>${q.createdDate}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/qna" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="approve-question"/>
                                                <input type="hidden" name="questionId" value="${q.id}"/>
                                                <button type="submit" class="btn btn-sm btn-success">Approve</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/qna" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="reject-question"/>
                                                <input type="hidden" name="questionId" value="${q.id}"/>
                                                <button type="submit" class="btn btn-sm btn-danger">Reject</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="card mb-3">
                <div class="card-header">
                    <i class="fas fa-reply"></i>
                    Pending Answers
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" width="100%" cellspacing="0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Question ID</th>
                                    <th>User</th>
                                    <th>Answer</th>
                                    <th>Created</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty pendingAnswers}">
                                    <tr>
                                        <td colspan="6" class="text-center">No pending answers</td>
                                    </tr>
                                </c:if>
                                <c:forEach items="${pendingAnswers}" var="a">
                                    <tr>
                                        <td>#${a.id}</td>
                                        <td>#${a.question.id}</td>
                                        <td>${a.user.fullName}</td>
                                        <td>${a.content}</td>
                                        <td>${a.createdDate}</td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/qna" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="approve-answer"/>
                                                <input type="hidden" name="answerId" value="${a.id}"/>
                                                <button type="submit" class="btn btn-sm btn-success">Approve</button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/qna" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="reject-answer"/>
                                                <input type="hidden" name="answerId" value="${a.id}"/>
                                                <button type="submit" class="btn btn-sm btn-danger">Reject</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
