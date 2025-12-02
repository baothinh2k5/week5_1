<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Cập nhật User</title>
    <link rel="stylesheet" href="styles/main.css" type="text/css"/>
</head>
<body>
    <h1>Cập nhật thông tin User</h1>
    
    <form action="userAdmin" method="post">
        <input type="hidden" name="action" value="update_user">
        
        <label>Email (Không thể sửa):</label>
        <input type="email" name="email" value="${user.email}" readonly style="background-color: #eee;"><br><br>
        
        <label>First Name:</label>
        <input type="text" name="firstName" value="${user.firstName}" required><br><br>
        
        <label>Last Name:</label>
        <input type="text" name="lastName" value="${user.lastName}" required><br><br>
        
        <input type="submit" value="Lưu Cập Nhật">
    </form>
    
    <br>
    <p><a href="userAdmin">Quay lại danh sách</a></p>
</body>
</html>