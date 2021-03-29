<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.util.Date,java.text.SimpleDateFormat,java.text.ParseException"%>

<!DOCTYPE html>
<html>
	<head>
	<meta charset="ISO-8859-1">
	<title>Bid History</title>
	</head>
	<style>
	  table,
      th,
      td {
        padding: 6px;
        border: 2px solid lightgrey;
        border-collapse: collapse;
      }
	</style>
	<body>	
			<%
			//close old auctions
			long currTime = new Date().getTime();
			ApplicationDB db0 = new ApplicationDB();
			Connection con0 = db0.getConnection();
			Statement stmt0 = con0.createStatement();
			String q = "SELECT * FROM AuctionContains WHERE active IS NULL OR active=true";
			ResultSet rs0 = stmt0.executeQuery(q);
			while (rs0.next()){
				String cur = rs0.getString("end_time");
				SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", java.util.Locale.getDefault());
				Date date = fmt.parse(cur);
				long endms = date.getTime();
				//System.out.println(currTime);
				//System.out.println(endms);
				if (endms < currTime) {
					//close the expired auction
					String curId = rs0.getString("auction_id");
					PreparedStatement ps = con0.prepareStatement("UPDATE AuctionContains SET active=false WHERE auction_id='"+ curId +"'");
					ps.executeUpdate();
					//add sold item to Sells table
					String minPrice = rs0.getString("min_price");
					
					String bc_id = rs0.getString("highest_bidder_id");
					String sc_id = rs0.getString("creator_id");
					String item_id = rs0.getString("item_id");
					String finalPrice = rs0.getString("current_price");
					String endDate = rs0.getString("end_time");
					//only add item if the highest bid > min price to be sold at and someone actually bidded on it
					if (Float.valueOf(finalPrice) > Float.valueOf(minPrice) && bc_id != null) {
						PreparedStatement sellsPS = con0.prepareStatement("INSERT INTO Sells (bc_id, sc_id, date, item_id, price)"
								+ "('"+bc_id+"','"+sc_id+"','"+endDate+"','"+item_id+"','"+finalPrice+"');");
						sellsPS.executeUpdate();
					}
				}
			}
			con0.close();
		%>
			<div>
			<h2>Search your Items</h2>
					 <label>Sort by </label>
			 <form id = "search" method="POST" action="ViewItems2.jsp">
		       	<select name="Sort" id="sort">
		       	    <option value="inc_price">Decreasing bid price</option>
		   			<option value="dec_pric">Increasing bid price</option>
		   		<!-- 	<option value="auction">Soonest Auction Closing</option> -->
		   		</select>
		        <input type="submit" value="Submit" id="submit" />
		       </form>
		      </div>
			
			<% 
			String sort_func = "Decreasing bid price";
			out.print("Hi");
			String category = request.getParameter("category");
			String color = request.getParameter("color");
			String size = request.getParameter("size");
			String group = "";
			if(sort_func.compareTo("Decreasing bid price")==0){
				group = group.concat("ASC");
			}
			else if(sort_func.compareTo("Increasing bid price")==0){
				group = group.concat("DESC");
			}
			out.print("Helo");
			  try {
					ApplicationDB db = new ApplicationDB();	
					Connection con = db.getConnection();	
					Statement stmt = con.createStatement();
					String str = "SELECT * FROM items, AuctionContains auc WHERE auc.item_id=items.item_id AND auc.active IS NULL OR auc.active=true";
					
					if(color.compareTo("any")==0){
						str = str.concat("AND items.cateogry = '" + category + "AND items.size ="+ size+ "ORDER BY auc.current_price ="+ group+"';");
					}
					else{
						str = str.concat("AND items.cateogry = '" + category +"AND items.color ="+ color + "AND items.size ="+ size+ "ORDER BY auc.current_price ="+ group+"';");
					}
					 
					ResultSet result = stmt.executeQuery(str);
					
					if (result.next()){
						//Valid query - user inputted data
						//"SELECT * FROM AuctionContains auc WHERE auc.active IS NULL OR auc.active=true";
						
						
						out.print("<table>");
						out.print("<tr>");    
							out.print("<th> Item_id </th>");  
							out.print("<th> Cuurent Bid Price </th>");  
					/* 		out.print("<th> Current Highest Bidder Id </th>");   */
							out.print("<th> Auction Id </th>"); 
							out.print("<th> Item Name </th>"); // same as Item Description?
						out.print("</tr>");  
							
						out.print("Helo");
						
						out.print("<tr>");    
						out.print("<td>");
						out.print(result.getString("item_id"));// from table
						out.print("</td>");
						out.print("<td>");
						out.print(result.getString("current_price"));
						out.print("</td>");
					/* 	out.print("<td>");
						out.print(result.getString("creater_id"));
						out.print("</td>"); */
						out.print("<td>");
						out.print(result.getString("auction_id"));
						out.print("</td>");
						out.print("<td>");
						out.print(result.getString("description"));
						out.print("</td>");
						out.print("</tr>");  
						out.print("3336666");
						while (result.next()) { 
							out.print("<tr>");   
							out.print("wwww");
							
							
								out.print("<td>");
								out.print(result.getString("item_id"));// from table
								out.print("</td>");
								
								out.print("<td>");
								out.print(result.getString("current_price"));
								out.print("</td>");
/* 								out.print("<td>");
								out.print(result.getString("creater_id"));
								out.print("</td>"); */
								
								out.print("<td>");
								out.print(result.getString("auction_id"));
								out.print("</td>");
								
								out.print("<td>");
								out.print(result.getString("description"));
								out.print("</td>");
	 
							out.print("</tr>");  
							
						}
						out.print("</table>");
						
						
					} else {
						//InValid query
						out.println("We have no items available at this time with the matching search requirements.");
						out.println("<br>");
					}
					con.close();
				} catch (Exception e) {
					out.println("Error! ");
					e.printStackTrace();
				}
	    out.println("<br>");
		out.println("<a href=\"CustomerHome.jsp\"> Back to Home Page");
		%>
	    </body>
	   </html>
	    
