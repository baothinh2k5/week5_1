package murach.data;

// Thay đổi từ javax.persistence.* thành jakarta.persistence.*
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class DBUtil {
    
    // Đảm bảo tên "emailListPU" khớp với tên trong persistence.xml
    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("emailListPU");
    
    public static EntityManagerFactory getEmFactory() {
        return emf;
    }
}