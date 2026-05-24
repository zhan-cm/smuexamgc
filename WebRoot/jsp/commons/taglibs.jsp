<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
    String requestUrl=request.getRequestURL().toString();
    request.setAttribute("requestUrl",requestUrl);
    response.setHeader("Pragma","no-cache");
    response.setHeader("Cache-Control","no-cache");
    response.setDateHeader("Expires", 0);
%>

<c:if test="${fn:contains(requestUrl,'https') }">
    <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
</c:if>