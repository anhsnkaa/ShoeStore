<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Q&A Management</title>
        <link href="${pageContext.request.contextPath}/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
        <link href="${pageContext.request.contextPath}/css/sb-admin.css" rel="stylesheet">
    </head>
    <body id="page-top">
            <div id="wrapper">
            <jsp:include page="../common/admin/sidebar.jsp"></jsp:include>
                <div id="content-wrapper">
                    <div class="container-fluid">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <ol class="breadcrumb mb-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                                <li class="breadcrumb-item active">Pending Q&amp;A</li>
                            </ol>
                            <div>
                               <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-dark">Back To Home</a>
                            </div>
                        </div>

                        <c:if test="${not empty qnaMessage}">
                            <c:choose>
                                <c:when test="${qnaType == 'success'}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        ${qnaMessage}
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        ${qnaMessage}
                                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                        <div class="row">
                            <div class="col-xl-4 col-sm-6 mb-3">
                                <div class="card text-white bg-primary o-hidden h-100">
                                    <div class="card-body">
                                        <div class="card-body-icon"><i class="fas fa-question-circle"></i></div>
                                        <div class="mr-5">Pending Questions</div>
                                        <h5 class="mb-0">${empty pendingQuestionCount ? 0 : pendingQuestionCount}</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-4 col-sm-6 mb-3">
                                <div class="card text-white bg-success o-hidden h-100">
                                    <div class="card-body">
                                        <div class="card-body-icon"><i class="fas fa-reply"></i></div>
                                        <div class="mr-5">Pending Answers</div>
                                        <h5 class="mb-0">${empty pendingAnswerCount ? 0 : pendingAnswerCount}</h5>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xl-4 col-sm-6 mb-3">
                                <div class="card text-white bg-danger o-hidden h-100">
                                    <div class="card-body">
                                        <div class="card-body-icon"><i class="fas fa-bell"></i></div>
                                        <div class="mr-5">Total Pending Items</div>
                                        <h5 class="mb-0">${empty totalPendingCount ? 0 : totalPendingCount}</h5>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="card mb-3">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-question-circle"></i> Pending Questions</span>
                                <span class="badge badge-secondary">${empty pendingQuestionCount ? 0 : pendingQuestionCount} items</span>
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
                                                    <td>${q.createdDateDisplay}</td>
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
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <span><i class="fas fa-reply"></i> Pending Answers</span>
                                <span class="badge badge-secondary">${empty pendingAnswerCount ? 0 : pendingAnswerCount} items</span>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-bordered" width="100%" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Question ID</th>
                                                <th>Product</th>
                                                <th>Question</th>
                                                <th>User</th>
                                                <th>Answer</th>
                                                <th>Created</th>
                                                <th>View</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty pendingAnswers}">
                                                <tr>
                                                    <td colspan="9" class="text-center">No pending answers</td>
                                                </tr>
                                            </c:if>
                                            <c:forEach items="${pendingAnswers}" var="a">
                                                <tr>
                                                    <td>#${a.id}</td>
                                                    <td>#${a.question.id}</td>
                                                    <td>${a.question.product.name}</td>
                                                    <td>${a.question.content}</td>
                                                    <td>${a.user.fullName}</td>
                                                    <td>${a.content}</td>
                                                    <td>${a.createdDateDisplay}</td>
                                                    <td>
                                                        <a class="btn btn-sm btn-info" href="${pageContext.request.contextPath}/product-details?id=${a.question.product.id}#Qna" target="_blank">
                                                            Open
                                                        </a>
                                                    </td>
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
                    <jsp:include page="../common/admin/footer.jsp"></jsp:include>
                </div>
            </div>

            <a class="scroll-to-top rounded" href="#page-top">
                <i class="fas fa-angle-up"></i>
            </a>
            <jsp:include page="../common/admin/logoutmodel.jsp"></jsp:include>
            <script src="${pageContext.request.contextPath}/vendor/jquery/jquery.min.js"></script>
            <script src="${pageContext.request.contextPath}/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
            <script src="${pageContext.request.contextPath}/vendor/jquery-easing/jquery.easing.min.js"></script>
            <script src="${pageContext.request.contextPath}/js/sb-admin.min.js"></script>
    </body>
</html>
