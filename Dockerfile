# ==========================================
# STAGE 1: BUILD (Sử dụng Maven để tạo file .war)
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# 1. Copy file pom.xml trước để tận dụng Docker Cache
# Nếu bạn không sửa pom.xml, Docker sẽ bỏ qua bước tải thư viện ở lần build sau -> Rất nhanh
COPY pom.xml .

# 2. Tải toàn bộ dependencies (bao gồm EclipseLink, Postgres Driver)
# Bước này đảm bảo mọi thư viện trong pom.xml đều được tải về máy ảo
RUN mvn dependency:go-offline

# 3. Copy source code và build
COPY src ./src
# Build ra file WAR, bỏ qua test để tránh lỗi kết nối DB trong lúc build
RUN mvn clean package -DskipTests

# ==========================================
# STAGE 2: RUN (Chạy ứng dụng với Tomcat 10)
# ==========================================
FROM tomcat:10.1-jdk17

# 1. Xóa ứng dụng mặc định của Tomcat để nhẹ và sạch
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Copy file WAR từ giai đoạn Build
# Đổi tên thành ROOT.war để app chạy ngay tại đường dẫn gốc (localhost:8080/)
# Không cần gõ /ch3_exl_email nữa
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 3. Thiết lập quyền hạn (Security Best Practice)
# Chuyển quyền sở hữu thư mục webapps cho user 'tomcat' để tránh lỗi Permission Denied
RUN chown -R tomcat:tomcat /usr/local/tomcat/webapps/

# 4. Chạy với user 'tomcat' thay vì 'root' (An toàn hơn)
USER tomcat

# 5. Mở port 8080
EXPOSE 8080

# 6. Khởi chạy Tomcat
CMD ["catalina.sh", "run"]