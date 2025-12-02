package murach.admin;

import java.io.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import murach.business.User;
import murach.data.UserDB;

// Map đường dẫn /userAdmin
@WebServlet("/userAdmin")
public class UsersServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String url = "/index.jsp";
        String action = request.getParameter("action");
        if (action == null) action = "display_users";

        if (action.equals("display_users")) {
            List<User> users = UserDB.selectUsers();
            request.setAttribute("users", users);
            url = "/users.jsp"; // Chuyển đến trang danh sách
        } 
        else if (action.equals("display_user")) {
            String email = request.getParameter("email");
            User user = UserDB.selectUser(email);
            session.setAttribute("user", user);
            url = "/user.jsp"; // Chuyển đến trang sửa
        }
        else if (action.equals("update_user")) {
            User user = (User) session.getAttribute("user");
            user.setFirstName(request.getParameter("firstName"));
            user.setLastName(request.getParameter("lastName"));
            UserDB.update(user);
            
            // Cập nhật xong thì load lại danh sách
            List<User> users = UserDB.selectUsers();
            request.setAttribute("users", users);
            url = "/users.jsp";
        }
        else if (action.equals("delete_user")) {
            String email = request.getParameter("email");
            User user = UserDB.selectUser(email);
            UserDB.delete(user);
            
            List<User> users = UserDB.selectUsers();
            request.setAttribute("users", users);
            url = "/users.jsp";
        }
        
        getServletContext().getRequestDispatcher(url).forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}