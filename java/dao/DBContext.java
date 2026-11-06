package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {
    public static Connection getConnection() throws Exception {
    
        String url = "jdbc:sqlserver://localhost:1433;databaseName=ShopBanOto;encrypt=false";
        String user = "sa";
        String pass = "123456"; 
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, user, pass);
    }
}