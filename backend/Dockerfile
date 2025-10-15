# ---------- Build stage ----------
    FROM maven:3.9-eclipse-temurin-21 AS build
    WORKDIR /app
    
    # تنزيل الديبندنسيز أولاً للاستفادة من الكاش
    COPY backend/pom.xml .
    RUN mvn -B -ntp -DskipTests dependency:go-offline
    
    # نسخ السورس والبناء
    COPY backend/. .
    RUN mvn -B -ntp -DskipTests clean package
    
    # ---------- Runtime stage ----------
    FROM eclipse-temurin:21-jre-alpine AS runtime
    WORKDIR /app
    
    # أدوات مطلوبة للصحة والشهادات
    RUN apk add --no-cache curl ca-certificates \
     && addgroup -S app && adduser -S app -G app
    
    # نسخ الـ jar الناتج
    COPY --from=build /app/target/*.jar /app/app.jar
    
    # متغيرات افتراضية (عدّليها حسب بيئتك)
    ENV JAVA_OPTS="-Xms256m -Xmx512m" \
        SPRING_PROFILES_ACTIVE=azure \
        SERVER_PORT=8080
    
    # اختياري: إن كان تطبيقك يقرأ من هذه الأسماء مباشرة
    # ENV DB_HOST=localhost DB_NAME=appdb DB_USERNAME=sa DB_PASSWORD=Passw0rd! DB_PORT=1433
    
    # فحص صحة الحاوية
    HEALTHCHECK --interval=30s --timeout=5s --retries=5 \
      CMD curl -sf http://localhost:8080/api/health || exit 1
    
    EXPOSE 8080
    
    # تشغيل بغير root
    USER app
    
    CMD ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]