# ==========================================
# GIAI ĐOẠN 1: BUILD ỨNG DỤNG BẰNG MAVEN
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# 1. Tối ưu Cache Dependencies (Nếu pom.xml không đổi)
COPY pom.xml .
# Tải tất cả dependencies xuống /.m2/repository
RUN mvn dependency:go-offline

# 2. Copy toàn bộ source code
COPY src ./src

# 3. Build project
# Maven sẽ tạo file .war trong thư mục /app/target/
RUN mvn clean package -DskipTests

# ==========================================
# GIAI ĐOẠN 2: CHẠY ỨNG DỤNG BẰNG TOMCAT
# ==========================================
FROM tomcat:10.1-jdk17

# 1. Xóa các ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Copy file WAR từ giai đoạn Build sang giai đoạn Run
# Đổi tên thành ROOT.war để web chạy ngay tại trang chủ (/)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 3. Copy Driver PostgreSQL vào thư viện chung của Tomcat
# Giữ nguyên path /root/.m2/repository vì giai đoạn BUILD chạy bằng user root
COPY --from=build /root/.m2/repository/org/postgresql/postgresql/42.7.2/postgresql-42.7.2.jar /usr/local/tomcat/lib/

# 4. Tăng cường bảo mật: Chuyển sang user tomcat
# Tomcat image có sẵn user và group 'tomcat'
USER tomcat

# 5. Mở port 8080 
EXPOSE 8080

# 6. Khởi động Tomcat
CMD ["catalina.sh", "run"]