<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>BuyMe - Login</title>
	</head>
	
	<body>

		<h2>Login to BuyMe</h2>
		<form method="POST" action="LoginValidate.jsp">
			<table>
				<tr>
					<td>Username:</td><td><input type="text" name="username"/></td>
				</tr>
				<tr>
					<td>Password:</td><td><input type="text" name="password"/></td>
				</tr>
				<tr>
					<td><input type="submit" value="Sign In"></td><td><a href="CreateAccount.jsp">Create Account</a></td>
				</tr>
			</table>
			
		</form>
		<%	
// 		try {
// 			ApplicationDB db = new ApplicationDB();	
// 			Connection con = db.getConnection();	
// 			Statement stmt = con.createStatement();
// 			String str = "SELECT * FROM Staff";
// 			ResultSet result = stmt.executeQuery(str);
// 			while (result.next()) {
// 				out.println("<p>" + result.getString("name") + "</p>");
// 			}
// 			con.close();
// 		} catch (Exception e) {
// 			out.println("Error!");
// 			e.printStackTrace();
// 		}
		%>

	</body>
</html>