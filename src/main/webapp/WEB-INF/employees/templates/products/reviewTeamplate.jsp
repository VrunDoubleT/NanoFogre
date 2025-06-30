<%-- 
    Document   : reviewTeamplate
    Created on : Jun 27, 2025, 1:30:53 PM
    Author     : Tran Thanh Van - CE181019
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:forEach var="review" items="${reviews}">
    <c:set var="review" value="${review}" scope="request" />
    <div id="wrapper-review-${review.id}">
        <jsp:include page="reviewItemTeamplate.jsp" />
    </div>
</c:forEach>
