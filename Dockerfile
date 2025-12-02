# ==========================================
# GIAI ĐOẠN 1: BUILD
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml và tải thư viện (kèm cờ -B để tắt log spam)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source và build
COPY src ./src
RUN mvn clean package -DskipTests -B

# ==========================================
# GIAI ĐOẠN 2: RUN
# ==========================================
FROM tomcat:10.1-jdk17

# 1. Xóa ứng dụng mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# 2. Copy file WAR từ giai đoạn build
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# --- ĐÃ XÓA PHẦN TẠO USER ĐỂ TRÁNH LỖI ---
# Mặc định Tomcat sẽ chạy với quyền root, đảm bảo không lỗi quyền hạn (Permission)

# 3. Mở port 8080
EXPOSE 8080

# 4. Chạy Tomcat
CMD ["catalina.sh", "run"]