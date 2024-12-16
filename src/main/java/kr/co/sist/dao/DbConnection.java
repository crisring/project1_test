package kr.co.sist.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DbConnection {

	// Volatile keyword ensures visibility of changes to variables across threads
	private static volatile DbConnection dbCon;

	// Private constructor to prevent instantiation
	private DbConnection() {
	}

	// Thread-safe Singleton instance retrieval
	public static DbConnection getInstance() {
		if (dbCon == null) {
			synchronized (DbConnection.class) {
				if (dbCon == null) {
					dbCon = new DbConnection();
				}
			}
		}
		return dbCon;
	}

	public Connection getConn() throws SQLException {
		Connection con = null;

		try {
			// 1. JNDI사용객체 생성
			Context ctx = new InitialContext();
			// 2. DBCP에서 DataSource 얻기
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/dbcp");
			// 3. Connection 얻기
			con = ds.getConnection();
		} catch (NamingException e) {
			e.printStackTrace();
		} // end catch
		return con;
	}

	// OverLoading
	public Connection getConn(String jndiName) throws SQLException {
		Connection con = null;

		try {
			// 1. JNDI사용객체 생성
			Context ctx = new InitialContext();
			// 2. DBCP에서 DataSource 얻기
			DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/" + jndiName);
			// 3. Connection 얻기
			con = ds.getConnection();
		} catch (NamingException e) {
			e.printStackTrace();
		} // end catch
		return con;
	}

	// Close resources method
	public void dbClose(ResultSet rs, PreparedStatement pstmt, Connection con) {
		try {
			if (rs != null) {
				rs.close();
			}
			if (pstmt != null) {
				pstmt.close();
			}
			if (con != null) {
				con.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
