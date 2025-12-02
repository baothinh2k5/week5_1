# ==========================================
# GIAI ĐOẠN 1: BUILD ỨNG DỤNG BẰNG MAVEN
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# 1. Copy file cấu hình maven trước (để tận dụng cache)
COPY pom.xml .

# 2. Copy toàn bộ source code
COPY src ./src

# 3. Build project
# -DskipTests: Bỏ qua test để build nhanh hơn
# Maven sẽ tạo file .war trong thư mục /app/target/
RUN mvn clean package -DskipTests

# ==========================================
# GIAI ĐOẠN 2: CHẠY ỨNG DỤNG BẰNG TOMCAT
# ==========================================
FROM tomcat:10.1-jdk17

# 1. Xóa các ứng dụng mặc định của Tomcat (để sạch sẽ)
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Copy file WAR từ giai đoạn Build sang giai đoạn Run
# Dùng ký tự đại diện *.war để chấp nhận mọi tên file (tránh lỗi "not found")
# Đổi tên thành ROOT.war để web chạy ngay tại trang chủ (/)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# 3. (Tuỳ chọn an toàn) Copy Driver PostgreSQL vào thư viện chung của Tomcat
# Điều này giúp đảm bảo JNDI Resource luôn tìm thấy Driver dù cấu hình Maven có sai sót
# Lưu ý: Lệnh này lấy file jar từ kho chứa Maven local trong giai đoạn build
COPY --from=build /root/.m2/repository/org/postgresql/postgresql/42.7.2/postgresql-42.7.2.jar /usr/local/tomcat/lib/

# 4. Mở port 8080 (Render sẽ map port này ra ngoài)
EXPOSE 8080

# 5. Khởi động Tomcat
CMD ["catalina.sh", "run"]