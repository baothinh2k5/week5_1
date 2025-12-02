package murach.data;

import java.util.List;
import jakarta.persistence.*;
import murach.business.User;

public class UserDB {

    public static void insert(User user) {
        performQuery(user, "insert");
    }

    public static void update(User user) {
        performQuery(user, "update");
    }

    public static void delete(User user) {
        performQuery(user, "delete");
    }

    // Hàm chung để xử lý transaction cho gọn
    private static void performQuery(User user, String action) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        trans.begin();
        try {
            if (action.equals("insert")) em.persist(user);
            else if (action.equals("update")) em.merge(user);
            else if (action.equals("delete")) em.remove(em.merge(user));
            trans.commit();
        } catch (Exception e) {
            System.out.println(e);
            trans.rollback();
        } finally {
            em.close();
        }
    }

    public static User selectUser(String email) {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        String qString = "SELECT u FROM User u WHERE u.email = :email";
        TypedQuery<User> q = em.createQuery(qString, User.class);
        q.setParameter("email", email);
        try {
            return q.getSingleResult();
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public static boolean emailExists(String email) {
        return selectUser(email) != null;
    }

    public static List<User> selectUsers() {
        EntityManager em = DBUtil.getEmFactory().createEntityManager();
        String qString = "SELECT u from User u";
        TypedQuery<User> q = em.createQuery(qString, User.class);
        try {
            return q.getResultList();
        } finally {
            em.close();
        }
    }
}