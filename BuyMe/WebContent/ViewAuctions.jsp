<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.util.Date,java.text.SimpleDateFormat,java.text.ParseException"%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="ISO-8859-1">
	<title>BuyMe - Auctions</title>
	</head>
	<style>
      body{
		font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif; 
		font-size: 16px;
        color: rgb(46 45 45 / 85%);
        text-align: center;
        margin-top: 50px;
	  }
	  div{
      	display: flex;
      	flex-direction: row;
      	justify-content: center;
      	align-content: center;
      }
	  h2{
      	font-size: 20px;
        font-weight: 500;
      }
	  table,
      th,
      td {
        padding: 6px;
        border: 2px solid lightgrey;
        border-collapse: collapse;
      }
      th{
      	font-weight: 490;
      }
      	a{
        border-style: initial;
        text-decoration: none;
	    background-color: rgb(230 230 230 / 87%);
	    color: #000000bd;
        border-radius: 15px;
        padding: 0.2rem 0.5rem;
        flex-direction: row; 
     }
      
     a:hover {
        background-color: #ddd;
        color: black;
     }
	</style>
	<body>
		<%//START OF AUCTION UPDATING
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
					if (Float.valueOf(finalPrice) >= Float.valueOf(minPrice) && bc_id != null) {
						PreparedStatement sellsPS = con0.prepareStatement("INSERT INTO Sells (bc_id, sc_id, date, item_id, price) VALUES"
								+ "('"+bc_id+"','"+sc_id+"','"+endDate+"','"+item_id+"','"+finalPrice+"');");
						sellsPS.executeUpdate();
						//Alert the winner that they won the auction
						String winmsg = "You won auction:" + curId + " for item:" + item_id;
						sellsPS = con0.prepareStatement("INSERT INTO Alerts (c_id, message) VALUES ('"+ bc_id +"', '"+ winmsg +"');");
						sellsPS.executeUpdate();
					}
				}
			}
			con0.close();
		//END OF AUCTION UPDATING%>
		<h2>All Ongoing Auctions</h2>
		<br>
		 <% try{
			//get the connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			String str = "SELECT * FROM items it, auctioncontains auc WHERE auc.item_id = it.item_id AND (auc.active IS NULL OR auc.active=true) ";
			ResultSet result = stmt.executeQuery(str);
			
			if (result.next()){
			%>
			
			<div>
			<table>
				<tr>
					<th>Auction ID</th>	<th>Current Bid</th> <th>Highest Bidder Id</th> <th>Min Bid Increment</th> <th>End Date</th> <th>End Time</th>
					<th>Item Category</th> <th>Item Color</th> <th>Item Size</th> <th>Item Description</th>
				</tr>
				
				<!-- parse out the results -->
					<!-- //getting item data -->
					<tr>
						<td><%out.print(result.getString("auction_id"));%></td>
						<td><%out.print(result.getString("current_price"));%></td>
						<td><%out.print(result.getString("highest_bidder_id"));%></td>
						<td><%out.print(result.getString("bid_inc"));%></td>
						<td><%out.print(result.getString("end_time").split(" ")[0]); %></td>
						<td><%out.print(result.getString("end_time").split(" ")[1]); %></td>
						<td><%out.print(result.getString("category"));%></td>
						<td><%out.print(result.getString("color"));%></td>
						<td><%out.print(result.getString("size"));%></td>
						<td><%out.print(result.getString("description"));%></td>
					</tr><%
					while(result.next()){
					//filling out table row
				%>
					<tr>
						<td><%out.print(result.getString("auction_id"));%></td>
						<td><%out.print(result.getString("current_price"));%></td>
						<td><%out.print(result.getString("highest_bidder_id"));%></td>
						<td><%out.print(result.getString("bid_inc"));%></td>
						<td><%out.print(result.getString("end_time").split(" ")[0]); %></td>
						<td><%out.print(result.getString("end_time").split(" ")[1]); %></td>
						<td><%out.print(result.getString("category"));%></td>
						<td><%out.print(result.getString("color"));%></td>
						<td><%out.print(result.getString("size"));%></td>
						<td><%out.print(result.getString("description"));%></td>
					</tr>
				<%}
				//close the connection.
			
				db.closeConnection(con);
				%>
			</table> </div>
			<%}
			else{
				out.println("No auctions present at this time.<br>");
			}
			} catch (Exception e) {
			out.print(e);
			}%>
		<br> <br>
		<% out.println("<a href=\"PlaceBid.jsp\">Click Here to Place a Bid</a>"); %>
		<br><br>
		<% out.println("<a href=\"AutoBid.jsp\">Click Here to Start AutoBiding</a>"); %>
		<br>
			
			
		
	</body>
</html>
