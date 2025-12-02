<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Quản lý User</title>
    <link rel="stylesheet" href="styles/main.css" type="text/css"/>
</head>
<body>

<h1>Danh sách Users</h1>

<table>
    <tr>
        <th>Email</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Hành động</th>
    </tr>

    <c:forEach var="user" items="${users}">
        <tr>
            <td>${user.email}</td>
            <td>${user.firstName}</td>
            <td>${user.lastName}</td>
            <td>
                <a href="userAdmin?action=display_user&email=${user.email}">Sửa</a>
                |
                <a href="userAdmin?action=delete_user&email=${user.email}" 
                   onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a>
            </td>
        </tr>
    </c:forEach>
</table>

<p><a href="index.jsp">Về trang chủ</a></p>

</body>
</html>